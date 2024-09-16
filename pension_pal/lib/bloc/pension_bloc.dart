import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/pension_repository.dart';
import '../data/models/pension.dart';

abstract class PensionEvent extends Equatable {
  const PensionEvent();

  @override
  List<Object> get props => [];
}

class LoadPensionData extends PensionEvent {}

class AddPensionData extends PensionEvent {
  final Pension pension;

  const AddPensionData(this.pension);

  @override
  List<Object> get props => [pension];
}

abstract class PensionState extends Equatable {
  const PensionState();

  @override
  List<Object> get props => [];
}

class PensionInitial extends PensionState {}

class PensionLoading extends PensionState {}

class PensionLoaded extends PensionState {
  final List<Pension> pensions;

  const PensionLoaded(this.pensions);

  @override
  List<Object> get props => [pensions];
}

class PensionError extends PensionState {
  final String message;

  const PensionError(this.message);

  @override
  List<Object> get props => [message];
}

class PensionBloc extends Bloc<PensionEvent, PensionState> {
  final PensionRepository pensionRepository;

  PensionBloc(this.pensionRepository) : super(PensionInitial()) {
    on<LoadPensionData>(_onLoadPensionData);
    on<AddPensionData>(_onAddPensionData);
  }

  Future<void> _onLoadPensionData(
      LoadPensionData event, Emitter<PensionState> emit) async {
    emit(PensionLoading());
    try {
      final pensions = await pensionRepository.fetchPensionData();
      emit(PensionLoaded(pensions));
    } catch (e) {
      emit(const PensionError("Failed to load pension data"));
    }
  }

  Future<void> _onAddPensionData(
      AddPensionData event, Emitter<PensionState> emit) async {
    if (state is PensionLoaded) {
      try {
        await pensionRepository.addPensionData(event.pension);
        final updatedPensions = List<Pension>.from((state as PensionLoaded).pensions)
          ..add(event.pension);
        emit(PensionLoaded(updatedPensions));
      } catch (e) {
        emit(const PensionError("Failed to add pension data"));
      }
    }
  }
}

