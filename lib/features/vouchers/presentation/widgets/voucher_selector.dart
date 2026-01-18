import 'package:flutter/material.dart';
import '../../domain/voucher.dart';
import '../vouchers_screen.dart';

class VoucherSelector extends StatelessWidget {
  final Voucher? selectedVoucher;
  final ValueChanged<Voucher?> onVoucherChanged;
  final String userId;

  const VoucherSelector({
    super.key,
    this.selectedVoucher,
    required this.onVoucherChanged,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final voucher = await Navigator.push<Voucher>(
          context,
          MaterialPageRoute(builder: (_) => VouchersScreen(userId: userId)),
        );
        if (voucher != null) {
          onVoucherChanged(voucher);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            const Icon(Icons.discount, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedVoucher != null
                    ? "${selectedVoucher!.title} Applied"
                    : "Select Voucher",
                style: TextStyle(
                  fontSize: 16,
                  color: selectedVoucher != null ? Colors.teal : Colors.black87,
                  fontWeight: selectedVoucher != null
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ),
            if (selectedVoucher != null)
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => onVoucherChanged(null),
              )
            else
              const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
