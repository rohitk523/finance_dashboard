// lib/models/transaction_model.dart

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final String category;
  final String? subcategory;
  final bool isIncome;
  final String paymentMethod;
  final String? accountNumber;
  final String? upiId;
  final String? notes;
  final String? receiptUrl;
  final bool? isTaxDeductible;
  final String? taxSection;
  final String? financialYear;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.category,
    this.subcategory,
    required this.isIncome,
    required this.paymentMethod,
    this.accountNumber,
    this.upiId,
    this.notes,
    this.receiptUrl,
    this.isTaxDeductible,
    this.taxSection,
    this.financialYear,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      amount: json['amount'].toDouble(),
      date: DateTime.parse(json['date']),
      category: json['category'],
      subcategory: json['subcategory'],
      isIncome: json['isIncome'],
      paymentMethod: json['paymentMethod'],
      accountNumber: json['accountNumber'],
      upiId: json['upiId'],
      notes: json['notes'],
      receiptUrl: json['receiptUrl'],
      isTaxDeductible: json['isTaxDeductible'],
      taxSection: json['taxSection'],
      financialYear: json['financialYear'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'subcategory': subcategory,
      'isIncome': isIncome,
      'paymentMethod': paymentMethod,
      'accountNumber': accountNumber,
      'upiId': upiId,
      'notes': notes,
      'receiptUrl': receiptUrl,
      'isTaxDeductible': isTaxDeductible,
      'taxSection': taxSection,
      'financialYear': financialYear,
    };
  }

  Transaction copyWith({
    String? id,
    String? description,
    double? amount,
    DateTime? date,
    String? category,
    String? subcategory,
    bool? isIncome,
    String? paymentMethod,
    String? accountNumber,
    String? upiId,
    String? notes,
    String? receiptUrl,
    bool? isTaxDeductible,
    String? taxSection,
    String? financialYear,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      isIncome: isIncome ?? this.isIncome,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      accountNumber: accountNumber ?? this.accountNumber,
      upiId: upiId ?? this.upiId,
      notes: notes ?? this.notes,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      isTaxDeductible: isTaxDeductible ?? this.isTaxDeductible,
      taxSection: taxSection ?? this.taxSection,
      financialYear: financialYear ?? this.financialYear,
    );
  }
}
