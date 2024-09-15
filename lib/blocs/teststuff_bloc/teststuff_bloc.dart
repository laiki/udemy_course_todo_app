import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/domain/interfaces/teststuff_interface.dart';

part 'teststuff_event.dart';
part 'teststuff_state.dart';

class TeststuffBloc extends Bloc<TeststuffEvent, TeststuffState> {
  final getIt = GetIt.instance;

  TeststuffBloc() : super(TeststuffInitial()) {
    on<TeststuffEvent_1>((event, emit) async {
      
      emit(Teststuff_Running_State());
      try{
        bool success = await getIt<TeststuffInterface>().process1(event.sTest, event.iValue);

        if (success){
          emit(Teststuff_Success_State()); 
        } else {
          emit(Teststuff_Fail_State());
        }
      } on Exception catch (e) {

      }

    });

    on<TeststuffEvent_2>((event, emit) async {
      
      emit(Teststuff_Running_State());
      try{
        bool success = await getIt<TeststuffInterface>().process2(event.sTest, event.dValue);

        if (success){
          emit(Teststuff_Success_State()); 
        } else {
          emit(Teststuff_Fail_State());
        }
      } on Exception catch (e) {

      }

    });
  }
}
