// lib/services/transaction_service.dart

import 'package:dio/dio.dart';
import '../models/transaction_model.dart';
import '../config/api_constants.dart';

class TransactionService {
  final Dio _dio;

  TransactionService(this._dio) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await _dio.get(ApiConstants.transactions);

      if (response.statusCode == 200) {
        final transactions = response.data['transactions'] as List;
        return transactions.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch transactions: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to fetch transactions');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  Future<List<Transaction>> getRecentTransactions() async {
    try {
      final response = await _dio.get('${ApiConstants.transactions}/recent');

      if (response.statusCode == 200) {
        final transactions = response.data['transactions'] as List;
        return transactions.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch recent transactions: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ??
            'Failed to fetch recent transactions');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch recent transactions: $e');
    }
  }

  Future<Transaction> getTransactionById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.transactions}/$id');

      if (response.statusCode == 200) {
        return Transaction.fromJson(response.data['transaction']);
      } else {
        throw Exception(
            'Failed to fetch transaction: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to fetch transaction');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch transaction: $e');
    }
  }

  Future<Transaction> addTransaction(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        ApiConstants.transactions,
        data: data,
      );

      if (response.statusCode == 201) {
        return Transaction.fromJson(response.data['transaction']);
      } else {
        throw Exception('Failed to add transaction: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to add transaction');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  Future<Transaction> updateTransaction(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.transactions}/$id',
        data: data,
      );

      if (response.statusCode == 200) {
        return Transaction.fromJson(response.data['transaction']);
      } else {
        throw Exception(
            'Failed to update transaction: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to update transaction');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update transaction: $e');
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final response = await _dio.delete('${ApiConstants.transactions}/$id');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete transaction: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to delete transaction');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to delete transaction: $e');
    }
  }

  Future<List<Transaction>> searchTransactions(String query) async {
    try {
      final response = await _dio.get(
        ApiConstants.transactions,
        queryParameters: {'search': query},
      );

      if (response.statusCode == 200) {
        final transactions = response.data['transactions'] as List;
        return transactions.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to search transactions: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to search transactions');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to search transactions: $e');
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
    final queryParams = <String, dynamic>{};

    if (startDate != null) {
      queryParams['start_date'] = startDate.toIso8601String();
    }
    if (endDate != null) {
      queryParams['end_date'] = endDate.toIso8601String();
    }
    if (category != null) {
      queryParams['category'] = category;
    }
    if (isIncome != null) {
      queryParams['is_income'] = isIncome;
    }
    if (isTaxDeductible != null) {
      queryParams['is_tax_deductible'] = isTaxDeductible;
    }
    if (taxSection != null) {
      queryParams['tax_section'] = taxSection;
    }

    try {
      final response = await _dio.get(
        ApiConstants.transactions,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final transactions = response.data['transactions'] as List;
        return transactions.map((json) => Transaction.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to filter transactions: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to filter transactions');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to filter transactions: $e');
    }
  }
}
