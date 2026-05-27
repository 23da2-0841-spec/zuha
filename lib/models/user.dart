class ZUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarInitials;

  const ZUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarInitials,
  });

  factory ZUser.fromFirestore(Map<String, dynamic> map, String id) {
    final name = map['name'] as String? ?? '';
    final email = map['email'] as String? ?? '';
    final parts = name.split(' ');
    final initials = parts.isNotEmpty
        ? parts.map((p) => p.isNotEmpty ? p[0] : '').take(2).join()
        : email.isNotEmpty
            ? email[0].toUpperCase()
            : '?';

    return ZUser(
      id: id,
      name: name,
      email: email,
      phone: map['phone'] as String? ?? '',
      avatarInitials: initials,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'avatarInitials': avatarInitials,
    };
  }
}
