import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/data/exceptions/base_authentication_exception.dart';
import 'package:todo_app/domain/interfaces/authentication_interface.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  
  final getIt = GetIt.instance;
  
  AuthenticationBloc() : super(AuthenticationInitial()) {

    on<LoginEvent>((event, emit) async {
      
      emit(LoginState(BlocStateType.loading));
      
      bool loggedIn = false;

      try {
        loggedIn = await getIt<AuthenticationInterface>().logIn(event.email, event.password);
      
      } on Exception catch (e) {
        if(e is BaseAuthenticationException){
          emit(LoginState(BlocStateType.error, exception: e));
          return;
        }
      }
      
      if(loggedIn){
        
        bool? isVerified = getIt<AuthenticationInterface>().isEmailVerified();

        emit(LoginState(BlocStateType.success, verified: isVerified));

      } else {

        emit(LoginState(BlocStateType.error));
      }

    });

    on<RegistrationEvent>((event, emit) async {
      emit(RegistrationState(BlocStateType.loading));

      bool loggedIn = await getIt<AuthenticationInterface>().register(event.email, event.verificationEmail, event.password);

      if(loggedIn){

        bool? isVerified = getIt<AuthenticationInterface>().isEmailVerified();

        emit(RegistrationState(BlocStateType.success, verified: isVerified));

      } else {

        emit(RegistrationState(BlocStateType.error));
      }
    });

    on<VerifyUserEvent>((event, emit) async {

      emit(VerificationEmailSent(BlocStateType.loading));

      try{
        await getIt<AuthenticationInterface>().sendVerificationEmail();

        emit(VerificationEmailSent(BlocStateType.success));

      } catch (ex){
        
        emit(VerificationEmailSent(BlocStateType.error));

      }
      
    });

    on<LogoutEvent>((event, emit) async {

      emit(LogoutState(BlocStateType.loading));

      try{
        await getIt<AuthenticationInterface>().logout();

        emit(LogoutState(BlocStateType.success));

      } catch (ex){
        
        emit(LogoutState(BlocStateType.error));

      }
      
    });



  }
}
