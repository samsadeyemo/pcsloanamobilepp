import 'package:intl/intl.dart';

class Transaction {
  final String title;
  final String dateTime;
  final String amount;
  final bool isCredit;
  final String? reference;
  final String? status;
  final String? paymentMethod;

  Transaction({
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.isCredit,
    this.reference,
    this.status,
    this.paymentMethod,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Amount comes back as a String from the API, e.g. "300000.00"
    final rawAmount = json['amount'];
    final double parsedAmount = rawAmount is String
        ? double.tryParse(rawAmount) ?? 0.0
        : (rawAmount is num ? rawAmount.toDouble() : 0.0);

    final String type = (json['type'] ?? '').toString().toUpperCase();

    // Adjust this set once you know every `type` value your backend sends
    const creditTypes = {'DISBURSEMENT', 'REFUND', 'CREDIT'};
    final bool isCredit = creditTypes.contains(type);

    final DateTime? parsedDate = DateTime.tryParse(
      json['createdAt']?.toString() ?? '',
    );
    final String formattedDate = parsedDate != null
        ? DateFormat('MMM d, yyyy • h:mm a').format(parsedDate)
        : '';

    final formatter = NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    );
    final String formattedAmount =
        '${isCredit ? '+' : '-'}${formatter.format(parsedAmount)}';

    return Transaction(
      title: _titleFromType(type),
      dateTime: formattedDate,
      amount: formattedAmount,
      isCredit: isCredit,
      reference: json['reference']?.toString(),
      status: json['status']?.toString(),
      paymentMethod: json['payment_method']?.toString(),
    );
  }

  static String _titleFromType(String type) {
    switch (type) {
      case 'DISBURSEMENT':
        return 'Loan Disbursement';
      case 'REPAYMENT':
        return 'Loan Repayment';
      case 'FEE':
        return 'Processing Fee';
      case 'PENALTY':
        return 'Penalty Charge';
      default:
        return type.isEmpty ? 'Transaction' : type;
    }
  }
}