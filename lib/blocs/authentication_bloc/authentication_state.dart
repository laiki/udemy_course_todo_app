part of 'authentication_bloc.dart';


sealed class AuthenticationState {
  final BlocStateType stateType;

  AuthenticationState(this.stateType);
}

final class AuthenticationInitial extends AuthenticationState {
  
  AuthenticationInitial() : super(BlocStateType.success);

}


final class LoginState extends AuthenticationState{

  final bool? verified;
  final BaseAuthenticationException? exception;

  LoginState(super.stateType, {this.verified, this.exception});

}

final class RegistrationState extends AuthenticationState{

  final bool? verified;

  RegistrationState(super.stateType, {this.verified});

}

final class VerificationEmailSent extends AuthenticationState{
  
  VerificationEmailSent(super.stateType);

}

final class LogoutState extends AuthenticationState{
  
  LogoutState(super.stateType);

}