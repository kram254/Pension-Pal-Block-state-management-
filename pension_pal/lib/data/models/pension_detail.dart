class PensionDetail {
  final String id;
  final String schemeName;
  final double totalContributions;
  final double currentBalance;
  final DateTime lastContributionDate;
  final double withdrawalLimit;

  PensionDetail({
    required this.id,
    required this.schemeName,
    required this.totalContributions,
    required this.currentBalance,
    required this.lastContributionDate,
    required this.withdrawalLimit,
  });

  factory PensionDetail.fromJson(Map<String, dynamic> json) {
    return PensionDetail(
      id: json['id'],
      schemeName: json['scheme_name'],
      totalContributions: (json['total_contributions'] as num).toDouble(),
      currentBalance: (json['current_balance'] as num).toDouble(),
      lastContributionDate: DateTime.parse(json['last_contribution_date']),
      withdrawalLimit: (json['withdrawal_limit'] as num).toDouble(),
    );
  }
}