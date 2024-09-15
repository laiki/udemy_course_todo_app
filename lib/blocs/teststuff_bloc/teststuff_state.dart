part of 'teststuff_bloc.dart';

@immutable
sealed class TeststuffState {}

final class TeststuffInitial extends TeststuffState {}

final class Teststuff_fail_State extends TeststuffState{}
final class Teststuff_sucess_State extends TeststuffState{}
final class Teststuff_ongoing_State extends TeststuffState{}


