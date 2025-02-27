// lib/providers/investment_provider.dart

import 'package:flutter/material.dart';
import '../models/investment_model.dart';
import '../services/investment_service.dart';

class InvestmentProvider with ChangeNotifier {
  final InvestmentService _investmentService;

  List<Investment> _investments = [];
  bool _isLoading = false;
  String? _error;

  InvestmentProvider(this._investmentService);

  // Getters
  List<Investment> get investments => _investments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get totalInvestmentValue =>
      _investments.fold(0, (sum, investment) => sum + investment.currentValue);

  double get totalInvestedAmount => _investments.fold(
      0, (sum, investment) => sum + investment.investedAmount);

  Map<String, double> get investmentsByType {
    final map = <String, double>{};
    for (final investment in _investments) {
      if (map.containsKey(investment.type)) {
        map[investment.type] =
            (map[investment.type] ?? 0) + investment.currentValue;
      } else {
        map[investment.type] = investment.currentValue;
      }
    }
    return map;
  }

  List<Investment> get topInvestments {
    final sortedInvestments = List<Investment>.from(_investments)
      ..sort((a, b) => b.currentValue.compareTo(a.currentValue));

    return sortedInvestments.take(3).toList();
  }

  List<Map<String, dynamic>> get investmentPerformance {
    // Get historical performance data for all investments combined
    // This is a simplified implementation - in a real app, you would aggregate data
    // from all investments to create a monthly performance chart

    final performance = <DateTime, double>{};
    final now = DateTime.now();

    // Create data for the last 12 months
    for (int i = 11; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      // Calculate a mock value for demonstration
      // In a real app, this would come from historical data
      double total = 0;
      for (final investment in _investments) {
        // Mock calculation for demonstration
        final monthsSincePurchase =
            month.difference(investment.purchaseDate).inDays / 30;
        if (monthsSincePurchase >= 0) {
          // Apply a simple growth model for demonstration
          final growthFactor = 1 +
              (investment.returnsPercentage / 100 / 12 * monthsSincePurchase);
          total += investment.investedAmount * growthFactor;
        }
      }
      performance[month] = total;
    }

    // Convert to list of maps
    return performance.entries
        .map((entry) => {'date': entry.key, 'value': entry.value})
        .toList()
      ..sort(
          (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));
  }

  double get overallReturn {
    if (totalInvestedAmount == 0) return 0;
    return ((totalInvestmentValue - totalInvestedAmount) /
            totalInvestedAmount) *
        100;
  }

  double get yearToDateReturn {
    // In a real app, this would calculate YTD return based on Jan 1st values
    // For demonstration, we'll return a simplified calculation
    return overallReturn * 0.7; // Mock calculation
  }

  double get monthToDateReturn {
    // In a real app, this would calculate MTD return based on month start values
    // For demonstration, we'll return a simplified calculation
    return overallReturn * 0.2; // Mock calculation
  }

  // Methods
  Future<void> fetchInvestments() async {
    _setLoading(true);

    try {
      final investments = await _investmentService.getInvestments();
      _investments = investments;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch investments: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchInvestmentSummary() async {
    _setLoading(true);

    try {
      final investments = await _investmentService.getInvestments();
      _investments = investments;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch investment summary: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Investment?> getInvestmentById(String id) async {
    try {
      return await _investmentService.getInvestmentById(id);
    } catch (e) {
      _setError('Failed to get investment details: $e');
      return null;
    }
  }

  Future<void> addInvestment(Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      final newInvestment = await _investmentService.addInvestment(data);
      _investments.add(newInvestment);
      notifyListeners();
    } catch (e) {
      _setError('Failed to add investment: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateInvestment(String id, Map<String, dynamic> data) async {
    _setLoading(true);

    try {
      final updatedInvestment =
          await _investmentService.updateInvestment(id, data);
      final index = _investments.indexWhere((i) => i.id == id);
      if (index != -1) {
        _investments[index] = updatedInvestment;
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to update investment: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteInvestment(String id) async {
    _setLoading(true);

    try {
      await _investmentService.deleteInvestment(id);
      _investments.removeWhere((i) => i.id == id);
      notifyListeners();
    } catch (e) {
      _setError('Failed to delete investment: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateInvestmentValues() async {
    _setLoading(true);

    try {
      await _investmentService.updateInvestmentValues();
      await fetchInvestments(); // Reload investments with updated values
    } catch (e) {
      _setError('Failed to update investment values: $e');
    } finally {
      _setLoading(false);
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
