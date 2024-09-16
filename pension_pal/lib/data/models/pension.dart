class Pension {
  final String id;
  final String schemeName;
  final double contributions;
  final double balance;

  Pension({
    required this.id,
    required this.schemeName,
    required this.contributions,
    required this.balance, required String pensionType,
  });

  factory Pension.fromJson(Map<String, dynamic> json) {
    return Pension(
      id: json['id'],
      schemeName: json['scheme_name'],
      contributions: json['contributions'].toDouble(),
      balance: json['balance'].toDouble(), pensionType: '',
    );
  }
}