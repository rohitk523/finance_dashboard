// lib/providers/transaction_provider.dart

import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionService _transactionService;

  List<Transaction> _transactions = [];
  List<Transaction> _recentTransactions = [];
  bool _isLoading = false;
  String? _error;

  TransactionProvider(this._transactionService);

  // Getters
  List<Transaction> get transactions => _transactions;
  List<Transaction> get recentTransactions => _recentTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalIncome => _transactions
      .where((transaction) => transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  double get totalExpense => _transactions
      .where((transaction) => !transaction.isIncome)
      .fold(0, (sum, transaction) => sum + transaction.amount);

  Map<String, double> get expensesByCategory {
    final map = <String, double>{};
    for (final transaction in _transactions) {
      if (!transaction.isIncome) {
        if (map.containsKey(transaction.category)) {
          map[transaction.category] =
              (map[transaction.category] ?? 0) + transaction.amount;
        } else {
          map[transaction.category] = transaction.amount;
        }
      }
    }
    return map;
  }

  Map<String, double> get taxDeductibleAmount {
    final map = <String, double>{};
    for (final transaction in _transactions) {
      if (transaction.isTaxDeductible == true &&
          transaction.taxSection != null) {
        if (map.containsKey(transaction.taxSection)) {
          map[transaction.taxSection!] =
              (map[transaction.taxSection!] ?? 0) + transaction.amount;
        } else {
          map[transaction.taxSection!] = transaction.amount;
        }
      }
    }
    return map;
  }

  List<Map<String, dynamic>> get monthlyIncome {
    // Group income by month
    final monthlyData = <DateTime, double>{};
    for (final transaction in _transactions) {
      if (transaction.isIncome) {
        final month =
            DateTime(transaction.date.year, transaction.date.month, 1);
        if (monthlyData.containsKey(month)) {
          monthlyData[month] = (monthlyData[month] ?? 0) + transaction.amount;
        } else {
          monthlyData[month] = transaction.amount;
        }
      }
    }

    // Convert to list of maps
    return monthlyData.entries
        .map((entry) => {'date': entry.key, 'amount': entry.value})
        .toList()
      ..sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
  }

  List<Map<String, dynamic>> get monthlyExpense {
    // Group expenses by month
    final monthlyData = <DateTime, double>{};
    for (final transaction in _transactions) {
      if (!transaction.isIncome) {
        final month =
            DateTime(transaction.date.year, transaction.date.month, 1);
        if (monthlyData.containsKey(month)) {
          monthlyData[month] = (monthlyData[month] ?? 0) + transaction.amount;
        } else {
          monthlyData[month] = transaction.amount;
        }
      }
    }

    // Convert to list of maps
    return monthlyData.entries
        .map((entry) => {'date': entry.key, 'amount': entry.value})
        .toList()
      ..sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
  }

  // Methods
  Future<void> fetchTransactions() async {
    _setLoading(true);

    try {
      final transactions = await _transactionService.getTransactions();
      _transactions = transactions;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch transactions: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchRecentTransactions() async {
    _setLoading(true);

    try {
      final transactions = await _transactionService.getRecentTransactions();
      _recentTransactions = transactions;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch recent transactions: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Transaction?> getTransactionById(String id) async {
    try {
      return await _transactionService.getTransactionById(id);
    } catch (e) {
      _setError('Failed to get transaction details: $e');
      return null;
    }
  }

  Future<void> addTransaction(Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      final newTransaction = await _transactionService.addTransaction(data);
      _transactions.add(newTransaction);
      _transactions.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    } catch (e) {
      _setError('Failed to add transaction: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTransaction(String id, Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      final updatedTransaction =
          await _transactionService.updateTransaction(id, data);
      final index = _transactions.indexWhere((t) => t.id == id);
      if (index != -1) {
        _transactions[index] = updatedTransaction;
        _transactions.sort((a, b) => b.date.compareTo(a.date));
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update transaction: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTransaction(String id) async {
    _setLoading(true);

    try {
      await _transactionService.deleteTransaction(id);
      _transactions.removeWhere((t) => t.id == id);
      _recentTransactions.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete transaction: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Transaction>> searchTransactions(String query) async {
    try {
      return await _transactionService.searchTransactions(query);
    } catch (e) {
      _setError('Failed to search transactions: $e');
      return [];
    }
  }

  Future<List<Transaction>> filterTransactions({
    DateTime? startDate,
    DateTime? endDate,
    String? category,
    bool? isIncome,
    bool? isTaxDeductible,
    String? taxSection,
  }) async {
    try {
      return await _transactionService.filterTransactions(
        startDate: startDate,
        endDate: endDate,
        category: category,
        isIncome: isIncome,
        isTaxDeductible: isTaxDeductible,
        taxSection: taxSection,
      );
    } catch (e) {
      _setError('Failed to filter transactions: $e');
      return [];
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _error = errorMessage;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
