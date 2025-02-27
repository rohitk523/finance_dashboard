// lib/services/ai_assistant_service.dart

import 'package:dio/dio.dart';
import '../config/api_constants.dart';

class AIAssistantService {
  final Dio _dio;

  AIAssistantService(this._dio) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<Map<String, dynamic>> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        ApiConstants.aiAssistant,
        data: {
          'message': message,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get AI response: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to get AI response');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get AI response: $e');
    }
  }

  Future<Map<String, dynamic>> analyzeExpenses() async {
    try {
      final response =
          await _dio.get('${ApiConstants.aiAssistant}/analyze-expenses');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to analyze expenses: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to analyze expenses');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to analyze expenses: $e');
    }
  }

  Future<Map<String, dynamic>> getTaxAdvice() async {
    try {
      final response = await _dio.get('${ApiConstants.aiAssistant}/tax-advice');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to get tax advice: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to get tax advice');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get tax advice: $e');
    }
  }

  Future<Map<String, dynamic>> getInvestmentRecommendations() async {
    try {
      final response = await _dio
          .get('${ApiConstants.aiAssistant}/investment-recommendations');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to get investment recommendations: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ??
            'Failed to get investment recommendations');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get investment recommendations: $e');
    }
  }
}
