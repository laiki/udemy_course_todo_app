part of 'teststuff_bloc.dart';

@immutable
sealed class TeststuffEvent {}

class  TeststuffEvent_1 extends TeststuffEvent {
  String sTest;
  int iValue; 

 TeststuffEvent_1(this.sTest, this.iValue); 
}
class  TeststuffEvent_2 extends TeststuffEvent {
  String sTest;
  double dValue; 

 TeststuffEvent_2(this.sTest, this.dValue); 
}

