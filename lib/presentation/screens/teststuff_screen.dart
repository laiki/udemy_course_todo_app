
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todo_app/blocs/teststuff_bloc/teststuff_bloc.dart';
import 'package:todo_app/presentation/views/input_field.dart';

class TeststuffWidget extends StatefulWidget {
  const TeststuffWidget({super.key});

  @override
  State<TeststuffWidget> createState() => _TeststuffWidgetState();
}

class _TeststuffWidgetState extends State<TeststuffWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _teststuffString = TextEditingController();
  final TextEditingController _teststuffInt    = TextEditingController();
  final TextEditingController _teststuffDouble = TextEditingController();


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
                child: Text("${translate("teststuff_screen_welcome-message")}!", 
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
                          BlocConsumer<TeststuffBloc, TeststuffState>(
                            listener: blocListener,
                            buildWhen: buildWhen,
                            builder: blocBuilder,
                          ),
                        ),
                                  
                        //teststuff_string
                        InputField(
                          textEditingController: _teststuffString, 
                          labelText: translate('teststuff_string_label'),
                          iconData: Icons.person,
                          //validator: emailValidator,
                        ),
                        //teststuff_string
                        InputField(
                          textEditingController: _teststuffInt, 
                          labelText: translate('teststuff_int_label'),
                          iconData: Icons.person,
                          //validator: emailValidator,
                        ),
                        //teststuff_string
                        InputField(
                          textEditingController: _teststuffDouble, 
                          labelText: translate('teststuff_double_label'),
                          iconData: Icons.person,
                          //validator: emailValidator,
                        ),
                                  
                       
                        const SizedBox(height: 30,),
                            
                        //Login button
                        ElevatedButton(
                          onPressed: () async {
                                  
                            if (_formKey.currentState!.validate()) {
                              BlocProvider.of<TeststuffBloc>(context).add(
                                TeststuffEvent_1(_teststuffString.text, int.parse(_teststuffInt.text)));
                            }
                                  
                          }, 
                          child: Text(translate('teststuffscreen_process1btn_text'))
                        ),
                            
                        const SizedBox(height: 20,),
                            
                        // RegistrationOrLoginText(
                        //   onTap: () {
                        //     Navigator.popAndPushNamed(context, registrationRoute);
                        //   },
                        //   text1: translate("loginscreen_registration_text1"),
                        //   text2: translate("login_screen_registration_text2"), )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),)

    )
  }
}