// lib/services/tax_service.dart

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../config/api_constants.dart';

class TaxService {
  final Dio _dio;

  TaxService(this._dio) {
    _dio.options.baseUrl = ApiConstants.baseUrl;
    _dio.options.connectTimeout =
        const Duration(seconds: 30); // Longer timeout for document uploads
    _dio.options.receiveTimeout = const Duration(seconds: 30);
  }

  Future<Map<String, dynamic>> getTaxSummary() async {
    try {
      final response = await _dio.get(ApiConstants.taxSummary);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to fetch tax summary: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to fetch tax summary');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch tax summary: $e');
    }
  }

  Future<Map<String, dynamic>> calculateTaxLiability(
      String financialYear) async {
    try {
      final response = await _dio.post(
        ApiConstants.calculateTax,
        data: {'financial_year': financialYear},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to calculate tax liability: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to calculate tax liability');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to calculate tax liability: $e');
    }
  }

  Future<void> uploadDocument(
      String type, String filePath, Map<String, dynamic> metadata) async {
    final file = File(filePath);
    final fileName = file.path.split('/').last;
    final extension = fileName.split('.').last.toLowerCase();

    // Determine content type
    String contentType;
    switch (extension) {
      case 'pdf':
        contentType = 'application/pdf';
        break;
      case 'jpg':
      case 'jpeg':
        contentType = 'image/jpeg';
        break;
      case 'png':
        contentType = 'image/png';
        break;
      default:
        contentType = 'application/octet-stream';
    }

    // Create form data
    final formData = FormData.fromMap({
      'type': type,
      'metadata': metadata,
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: MediaType.parse(contentType),
      ),
    });

    try {
      final response = await _dio.post(
        ApiConstants.uploadDocument,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to upload document: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to upload document');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getDocuments(String financialYear) async {
    try {
      final response = await _dio.get(
        ApiConstants.documents,
        queryParameters: {'financial_year': financialYear},
      );

      if (response.statusCode == 200) {
        final documents = response.data['documents'] as List;
        return List<Map<String, dynamic>>.from(documents);
      } else {
        throw Exception('Failed to fetch documents: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to fetch documents');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to fetch documents: $e');
    }
  }

  Future<void> generateITR(String financialYear) async {
    try {
      final response = await _dio.post(
        ApiConstants.generateITR,
        data: {'financial_year': financialYear},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate ITR: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to generate ITR');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to generate ITR: $e');
    }
  }

  Future<Map<String, dynamic>> getTaxSavingSuggestions() async {
    try {
      final response = await _dio.get(ApiConstants.taxSavingSuggestions);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to get tax saving suggestions: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ??
            'Failed to get tax saving suggestions');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get tax saving suggestions: $e');
    }
  }

  Future<Map<String, dynamic>> getITRFormDetails(String itrId) async {
    try {
      final response = await _dio.get('${ApiConstants.itrForms}/$itrId');

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception(
            'Failed to get ITR form details: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to get ITR form details');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to get ITR form details: $e');
    }
  }

  Future<void> updateITRFormData(
      String itrId, Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(
        '${ApiConstants.itrForms}/$itrId',
        data: data,
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to update ITR form data: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
            e.response?.data['message'] ?? 'Failed to update ITR form data');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Failed to update ITR form data: $e');
    }
  }
}
