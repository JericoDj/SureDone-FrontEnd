class Voucher {
  final String id;
  final String code;
  final String title;
  final String description;
  final double discountAmount;
  final bool isPercentage;
  final List<String> claimedByUserIds;

  Voucher({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountAmount,
    this.isPercentage = false,
    this.claimedByUserIds = const [],
  });

  bool isClaimedBy(String userId) {
    return claimedByUserIds.contains(userId);
  }

  Voucher copyWith({
    String? id,
    String? code,
    String? title,
    String? description,
    double? discountAmount,
    bool? isPercentage,
    List<String>? claimedByUserIds,
  }) {
    return Voucher(
      id: id ?? this.id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      discountAmount: discountAmount ?? this.discountAmount,
      isPercentage: isPercentage ?? this.isPercentage,
      claimedByUserIds: claimedByUserIds ?? this.claimedByUserIds,
    );
  }
}
