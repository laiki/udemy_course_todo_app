import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo_app/core/routes.dart';
import 'package:todo_app/core/validators/email_validator.dart';
import 'package:todo_app/core/validators/password_validator.dart';
import 'package:todo_app/data/exceptions/network_missing_exception.dart';
import 'package:todo_app/data/exceptions/wrong_credentials_exception.dart';
import 'package:todo_app/presentation/views/input_field.dart';
import 'package:todo_app/presentation/views/registration_login_text.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:todo_app/core/routes.dart' as routes;


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget blocBuilder(context, state) {
      
    if(state.stateType == BlocStateType.loading)
    {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
      );

    } else if( state is LoginState && state.stateType == BlocStateType.error){
      
      String errorText = translate('login_screen_error_base');

      if(state.exception != null){
        if(state.exception! is NetworkMissingException){
          errorText = translate('login_screen_error_network_error');
        
        } else if(state.exception! is WrongCredentialsException){
          errorText = translate('login_screen_error_invalid_credentials');
        }
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.error,
            color: Colors.red, // Farbe des Fehler-Icons
            size: 60.0, // Größe des Fehler-Icons
          ),
          const SizedBox(height: 10.0), // Ein kleiner Abstand zwischen Icon und Text
          Text(
            errorText,
            style: const TextStyle(
              color: Colors.red, // Farbe des Fehlertexts
              fontSize: 18.0, // Größe des Fehlertexts
            ),
          ),]);
    
    } else {

      return Container();
    }
    
  }

  bool buildWhen(previousState, state) {
    return state is LoginState;
  }

  void blocListener(context, state) {              
    if(state is LoginState && state.stateType == BlocStateType.success){
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message:
              "Erfolgreich eingeloggt",
        ),
      );
      
      if(state.verified!){
        Navigator.popAndPushNamed(context, routes.homeRoute);
      
      } else {
        Navigator.pushNamed(context, routes.verificationRoute);
      }

      

    } else if (state is LoginState && state.stateType == BlocStateType.error) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message:
              "Fehler beim Einloggen",
      ));

    }
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
            Colors.deepPurple[400]!,
            Colors.deepPurple[200]!,
            Colors.deepPurple[100]!,
          ])
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1, 
              child: Container(
                alignment: Alignment.center,
                child: Text("${translate("loginscreen_welcome_text")}!", 
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),)
              ),
              ),
            Expanded(
              flex: 3,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    topRight: Radius.circular(60),
                  )
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        
                        const SizedBox(height: 50,),
                  
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: 
                          BlocConsumer<AuthenticationBloc, AuthenticationState>(
                            listener: blocListener,
                            buildWhen: buildWhen,
                            builder: blocBuilder,
                          ),
                        ),
                                  
                        //Email
                        InputField(
                          textEditingController: _usernameController, 
                          labelText: translate('loginscreen_email_label'),
                          iconData: Icons.person,
                          validator: emailValidator,
                        ),
                                  
                        //Passwort:
                        InputField(
                          textEditingController: _passwortController, 
                          labelText: translate('loginscreen_password_label'),
                          hidden: true,
                          iconData: Icons.lock,
                          validator: passwordValidator,
                        ),
                        
                        const SizedBox(height: 30,),
                            
                        //Login button
                        ElevatedButton(
                          onPressed: () async {
                                  
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<AuthenticationBloc>(context).add(
                                LoginEvent(_usernameController.text, _passwortController.text));
                            }
                                  
                          }, 
                          child: Text(translate('loginscreen_loginbtn_text'))
                        ),
                            
                        const SizedBox(height: 20,),
                            
                        RegistrationOrLoginText(
                          onTap: () {
                            Navigator.popAndPushNamed(context, registrationRoute);
                          },
                          text1: translate("loginscreen_registration_text1"),
                          text2: translate("login_screen_registration_text2"), )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),)
    );
  }


}
