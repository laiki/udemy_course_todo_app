import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/data/exceptions/base_authentication_exception.dart';
import 'package:todo_app/data/exceptions/network_missing_exception.dart';
import 'package:todo_app/data/exceptions/wrong_credentials_exception.dart';
import 'package:todo_app/domain/interfaces/authentication_interface.dart';

class FirebaseAuthService implements AuthenticationInterface {

  @override
  Future<bool> logIn(String email, String password) async {

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, 
      password: password);

      if(FirebaseAuth.instance.currentUser != null){
        return true;
      }

      return false;

    } catch (e) {

      if(e is FirebaseAuthException){
        
        if(e.code == 'network-request-failed'){
          throw NetworkMissingException();

        } else if(e.code == 'invalid-credential'){
          
          throw WrongCredentialsException();

        } else {
          
          throw BaseAuthenticationException();
        }
      }

      return false;
    }
    
    
  }

  @override
  Future<bool> register(String email, String emailVerification, String password) async {

    if(email != emailVerification){
      return false;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email, 
                  password: password);
      
      if(FirebaseAuth.instance.currentUser != null){
        return true;
      }

      return false; 
    } catch (e) {
      return false;
    }
    
                
  }
  
  @override
  bool? isEmailVerified() {

    if(FirebaseAuth.instance.currentUser == null){
      return null;
    
    } else {
      return FirebaseAuth.instance.currentUser!.emailVerified;

    }
  }
  
  @override
  Future sendVerificationEmail() async {
    if(FirebaseAuth.instance.currentUser == null){
      return;
    
    } else {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification();

    }
  }
  
  @override
  Future logout() async {
    await FirebaseAuth.instance.signOut();
  }
  
  @override
  String getUserEmail() {
    return FirebaseAuth.instance.currentUser!.email!;
  }



}