part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}


class LoginEvent extends AuthenticationEvent {
  
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

}

class RegistrationEvent extends AuthenticationEvent {
  
  final String email;
  final String verificationEmail;
  final String password;

  RegistrationEvent(this.email, this.verificationEmail, this.password);

}

class VerifyUserEvent extends AuthenticationEvent {
  
}

class LogoutEvent extends AuthenticationEvent {
  
}
