import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo_app/core/routes.dart';
import 'package:todo_app/presentation/views/input_field.dart';
import 'package:todo_app/presentation/views/registration_login_text.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:todo_app/core/routes.dart' as routes;


class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _emailVerificationController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();


  Widget blocBuilder(context, state) {
      
    if(state.stateType == BlocStateType.loading)
    {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
      );

    } else if( state is RegistrationState && state.stateType == BlocStateType.error){
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            color: Colors.red, // Farbe des Fehler-Icons
            size: 60.0, // Größe des Fehler-Icons
          ),
          SizedBox(height: 10.0), // Ein kleiner Abstand zwischen Icon und Text
          Text(
            'Fehler beim Registrieren',
            style: TextStyle(
              color: Colors.red, // Farbe des Fehlertexts
              fontSize: 18.0, // Größe des Fehlertexts
            ),
          ),]);
    
    } else {

      return Container();
    }
    
  }

  bool buildWhen(previousState, state) {
    return state is RegistrationState;
  }

  void blocListener(context, state) {
                  
    if(state is RegistrationState && state.stateType == BlocStateType.success){
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message:
              "Erfolgreich eingeloggt",
        ),
      );

      Navigator.popAndPushNamed(context, routes.homeRoute);

    } else if (state is RegistrationState && state.stateType == BlocStateType.error) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message:
              "Fehler beim Registrieren",
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
                child: const Text("Welcome!", style: TextStyle(
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
                
                      //Username
                      InputField(
                        textEditingController: _emailController, 
                        labelText: "Email",
                        iconData: Icons.person,
                      ),

                      InputField(
                        textEditingController: _emailVerificationController, 
                        labelText: "Confirm Email",
                        iconData: Icons.person,
                      ),
                
                      //Passwort:
                      InputField(
                        textEditingController: _passwortController, 
                        labelText: "Password",
                        hidden: true,
                        iconData: Icons.lock,
                      ),
                      
                      const SizedBox(height: 30,),
                          
                      //Registration button
                      ElevatedButton(
                        onPressed: () async {
                
                          BlocProvider.of<AuthenticationBloc>(context).add(
                             RegistrationEvent(_emailController.text, _emailVerificationController.text, _passwortController.text));
                        }, 
                        child: const Text('Register')
                      ),
                          
                      const SizedBox(height: 20,),
                          
                      RegistrationOrLoginText(onTap: () {
                        Navigator.popAndPushNamed(context, loginRoute);
                      },
                      text1: "Already have an account? ",
                      text2: "Login here",)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),)
    );
  }


}
