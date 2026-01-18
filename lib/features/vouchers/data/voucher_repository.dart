import '../domain/voucher.dart';

class VoucherRepository {
  static final VoucherRepository _instance = VoucherRepository._internal();

  factory VoucherRepository() {
    return _instance;
  }

  VoucherRepository._internal();

  // Mock Data
  final List<Voucher> _vouchers = [
    Voucher(
      id: '1',
      code: 'FIRST100',
      title: '₱100 OFF',
      description: 'Get ₱100 off your first booking',
      discountAmount: 100,
      isPercentage: false,
      claimedByUserIds: [],
    ),
    Voucher(
      id: '2',
      code: 'WELCOME20',
      title: '20% OFF',
      description: '20% discount for new users',
      discountAmount: 20,
      isPercentage: true,
      claimedByUserIds: [],
    ),
    Voucher(
      id: '3',
      code: 'SUNDAYFUN',
      title: '₱50 OFF',
      description: 'Sunday special discount',
      discountAmount: 50,
      isPercentage: false,
      claimedByUserIds: [],
    ),
  ];

  List<Voucher> getVouchers() {
    return List.unmodifiable(_vouchers);
  }

  void claimVoucher(String voucherId, String userId) {
    final index = _vouchers.indexWhere((v) => v.id == voucherId);
    if (index != -1) {
      final voucher = _vouchers[index];
      if (!voucher.claimedByUserIds.contains(userId)) {
        _vouchers[index] = voucher.copyWith(
          claimedByUserIds: [...voucher.claimedByUserIds, userId],
        );
      }
    }
  }

  List<Voucher> getClaimedVouchers(String userId) {
    return _vouchers.where((v) => v.claimedByUserIds.contains(userId)).toList();
  }

  Voucher? findByCode(String code) {
    return _vouchers
        .where((v) => v.code.toUpperCase() == code.toUpperCase())
        .firstOrNull;
  }
}
