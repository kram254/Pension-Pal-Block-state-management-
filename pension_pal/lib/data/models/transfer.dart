    // Start Generation Here
    import 'package:equatable/equatable.dart';

    class Transfer extends Equatable {
      final String id;
      final double amount;
      final String fromAccount;
      final String toAccount;
      final DateTime date;

      const Transfer({
        required this.id,
        required this.amount,
        required this.fromAccount,
        required this.toAccount,
        required this.date,
      });

      factory Transfer.fromJson(Map<String, dynamic> json) {
        return Transfer(
          id: json['id'] as String,
          amount: (json['amount'] as num).toDouble(),
          fromAccount: json['from_account'] as String,
          toAccount: json['to_account'] as String,
          date: DateTime.parse(json['date'] as String),
        );
      }

      Map<String, dynamic> toJson() {
        return {
          'id': id,
          'amount': amount,
          'from_account': fromAccount,
          'to_account': toAccount,
          'date': date.toIso8601String(),
        };
      }

      @override
      List<Object> get props => [id, amount, fromAccount, toAccount, date];
    }
