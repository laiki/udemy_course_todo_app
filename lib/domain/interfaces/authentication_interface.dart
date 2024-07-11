abstract class AuthenticationInterface {

  Future<bool> logIn(String email, String password);

  Future<bool> register(String email, String emailVerification, String password);

  bool? isEmailVerified();

  Future sendVerificationEmail();

  Future logout();

  String getUserEmail();
}