    // Start of Selection
    import 'package:bloc/bloc.dart';
    import 'package:equatable/equatable.dart';
    import '../data/repositories/auth_repository.dart';
    import '../data/models/user.dart';

    // Define AuthEvent
    abstract class AuthEvent extends Equatable {
      const AuthEvent();

      @override
      List<Object> get props => [];
    }

    class LoginSubmitted extends AuthEvent {
      final String nssfNumber;
      final String password;

      const LoginSubmitted({
        required this.nssfNumber,
        required this.password,
      });

      @override
      List<Object> get props => [nssfNumber, password];
    }

    class Logout extends AuthEvent {}

    // Define AuthState
    abstract class AuthState extends Equatable {
      const AuthState();

      @override
      List<Object> get props => [];
    }

    class AuthInitial extends AuthState {}

    class AuthLoading extends AuthState {}

    class AuthAuthenticated extends AuthState {
      final User user;

      const AuthAuthenticated(this.user);

      @override
      List<Object> get props => [user];
    }

    class AuthError extends AuthState {
      final String message;

      const AuthError(this.message);

      @override
      List<Object> get props => [message];
    }

    // Define AuthBloc
    class AuthBloc extends Bloc<AuthEvent, AuthState> {
      final AuthRepository authRepository;

      AuthBloc({required this.authRepository}) : super(AuthInitial()) {
        on<LoginSubmitted>(_onLoginSubmitted);
        on<Logout>(_onLogout);
      }

      Future<void> _onLoginSubmitted(
          LoginSubmitted event, Emitter<AuthState> emit) async {
        emit(AuthLoading());
        try {
          final user = await authRepository.authenticate(
              event.nssfNumber, event.password);
          emit(AuthAuthenticated(user));
        } catch (e) {
          emit(const AuthError("Authentication Failed"));
        }
      }

      void _onLogout(Logout event, Emitter<AuthState> emit) {
        authRepository.logout();
        emit(AuthInitial());
      }
    }