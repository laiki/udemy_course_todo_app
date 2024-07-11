
import 'package:flutter/material.dart';
import 'package:todo_app/presentation/screens/chat_screen.dart';
import 'package:todo_app/presentation/screens/home_screen.dart';
import 'package:todo_app/presentation/screens/login_screen.dart';
import 'package:todo_app/presentation/screens/registration_screen.dart';
import 'package:todo_app/presentation/screens/verification_screen.dart';

const String loginRoute = "/login";
const String homeRoute = "/home";
const String registrationRoute = "/register";
const String verificationRoute = "/verification";
const String chatRoute = "/chat";

Map<String, Widget Function(BuildContext)> getRoutes(BuildContext context){
  return {
    loginRoute: (context) => const LoginScreen(title: "Login"),
    homeRoute: (context) => const HomeScreen(),
    registrationRoute: (context) => const RegistrationScreen(),
    verificationRoute: (context) => const VerificationScreen(),
    chatRoute: (context) => const ChatScreen(),
  };
}