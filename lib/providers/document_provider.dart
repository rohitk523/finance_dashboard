// lib/providers/document_provider.dart

import 'package:flutter/material.dart';
import 'dart:io';
import '../services/tax_service.dart';

class DocumentProvider with ChangeNotifier {
  final TaxService? _taxService;

  List<Map<String, dynamic>> _documents = [];
  bool _isLoading = false;
  String? _error;

  DocumentProvider([this._taxService]);

  // Getters
  List<Map<String, dynamic>> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Methods
  Future<void> fetchDocuments(String financialYear) async {
    if (_taxService == null) return;

    _setLoading(true);

    try {
      final docs = await _taxService!.getDocuments(financialYear);
      _documents = docs;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch documents: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> uploadDocument({
    required String type,
    required File file,
    required String financialYear,
    Map<String, dynamic>? additionalMetadata,
  }) async {
    if (_taxService == null) return;

    _setLoading(true);

    try {
      final metadata = {
        'financial_year': financialYear,
        ...?additionalMetadata,
      };

      await _taxService!.uploadDocument(type, file.path, metadata);

      // Refresh documents list
      await fetchDocuments(financialYear);

      notifyListeners();
    } catch (e) {
      _setError('Failed to upload document: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteDocument(String documentId, String financialYear) async {
    if (_taxService == null) return;

    _setLoading(true);

    try {
      // API call to delete document would go here
      // await _taxService.deleteDocument(documentId);

      // For now, just remove from local state
      _documents.removeWhere((doc) => doc['id'] == documentId);

      notifyListeners();
    } catch (e) {
      _setError('Failed to delete document: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Map<String, List<Map<String, dynamic>>> getDocumentsByType() {
    final documentsByType = <String, List<Map<String, dynamic>>>{};

    for (final doc in _documents) {
      final type = doc['type'] as String;
      if (!documentsByType.containsKey(type)) {
        documentsByType[type] = [];
      }
      documentsByType[type]!.add(doc);
    }

    return documentsByType;
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
