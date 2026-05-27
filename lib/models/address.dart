class ZAddress {
  final String id;
  final String label;
  final String fullName;
  final String line1;
  final String city;
  final String postalCode;
  final String phone;
  final bool isDefault;

  const ZAddress({
    required this.id,
    required this.label,
    required this.fullName,
    required this.line1,
    required this.city,
    required this.postalCode,
    required this.phone,
    this.isDefault = false,
  });

  factory ZAddress.fromFirestore(Map<String, dynamic> map, String id) {
    return ZAddress(
      id: id,
      label: map['label'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      line1: map['line1'] as String? ?? '',
      city: map['city'] as String? ?? '',
      postalCode: map['postalCode'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      isDefault: map['isDefault'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'fullName': fullName,
      'line1': line1,
      'city': city,
      'postalCode': postalCode,
      'phone': phone,
      'isDefault': isDefault,
    };
  }
}
