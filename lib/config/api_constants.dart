// lib/config/api_constants.dart

class ApiConstants {
  // Base URL
  // static const String baseUrl = 'https://api.finance-dashboard.example.com/api/v1';
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String verifyToken = '/auth/verify';
  static const String resetPassword = '/auth/reset-password';
  static const String changePassword = '/auth/change-password';
  static const String updateProfile = '/auth/profile';

  // Transaction endpoints
  static const String transactions = '/transactions';
  static const String transactionCategories = '/transactions/categories';

  // Investment endpoints
  static const String investments = '/investments';
  static const String investmentTypes = '/investments/types';
  static const String updateInvestmentValues = '/investments/update-values';
  static const String investmentInsights = '/investments/insights';

  // Tax endpoints
  static const String taxSummary = '/tax/summary';
  static const String calculateTax = '/tax/calculate';
  static const String documents = '/tax/documents';
  static const String uploadDocument = '/tax/documents/upload';
  static const String generateITR = '/tax/generate-itr';
  static const String itrForms = '/tax/itr-forms';
  static const String taxSavingSuggestions = '/tax/saving-suggestions';

  // AI Assistant endpoint
  static const String aiAssistant = '/ai/assistant';
}
