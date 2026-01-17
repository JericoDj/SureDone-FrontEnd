enum TransactionType { credit, debit }

class WalletTransaction {
  final String id;
  final String description;
  final String date;
  final double amount;
  final TransactionType type;

  const WalletTransaction({
    required this.id,
    required this.description,
    required this.date,
    required this.amount,
    required this.type,
  });
}
