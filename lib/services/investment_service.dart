// lib/services/investment_service.dart

import 'package:dio/dio.dart';
import '../models/investment_model.dart';
import '../config/api_constants.dart';

class InvestmentService {
  final Dio _dio;

  InvestmentService(this._dio) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<List<Investment>> getInvestments() async {
    try {
      final response = await _dio.get(ApiConstants.investments);

      if (response.statusCode == 200) {
        final investments = response.data['investments'] as List;
        return investments.map((json) => Investment.fromJson(json)).toList();
      } else {
        throw Exception(
            'Failed to fetch investments: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to fetch investments');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch investments: $e');
    }
  }

  Future<Investment> getInvestmentById(String id) async {
    try {
      final response = await _dio.get('${ApiConstants.investments}/$id');

      if (response.statusCode == 200) {
        return Investment.fromJson(response.data['investment']);
      } else {
        throw Exception(
            'Failed to fetch investment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to fetch investment');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch investment: $e');
    }
  }

  Future<Investment> addInvestment(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        ApiConstants.investments,
        data: data,
      );

      if (response.statusCode == 201) {
        return Investment.fromJson(response.data['investment']);
      } else {
        throw Exception('Failed to add investment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to add investment');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to add investment: $e');
    }
  }

  Future<Investment> updateInvestment(
      String id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.investments}/$id',
        data: data,
      );

      if (response.statusCode == 200) {
        return Investment.fromJson(response.data['investment']);
      } else {
        throw Exception(
            'Failed to update investment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to update investment');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update investment: $e');
    }
  }

  Future<void> deleteInvestment(String id) async {
    try {
      final response = await _dio.delete('${ApiConstants.investments}/$id');

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to delete investment: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to delete investment');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to delete investment: $e');
    }
  }

  Future<void> updateInvestmentValues() async {
    try {
      final response = await _dio.post(ApiConstants.updateInvestmentValues);

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update investment values: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ??
            'Failed to update investment values');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update investment values: $e');
    }
  }

  Future<Map<String, dynamic>> getInvestmentPerformance(String id) async {
    try {
      final response =
          await _dio.get('${ApiConstants.investments}/$id/performance');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to fetch investment performance: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ??
            'Failed to fetch investment performance');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch investment performance: $e');
    }
  }

  Future<Map<String, dynamic>> getInvestmentInsights() async {
    try {
      final response = await _dio.get(ApiConstants.investmentInsights);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to fetch investment insights: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ??
            'Failed to fetch investment insights');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch investment insights: $e');
    }
  }
}
