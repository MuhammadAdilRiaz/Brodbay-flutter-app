class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final DateTime? startAt;
  final DateTime? endAt;
  final bool isActive;
  final String? clickUrl;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.startAt,
    this.endAt,
    this.isActive = true,
    this.clickUrl,
  });

  BannerModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? imageUrl,
    DateTime? startAt,
    DateTime? endAt,
    bool? isActive,
    String? clickUrl,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      imageUrl: imageUrl ?? this.imageUrl,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      isActive: isActive ?? this.isActive,
      clickUrl: clickUrl ?? this.clickUrl,
    );
  }

  /// Temu-style time validation
  bool get isTimeValid {
    final now = DateTime.now().toUtc();
    if (!isActive) return false;
    if (startAt != null && now.isBefore(startAt!.toUtc())) return false;
    if (endAt != null && now.isAfter(endAt!.toUtc())) return false;
    return true;
  }
}
