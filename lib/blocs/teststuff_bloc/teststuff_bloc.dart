import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'teststuff_event.dart';
part 'teststuff_state.dart';

class TeststuffBloc extends Bloc<TeststuffEvent, TeststuffState> {
  TeststuffBloc() : super(TeststuffInitial()) {
    on<TeststuffEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
