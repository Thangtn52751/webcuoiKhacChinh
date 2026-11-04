class GuestbookEntry {
  const GuestbookEntry({
    required this.name,
    required this.message,
    this.createdAt,
  });

  final String name;
  final String message;
  final DateTime? createdAt;

  factory GuestbookEntry.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt = json['createdAt']?.toString();
    return GuestbookEntry(
      name: json['name']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      createdAt: rawCreatedAt == null ? null : DateTime.tryParse(rawCreatedAt),
    );
  }
}
