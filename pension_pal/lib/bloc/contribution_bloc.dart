    // Start of Selection
    import 'package:bloc/bloc.dart';
    import 'package:equatable/equatable.dart';
    
    // Define Contribution model
    class Contribution extends Equatable {
      final String id;
      final double amount;
      final String schemeId;
    
      Contribution({
        required this.id,
        required this.amount,
        required this.schemeId,
      });
    
      factory Contribution.fromJson(Map<String, dynamic> json) {
        return Contribution(
          id: json['id'],
          amount: (json['amount'] as num).toDouble(),
          schemeId: json['scheme_id'],
        );
      }
    
      @override
      List<Object> get props => [id, amount, schemeId];
    }
    
    // Define ContributionRepository
    class ContributionRepository {
      // Placeholder for fetching contributions
      Future<List<Contribution>> fetchContributions() async {
        // TODO: Implement actual data fetching logic
        return [];
      }
    
      // Placeholder for submitting a contribution
      Future<void> submitContribution(double amount, String schemeId) async {
        // TODO: Implement actual submission logic
      }
    }
    
    // Defining my ContributionEvent
    abstract class ContributionEvent extends Equatable {
      const ContributionEvent();
    
      @override
      List<Object> get props => [];
    }
    
    class LoadContributionData extends ContributionEvent {}
    
    class SubmitContribution extends ContributionEvent {
      final double amount;
      final String schemeId;
    
      const SubmitContribution({
        required this.amount,
        required this.schemeId,
      });
    
      @override
      List<Object> get props => [amount, schemeId];
    }
    
    // Define ContributionState
    abstract class ContributionState extends Equatable {
      const ContributionState();
    
      @override
      List<Object> get props => [];
    }
    
    class ContributionLoading extends ContributionState {}
    
    class ContributionLoaded extends ContributionState {
      final List<Contribution> contributions;
    
      const ContributionLoaded(this.contributions);
    
      @override
      List<Object> get props => [contributions];
    }
    
    class ContributionSubmitting extends ContributionState {}
    
    class ContributionError extends ContributionState {
      final String message;
    
      const ContributionError(this.message);
    
      @override
      List<Object> get props => [message];
    }
    
    // Define ContributionBloc
    class ContributionBloc extends Bloc<ContributionEvent, ContributionState> {
      final ContributionRepository contributionRepository;
    
      ContributionBloc(this.contributionRepository) : super(ContributionLoading()) {
        on<LoadContributionData>(_onLoadContributionData);
        on<SubmitContribution>(_onSubmitContribution);
      }
    
      Future<void> _onLoadContributionData(
          LoadContributionData event, Emitter<ContributionState> emit) async {
        emit(ContributionLoading());
        try {
          final contributions = await contributionRepository.fetchContributions();
          emit(ContributionLoaded(contributions));
        } catch (e) {
          emit(const ContributionError("Failed to load contribution data"));
        }
      }
    
      Future<void> _onSubmitContribution(
          SubmitContribution event, Emitter<ContributionState> emit) async {
        emit(ContributionSubmitting());
        try {
          await contributionRepository.submitContribution(event.amount, event.schemeId);
          final contributions = await contributionRepository.fetchContributions();
          emit(ContributionLoaded(contributions));
        } catch (e) {
          emit(const ContributionError("Failed to submit contribution"));
        }
      }
    }