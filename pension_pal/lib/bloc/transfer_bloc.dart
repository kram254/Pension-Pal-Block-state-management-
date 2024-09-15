import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repositories/transfer_repository.dart';
import '../../data/models/transfer.dart';

/// Define TransferEvent
abstract class TransferEvent extends Equatable {
  const TransferEvent();

  @override
  List<Object> get props => [];
}

class LoadTransferData extends TransferEvent {}

class AddTransfer extends TransferEvent {
  final Transfer transfer;

  const AddTransfer(this.transfer);

  @override
  List<Object> get props => [transfer];
}

class RemoveTransfer extends TransferEvent {
  final String transferId;

  const RemoveTransfer(this.transferId);

  @override
  List<Object> get props => [transferId];
}

class TransferRequested extends TransferEvent {
  final double amount;
  final String recipient;

  const TransferRequested({
    required this.amount,
    required this.recipient,
  });

  @override
  List<Object> get props => [amount, recipient];
}

/// Define TransferState
abstract class TransferState extends Equatable {
  const TransferState();

  @override
  List<Object> get props => [];
}

class TransferInitial extends TransferState {}

class TransferLoading extends TransferState {}

class TransferInProgress extends TransferState {}

class TransferLoaded extends TransferState {
  final List<Transfer> transfers;

  const TransferLoaded(this.transfers);

  @override
  List<Object> get props => [transfers];
}

class TransferSuccess extends TransferState {
  final Transfer transfer;

  const TransferSuccess(this.transfer);

  @override
  List<Object> get props => [transfer];
}

class TransferError extends TransferState {
  final String errorMessage;

  const TransferError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

/// Define TransferBloc
class TransferBloc extends Bloc<TransferEvent, TransferState> {
  final TransferRepository transferRepository;

  TransferBloc(this.transferRepository) : super(TransferInitial()) {
    on<LoadTransferData>(_onLoadTransferData);
    on<AddTransfer>(_onAddTransfer);
    on<RemoveTransfer>(_onRemoveTransfer);
    on<TransferRequested>(_onTransferRequested);
  }

  Future<void> _onLoadTransferData(
      LoadTransferData event, Emitter<TransferState> emit) async {
    emit(TransferLoading());
    try {
      final transfers = await transferRepository.fetchTransferData();
      emit(TransferLoaded(transfers));
    } catch (e) {
      emit(const TransferError("Failed to load transfer data"));
    }
  }

  Future<void> _onAddTransfer(
      AddTransfer event, Emitter<TransferState> emit) async {
    if (state is TransferLoaded) {
      try {
        await transferRepository.addTransfer(event.transfer);
        final transfers = await transferRepository.fetchTransferData();
        emit(TransferLoaded(transfers));
      } catch (e) {
        emit(const TransferError("Failed to add transfer"));
      }
    }
  }

  Future<void> _onRemoveTransfer(
      RemoveTransfer event, Emitter<TransferState> emit) async {
    if (state is TransferLoaded) {
      try {
        await transferRepository.removeTransfer(event.transferId);
        final transfers = await transferRepository.fetchTransferData();
        emit(TransferLoaded(transfers));
      } catch (e) {
        emit(const TransferError("Failed to remove transfer"));
      }
    }
  }

  Future<void> _onTransferRequested(
      TransferRequested event, Emitter<TransferState> emit) async {
    emit(TransferInProgress());
    try {
      bool success = await transferRepository.transferFunds(event.amount, event.recipient);
      if (success) {
        Transfer transfer = Transfer(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          amount: event.amount,
          fromAccount: "YourAccount", // Replace with actual account
          toAccount: event.recipient,
          date: DateTime.now(),
        );
        emit(TransferSuccess(transfer));
        add(LoadTransferData());
      } else {
        emit(TransferError("Transfer failed due to server error"));
      }
    } catch (e) {
      emit(TransferError("Failed to process transfer"));
    }
  }
}
