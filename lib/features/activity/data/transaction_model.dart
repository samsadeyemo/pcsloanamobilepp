class Transaction {
  final String title;
  final String dateTime;
  final String amount;
  final bool isCredit;

  Transaction({
    required this.title,
    required this.dateTime,
    required this.amount,
    required this.isCredit,
  });
}
