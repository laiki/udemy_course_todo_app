// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todo_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/core/routes.dart';

class Navbar extends StatelessWidget {
  
  Navbar({super.key});

  late String? currentLanguage;

  @override
  Widget build(BuildContext context) {
    
    currentLanguage = Localizations.localeOf(context).languageCode;
    bool isLightTheme = Theme.of(context).brightness == Brightness.light;

    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if(state is LogoutState && state.stateType == BlocStateType.success){
          Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
        }
      },
      child: Drawer(
          child: ListView(
            children: [
              DrawerHeader(child: Container()),
    
              ListTile(
                leading: getLanguageFlag(),
                title: Text(translate('sidebar_changelanguage')),
                onTap: () {

                  if(currentLanguage == null) return;

                  if(currentLanguage == "en"){
                    changeLocale(context, "de");
                  } else {
                    changeLocale(context, "en");
                  }
                  
    
                },
              ),
    
              ListTile(
                leading: Icon( isLightTheme ? Icons.dark_mode : Icons.light_mode),
                title: Text(translate(isLightTheme ? 'sidebar_darktheme' : 'sidebar_lighttheme')),
                onTap: () {
                  
                  if(isLightTheme){
                    BlocProvider.of<ThemeBloc>(context).add(
                      ThemeChangedEvent(false)
                    );

                  } else {
                    BlocProvider.of<ThemeBloc>(context).add(
                      ThemeChangedEvent(true)
                    );
                  }

                },
              ),
    
              ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: Text(translate('sidebar_logout')),
                onTap: () {
                  
                  BlocProvider.of<AuthenticationBloc>(context).add(
                    LogoutEvent()
                  );
                },
              )
            ],
            
          ),
        ),
    );
  }

  getLanguageFlag(){
    if(currentLanguage == null) return;

    if(currentLanguage == "en"){
      return Image.asset(
        'assets/flags/de.png',
        width: 30,
        height: 30,
      );

    } else {
      return Image.asset(
        'assets/flags/gb.png',
        width: 30,
        height: 30,
      );
    }


  }
}