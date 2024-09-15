class User {
  final String id;
  final String name;
  final String nssfNumber;

  User({
    required this.id,
    required this.name,
    required this.nssfNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      nssfNumber: json['nssf_number'],
    );
  }
}