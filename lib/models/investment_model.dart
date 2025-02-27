// lib/models/investment_model.dart

class Investment {
  final String id;
  final String name;
  final String type;
  final double investedAmount;
  final double currentValue;
  final double units;
  final double latestPrice;
  final DateTime purchaseDate;
  final List<Map<String, dynamic>>? transactionHistory;
  final String? accountNumber;
  final String? folio;
  final String? notes;
  final bool? isTaxSaving;
  final String? taxSection;

  Investment({
    required this.id,
    required this.name,
    required this.type,
    required this.investedAmount,
    required this.currentValue,
    required this.units,
    required this.latestPrice,
    required this.purchaseDate,
    this.transactionHistory,
    this.accountNumber,
    this.folio,
    this.notes,
    this.isTaxSaving,
    this.taxSection,
  });

  factory Investment.fromJson(Map<String, dynamic> json) {
    return Investment(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      investedAmount: json['investedAmount'].toDouble(),
      currentValue: json['currentValue'].toDouble(),
      units: json['units'].toDouble(),
      latestPrice: json['latestPrice'].toDouble(),
      purchaseDate: DateTime.parse(json['purchaseDate']),
      transactionHistory: json['transactionHistory'] != null
          ? List<Map<String, dynamic>>.from(json['transactionHistory'])
          : null,
      accountNumber: json['accountNumber'],
      folio: json['folio'],
      notes: json['notes'],
      isTaxSaving: json['isTaxSaving'],
      taxSection: json['taxSection'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'investedAmount': investedAmount,
      'currentValue': currentValue,
      'units': units,
      'latestPrice': latestPrice,
      'purchaseDate': purchaseDate.toIso8601String(),
      'transactionHistory': transactionHistory,
      'accountNumber': accountNumber,
      'folio': folio,
      'notes': notes,
      'isTaxSaving': isTaxSaving,
      'taxSection': taxSection,
    };
  }

  Investment copyWith({
    String? id,
    String? name,
    String? type,
    double? investedAmount,
    double? currentValue,
    double? units,
    double? latestPrice,
    DateTime? purchaseDate,
    List<Map<String, dynamic>>? transactionHistory,
    String? accountNumber,
    String? folio,
    String? notes,
    bool? isTaxSaving,
    String? taxSection,
  }) {
    return Investment(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      investedAmount: investedAmount ?? this.investedAmount,
      currentValue: currentValue ?? this.currentValue,
      units: units ?? this.units,
      latestPrice: latestPrice ?? this.latestPrice,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      transactionHistory: transactionHistory ?? this.transactionHistory,
      accountNumber: accountNumber ?? this.accountNumber,
      folio: folio ?? this.folio,
      notes: notes ?? this.notes,
      isTaxSaving: isTaxSaving ?? this.isTaxSaving,
      taxSection: taxSection ?? this.taxSection,
    );
  }

  double get returns {
    return currentValue - investedAmount;
  }

  double get returnsPercentage {
    if (investedAmount == 0) return 0;
    return (returns / investedAmount) * 100;
  }
}
