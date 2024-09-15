 // Start of Selection
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/models/pension_detail.dart';

// Define PensionDetailRepository
class PensionDetailRepository {
  // Implement the fetchPensionDetail method
  Future<PensionDetail> fetchPensionDetail(String pensionId) async {
    // TODO: Implement the actual API call to fetch pension details
    // For example, using Dio or another HTTP client
    // return PensionDetail.fromJson(response.data);
    
    // Placeholder implementation
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return PensionDetail(
      id: pensionId,
      schemeName: 'Sample Scheme',
      totalContributions: 100000.0,
      currentBalance: 150000.0,
      lastContributionDate: DateTime.now().subtract(Duration(days: 30)),
      withdrawalLimit: 50000.0,
    );
  }
}

abstract class PensionDetailEvent extends Equatable {
  const PensionDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadPensionDetail extends PensionDetailEvent {
  final String pensionId;

  const LoadPensionDetail(this.pensionId);

  @override
  List<Object> get props => [pensionId];
}

abstract class PensionDetailState extends Equatable {
  const PensionDetailState();

  @override
  List<Object> get props => [];
}

class PensionDetailLoading extends PensionDetailState {}

class PensionDetailLoaded extends PensionDetailState {
  final PensionDetail pensionDetail;

  const PensionDetailLoaded(this.pensionDetail);

  @override
  List<Object> get props => [pensionDetail];
}

class PensionDetailError extends PensionDetailState {
  final String message;

  const PensionDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class PensionDetailBloc extends Bloc<PensionDetailEvent, PensionDetailState> {
  final PensionDetailRepository pensionDetailRepository;

  PensionDetailBloc(this.pensionDetailRepository) : super(PensionDetailLoading()) {
    on<LoadPensionDetail>(_onLoadPensionDetail);
  }

  Future<void> _onLoadPensionDetail(
      LoadPensionDetail event, Emitter<PensionDetailState> emit) async {
    emit(PensionDetailLoading());
    try {
      final pensionDetail = await pensionDetailRepository.fetchPensionDetail(event.pensionId);
      emit(PensionDetailLoaded(pensionDetail));
    } catch (e) {
      emit(PensionDetailError("Failed to load pension details"));
    }
  }
}

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