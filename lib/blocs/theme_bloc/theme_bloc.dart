import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/core/bloc_state_type.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    
    on<ThemeChangedEvent>((event, emit) {

      if(event.changeToLightMode){
        emit(LightThemeState(BlocStateType.success));
      
      } else {
        emit(DarkThemeState(BlocStateType.success));

      }

    });
  }
}
