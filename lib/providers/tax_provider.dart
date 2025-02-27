// lib/providers/tax_provider.dart

import 'package:flutter/material.dart';
import '../services/tax_service.dart';

class TaxProvider with ChangeNotifier {
  final TaxService _taxService;

  Map<String, dynamic> _taxSummary = {};
  bool _isLoading = false;
  String? _error;

  TaxProvider(this._taxService);

  // Getters
  Map<String, dynamic> get taxSummary => _taxSummary;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Methods
  Future<void> fetchTaxStatus() async {
    _setLoading(true);

    try {
      final summary = await _taxService.getTaxSummary();
      _taxSummary = summary;
      notifyListeners();
    } catch (e) {
      _setError('Failed to fetch tax status: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> calculateTaxLiability(
      String financialYear) async {
    _setLoading(true);

    try {
      final liability = await _taxService.calculateTaxLiability(financialYear);
      return liability;
    } catch (e) {
      _setError('Failed to calculate tax liability: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> uploadDocument(
      String type, String filePath, Map<String, dynamic> metadata) async {
    _setLoading(true);

    try {
      await _taxService.uploadDocument(type, filePath, metadata);
      notifyListeners();
    } catch (e) {
      _setError('Failed to upload document: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Map<String, dynamic>>> getDocuments(String financialYear) async {
    _setLoading(true);

    try {
      return await _taxService.getDocuments(financialYear);
    } catch (e) {
      _setError('Failed to fetch documents: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> generateITR(String financialYear) async {
    _setLoading(true);

    try {
      await _taxService.generateITR(financialYear);
      await fetchTaxStatus(); // Refresh tax status after generating ITR
    } catch (e) {
      _setError('Failed to generate ITR: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<Map<String, dynamic>> getTaxSavingSuggestions() async {
    _setLoading(true);

    try {
      return await _taxService.getTaxSavingSuggestions();
    } catch (e) {
      _setError('Failed to get tax saving suggestions: $e');
      return {};
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
