import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Define Planner model
class Planner extends Equatable {
  final String id;
  final String name;

  Planner({required this.id, required this.name});

  @override
  List<Object> get props => [id, name];
}

// Define PlannerRepository
class PlannerRepository {
  // Placeholder for fetching planner data
  Future<List<Planner>> fetchPlannerData() async {
    // TODO: Implement actual data fetching logic
    return [];
  }

  // Placeholder for adding a planner item
  Future<void> addPlannerItem(Planner planner) async {
    // TODO: Implement actual add logic
  }

  // Placeholder for removing a planner item
  Future<void> removePlannerItem(String plannerId) async {
    // TODO: Implement actual remove logic
  }
}

// Define PlannerEvent
abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object> get props => [];
}

class LoadPlannerData extends PlannerEvent {}

class AddPlannerItem extends PlannerEvent {
  final Planner planner;

  const AddPlannerItem(this.planner);

  @override
  List<Object> get props => [planner];
}

class RemovePlannerItem extends PlannerEvent {
  final String plannerId;

  const RemovePlannerItem(this.plannerId);

  @override
  List<Object> get props => [plannerId];
}

// Define PlannerState
abstract class PlannerState extends Equatable {
  const PlannerState();

  @override
  List<Object> get props => [];
}

class PlannerInitial extends PlannerState {}

class PlannerLoading extends PlannerState {}

class PlannerLoaded extends PlannerState {
  final List<Planner> planners;

  const PlannerLoaded(this.planners);

  @override
  List<Object> get props => [planners];
}

class PlannerError extends PlannerState {
  final String message;

  const PlannerError(this.message);

  @override
  List<Object> get props => [message];
}

// Define PlannerBloc
class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  final PlannerRepository plannerRepository;

  PlannerBloc(this.plannerRepository) : super(PlannerInitial()) {
    on<LoadPlannerData>(_onLoadPlannerData);
    on<AddPlannerItem>(_onAddPlannerItem);
    on<RemovePlannerItem>(_onRemovePlannerItem);
  }

  Future<void> _onLoadPlannerData(
      LoadPlannerData event, Emitter<PlannerState> emit) async {
    emit(PlannerLoading());
    try {
      final planners = await plannerRepository.fetchPlannerData();
      emit(PlannerLoaded(planners));
    } catch (e) {
      emit(const PlannerError("Failed to load planner data"));
    }
  }

  Future<void> _onAddPlannerItem(
      AddPlannerItem event, Emitter<PlannerState> emit) async {
    if (state is PlannerLoaded) {
      try {
        await plannerRepository.addPlannerItem(event.planner);
        final planners = await plannerRepository.fetchPlannerData();
        emit(PlannerLoaded(planners));
      } catch (e) {
        emit(const PlannerError("Failed to add planner item"));
      }
    }
  }

  Future<void> _onRemovePlannerItem(
      RemovePlannerItem event, Emitter<PlannerState> emit) async {
    if (state is PlannerLoaded) {
      try {
        await plannerRepository.removePlannerItem(event.plannerId);
        final planners = await plannerRepository.fetchPlannerData();
        emit(PlannerLoaded(planners));
      } catch (e) {
        emit(const PlannerError("Failed to remove planner item"));
      }
    }
  }
}

