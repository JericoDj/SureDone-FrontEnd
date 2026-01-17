import 'package:flutter/material.dart';
import 'package:suredone/features/wallet/domain/transaction.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<WalletTransaction> transactions = [
      WalletTransaction(
        id: '1',
        description: 'Top Up',
        date: 'Today, 10:00 AM',
        amount: 50.00,
        type: TransactionType.credit,
      ),
      WalletTransaction(
        id: '2',
        description: 'Payment to Alice Cleaner',
        date: 'Yesterday, 2:00 PM',
        amount: 35.50,
        type: TransactionType.debit,
      ),
      WalletTransaction(
        id: '3',
        description: 'Refund',
        date: 'Jan 15, 2025',
        amount: 15.00,
        type: TransactionType.credit,
      ),
       WalletTransaction(
        id: '4',
        description: 'Payment to FastMart',
        date: 'Jan 12, 2025',
        amount: 45.00,
        type: TransactionType.debit,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Balance Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.of(context).primaryColor, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Total Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$1,250.00",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text("Top Up"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                       shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.arrow_upward),
                        SizedBox(width: 8),
                        Text("Withdraw"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // Transactions Header
            const Text(
              "Recent Transactions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Transaction List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                final isCredit = tx.type == TransactionType.credit;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: isCredit ? Colors.green[50] : Colors.red[50],
                    child: Icon(
                      isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isCredit ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ),
                  title: Text(tx.description, style: const TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(tx.date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  trailing: Text(
                    "${isCredit ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: isCredit ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
