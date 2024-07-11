import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';


class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  

  Widget blocBuilder(context, state) {
    
    if(state.stateType == BlocStateType.loading)
    {
      return const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
      );

    } else {
      return Container();
    }
  }

  bool buildWhen(previousState, state) {
    return true;
  }

  void blocListener(context, state) {
    if(state is VerificationEmailSent && state.stateType == BlocStateType.success){
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message:
              "Verifizierungsemail erfolgreich gesendet",
        ),
      );

    } else if (state is VerificationEmailSent && state.stateType == BlocStateType.error) {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message:
              "Fehler beim Sender der Verifizierungsmail",
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
                width: double.infinity,
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
                      
                      const SizedBox(height: 150,),

                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: 
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          listener: blocListener,
                          buildWhen: buildWhen,
                          builder: blocBuilder,
                        ),
                      ),

                      const Text("Please verify your E-Mail address to proceed",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      
                      
                      const SizedBox(height: 30,),
                          
                      //Verification button
                      ElevatedButton(
                        onPressed: () async {
                
                          BlocProvider.of<AuthenticationBloc>(context).add(
                            VerifyUserEvent()
                          );
                
                        }, 
                        child: const Text('Verify')
                      ),
                          
                          
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
