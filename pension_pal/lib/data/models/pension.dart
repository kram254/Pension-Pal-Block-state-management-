class Pension {
  final String id;
  final String schemeName;
  final double contributions;
  final double balance;
  final String pensionType;

  Pension({
    required this.id,
    required this.schemeName,
    required this.contributions,
    required this.balance,
    required this.pensionType,
  });

  factory Pension.fromJson(Map<String, dynamic> json) {
    return Pension(
      id: json['id'],
      schemeName: json['scheme_name'],
      contributions: json['contributions'].toDouble(),
      balance: json['balance'].toDouble(),
      pensionType: json['pension_type'],
    );
  }
}