 // Start Generation Here
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

/// Define the Withdrawal model
class Withdrawal extends Equatable {
  final String id;
  final double amount;
  final String accountId;
  final DateTime date;

  const Withdrawal({
    required this.id,
    required this.amount,
    required this.accountId,
    required this.date,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      accountId: json['account_id'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'account_id': accountId,
      'date': date.toIso8601String(),
    };
  }

  @override
  List<Object> get props => [id, amount, accountId, date];
}

/// Define the WithdrawalRepository
class WithdrawalRepository {
  // Simulated data store
  final List<Withdrawal> _withdrawals = [];

  /// Fetch all withdrawal data
  Future<List<Withdrawal>> fetchWithdrawalData() async {
    // TODO: Implement actual data fetching logic, e.g., API call
    return _withdrawals;
  }

  /// Add a new withdrawal
  Future<void> addWithdrawal(Withdrawal withdrawal) async {
    // TODO: Implement actual add logic, e.g., API call
    _withdrawals.add(withdrawal);
  }

  /// Remove a withdrawal by ID
  Future<void> removeWithdrawal(String withdrawalId) async {
    // TODO: Implement actual remove logic, e.g., API call
    _withdrawals.removeWhere((w) => w.id == withdrawalId);
  }
}

/// Define WithdrawalEvent
abstract class WithdrawalEvent extends Equatable {
  const WithdrawalEvent();

  @override
  List<Object> get props => [];
}

class LoadWithdrawalData extends WithdrawalEvent {}

class AddWithdrawal extends WithdrawalEvent {
  final Withdrawal withdrawal;

  const AddWithdrawal(this.withdrawal);

  @override
  List<Object> get props => [withdrawal];
}

class RemoveWithdrawal extends WithdrawalEvent {
  final String withdrawalId;

  const RemoveWithdrawal(this.withdrawalId);

  @override
  List<Object> get props => [withdrawalId];
}

class RequestWithdrawal extends WithdrawalEvent {
  final double amount;
  final String recipient;

  const RequestWithdrawal({
    required this.amount,
    required this.recipient,
  });

  @override
  List<Object> get props => [amount, recipient];
}

/// Define WithdrawalState
abstract class WithdrawalState extends Equatable {
  const WithdrawalState();

  @override
  List<Object> get props => [];
}

class WithdrawalInitial extends WithdrawalState {}

class WithdrawalLoading extends WithdrawalState {}

class WithdrawalLoaded extends WithdrawalState {
  final List<Withdrawal> withdrawals;

  const WithdrawalLoaded(this.withdrawals);

  @override
  List<Object> get props => [withdrawals];
}

class WithdrawalError extends WithdrawalState {
  final String message;

  const WithdrawalError(this.message);

  @override
  List<Object> get props => [message];
}

/// Define WithdrawalBloc
class WithdrawalBloc extends Bloc<WithdrawalEvent, WithdrawalState> {
  final WithdrawalRepository withdrawalRepository;

  WithdrawalBloc(this.withdrawalRepository) : super(WithdrawalInitial()) {
    on<LoadWithdrawalData>(_onLoadWithdrawalData);
    on<AddWithdrawal>(_onAddWithdrawal);
    on<RemoveWithdrawal>(_onRemoveWithdrawal);
    on<RequestWithdrawal>(_onRequestWithdrawal);
  }

  Future<void> _onLoadWithdrawalData(
      LoadWithdrawalData event, Emitter<WithdrawalState> emit) async {
    emit(WithdrawalLoading());
    try {
      final withdrawals = await withdrawalRepository.fetchWithdrawalData();
      emit(WithdrawalLoaded(withdrawals));
    } catch (e) {
      emit(const WithdrawalError("Failed to load withdrawal data"));
    }
  }

  Future<void> _onAddWithdrawal(
      AddWithdrawal event, Emitter<WithdrawalState> emit) async {
    if (state is WithdrawalLoaded) {
      try {
        await withdrawalRepository.addWithdrawal(event.withdrawal);
        final withdrawals = await withdrawalRepository.fetchWithdrawalData();
        emit(WithdrawalLoaded(withdrawals));
      } catch (e) {
        emit(const WithdrawalError("Failed to add withdrawal"));
      }
    }
  }

  Future<void> _onRemoveWithdrawal(
      RemoveWithdrawal event, Emitter<WithdrawalState> emit) async {
    if (state is WithdrawalLoaded) {
      try {
        await withdrawalRepository.removeWithdrawal(event.withdrawalId);
        final withdrawals = await withdrawalRepository.fetchWithdrawalData();
        emit(WithdrawalLoaded(withdrawals));
      } catch (e) {
        emit(const WithdrawalError("Failed to remove withdrawal"));
      }
    }
  }

  Future<void> _onRequestWithdrawal(
      RequestWithdrawal event, Emitter<WithdrawalState> emit) async {
    emit(WithdrawalLoading());
    try {
      // Create a Withdrawal object
      final withdrawal = Withdrawal(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // Example ID
        amount: event.amount,
        accountId: event.recipient,
        date: DateTime.now(),
      );

      // Add the withdrawal using the repository
      await withdrawalRepository.addWithdrawal(withdrawal);

      // Fetch the updated list of withdrawals
      final withdrawals = await withdrawalRepository.fetchWithdrawalData();
      emit(WithdrawalLoaded(withdrawals));
    } catch (e) {
      emit(const WithdrawalError("Failed to process withdrawal"));
    }
  }
}
