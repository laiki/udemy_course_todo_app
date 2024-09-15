// ignore_for_file: camel_case_types

part of 'teststuff_bloc.dart';

@immutable
sealed class TeststuffState {}

final class TeststuffInitial extends TeststuffState {}

final class Teststuff_Fail_State extends TeststuffState{}
final class Teststuff_Success_State extends TeststuffState{}
final class Teststuff_Running_State extends TeststuffState{}


