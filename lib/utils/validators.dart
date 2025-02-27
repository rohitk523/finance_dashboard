// lib/utils/validators.dart

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }

  final emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  if (!emailRegExp.hasMatch(value)) {
    return 'Please enter a valid email address';
  }

  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password is required';
  }

  if (value.length < 8) {
    return 'Password must be at least 8 characters';
  }

  // Check for at least one letter, one number, and one special character
  final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
  final hasNumber = RegExp(r'[0-9]').hasMatch(value);
  final hasSpecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

  if (!hasLetter || !hasNumber || !hasSpecial) {
    return 'Password must include letters, numbers, and symbols';
  }

  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }

  // Remove any non-digit characters for validation
  final digitsOnly = value.replaceAll(RegExp(r'\D'), '');

  // Check if the phone number has at least 10 digits (standard for India)
  if (digitsOnly.length < 10) {
    return 'Please enter a valid phone number';
  }

  return null;
}

String? validateAmount(String? value) {
  if (value == null || value.isEmpty) {
    return 'Amount is required';
  }

  final doubleValue = double.tryParse(value);
  if (doubleValue == null) {
    return 'Please enter a valid amount';
  }

  if (doubleValue <= 0) {
    return 'Amount must be greater than zero';
  }

  return null;
}

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName is required';
  }
  return null;
}

String? validatePAN(String? value) {
  if (value == null || value.isEmpty) {
    return 'PAN is required';
  }

  // PAN format: AAAPL1234C (5 alphabets, 4 numbers, 1 alphabet)
  final panRegExp = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');

  if (!panRegExp.hasMatch(value)) {
    return 'Please enter a valid PAN';
  }

  return null;
}

String? validateAadhaar(String? value) {
  if (value == null || value.isEmpty) {
    return 'Aadhaar number is required';
  }

  // Remove spaces for validation
  final digitsOnly = value.replaceAll(RegExp(r'\s'), '');

  // Aadhaar number is 12 digits
  if (digitsOnly.length != 12 || !RegExp(r'^[0-9]{12}$').hasMatch(digitsOnly)) {
    return 'Please enter a valid 12-digit Aadhaar number';
  }

  return null;
}
// Completing lib/utils/validators.dart

String? validateGST(String? value) {
  if (value == null || value.isEmpty) {
    return null; // GST may be optional
  }

  // GST format: 22AAAAA0000A1Z5
  final gstRegExp =
      RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$');

  if (!gstRegExp.hasMatch(value)) {
    return 'Please enter a valid GST number';
  }

  return null;
}

String? validateIFSC(String? value) {
  if (value == null || value.isEmpty) {
    return 'IFSC code is required';
  }

  // IFSC format: SBIN0000123 (4 chars for bank, 0, 6 alphanumeric)
  final ifscRegExp = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

  if (!ifscRegExp.hasMatch(value)) {
    return 'Please enter a valid IFSC code';
  }

  return null;
}

String? validateAccountNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Account number is required';
  }

  // Account numbers are numeric and typically 9-18 digits in India
  final digitsOnly = value.replaceAll(RegExp(r'\s'), '');

  if (digitsOnly.length < 9 ||
      digitsOnly.length > 18 ||
      !RegExp(r'^[0-9]+$').hasMatch(digitsOnly)) {
    return 'Please enter a valid account number';
  }

  return null;
}

String? validateUPI(String? value) {
  if (value == null || value.isEmpty) {
    return null; // UPI may be optional
  }

  // UPI format: username@bankcode or phone@bankcode
  final upiRegExp = RegExp(r'^[a-zA-Z0-9_.-]+@[a-zA-Z0-9]+$');

  if (!upiRegExp.hasMatch(value)) {
    return 'Please enter a valid UPI ID';
  }

  return null;
}

String? validateDate(String? value) {
  if (value == null || value.isEmpty) {
    return 'Date is required';
  }

  try {
    final date = DateTime.parse(value);
    final now = DateTime.now();
    if (date.isAfter(now)) {
      return 'Date cannot be in the future';
    }
    return null;
  } catch (e) {
    return 'Please enter a valid date';
  }
}

String? validateInvestmentAmount(String? value, double minAmount) {
  if (value == null || value.isEmpty) {
    return 'Amount is required';
  }

  final doubleValue = double.tryParse(value);
  if (doubleValue == null) {
    return 'Please enter a valid amount';
  }

  if (doubleValue < minAmount) {
    return 'Amount must be at least ${minAmount.toStringAsFixed(0)}';
  }

  return null;
}

String? validateDocumentFileSize(int sizeInBytes, int maxSizeInMB) {
  final sizeInMB = sizeInBytes / (1024 * 1024);
  if (sizeInMB > maxSizeInMB) {
    return 'File size exceeds the maximum limit of $maxSizeInMB MB';
  }
  return null;
}

String? validateDocumentFileType(
    String fileName, List<String> allowedExtensions) {
  final extension = fileName.split('.').last.toLowerCase();
  if (!allowedExtensions.contains(extension)) {
    return 'Only ${allowedExtensions.join(', ')} files are allowed';
  }
  return null;
}
