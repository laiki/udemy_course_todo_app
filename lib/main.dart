import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:todo_app/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:todo_app/blocs/chat_bloc/chat_bloc.dart';
import 'package:todo_app/blocs/tag_bloc/tag_bloc.dart';
import 'package:todo_app/blocs/theme_bloc/theme_bloc.dart';
import 'package:todo_app/blocs/todo_bloc/todo_bloc.dart';
import 'package:todo_app/core/firebase_options.dart';
import 'package:todo_app/core/routes.dart' as routes;
import 'package:todo_app/core/service_registration.dart' as service_registration;
import 'package:todo_app/core/themes/dark_theme.dart';
import 'package:todo_app/core/themes/light_theme.dart';
import 'presentation/screens/login_screen.dart';

void main() async {

  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en_US',
      supportedLocales: ['en_US', 'de']);
      
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await service_registration.init();

  runApp(LocalizedApp(delegate, 
  const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    var localizationDelegate = LocalizedApp.of(context).delegate;

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
          create: (BuildContext context) => AuthenticationBloc(),
        ),
        BlocProvider<ThemeBloc>(
          create: (BuildContext context) => ThemeBloc()
        ),
        BlocProvider<TodoBloc>(
          create: (BuildContext context) => TodoBloc()
        ),
        BlocProvider<TagBloc>(
          create: (BuildContext context) => TagBloc()
        ),
        BlocProvider<ChatBloc>(
          create: (BuildContext context) => ChatBloc()
        )
      ],
      
      child: LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  localizationDelegate
                ],
                debugShowCheckedModeBanner: false,
                supportedLocales: localizationDelegate.supportedLocales,
                locale: localizationDelegate.currentLocale,
                  title: 'Flutter Demo',
                  routes: routes.getRoutes(context),
                  themeMode: ThemeMode.system,
                  theme: getTheme(state),
                  darkTheme: getDarkTheme(),
                  home: const LoginScreen(title: 'Flutter Demo Home Page'),
                );
          },
        ),
      ),
    );
  }

  getTheme(ThemeState state){

    if(state is ThemeInitial) return getLightTheme();

    if(state is LightThemeState) return getLightTheme();

    if(state is DarkThemeState) return getDarkTheme();

  }
}

