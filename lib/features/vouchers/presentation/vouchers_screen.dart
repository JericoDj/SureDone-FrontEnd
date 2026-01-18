import 'package:flutter/material.dart';

import '../data/voucher_repository.dart';
import '../domain/voucher.dart';

class VouchersScreen extends StatefulWidget {
  final String userId;

  const VouchersScreen({super.key, required this.userId});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> {
  late List<Voucher> _vouchers;

  @override
  void initState() {
    super.initState();
    _refreshVouchers();
  }

  void _refreshVouchers() {
    setState(() {
      _vouchers = VoucherRepository().getVouchers();
    });
  }

  void _claimVoucher(String id) {
    VoucherRepository().claimVoucher(id, widget.userId);
    _refreshVouchers();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Voucher Claimed!")));
  }

  void _applyVoucher(Voucher voucher) {
    Navigator.of(context).pop(voucher);
  }

  @override
  Widget build(BuildContext context) {
    final claimed = _vouchers
        .where((v) => v.isClaimedBy(widget.userId))
        .toList();
    final unclaimed = _vouchers
        .where((v) => !v.isClaimedBy(widget.userId))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Vouchers")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (claimed.isNotEmpty) ...[
              const Text(
                "My Vouchers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              ...claimed.map((v) => _buildVoucherCard(v, isClaimed: true)),
              const SizedBox(height: 20),
            ],

            if (unclaimed.isNotEmpty) ...[
              const Text(
                "Available Vouchers",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              ...unclaimed.map((v) => _buildVoucherCard(v, isClaimed: false)),
            ],

            if (claimed.isEmpty && unclaimed.isEmpty)
              const Center(child: Text("No vouchers available")),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherCard(Voucher voucher, {required bool isClaimed}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.confirmation_number_outlined,
                color: Colors.teal,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    voucher.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    voucher.description,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            if (isClaimed)
              ElevatedButton(
                onPressed: () => _applyVoucher(voucher),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Apply"),
              )
            else
              OutlinedButton(
                onPressed: () => _claimVoucher(voucher.id),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(80, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Get"),
              ),
          ],
        ),
      ),
    );
  }
}
