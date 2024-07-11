part of 'theme_bloc.dart';

sealed class ThemeState {
  final BlocStateType stateType;

  ThemeState(this.stateType);
}

final class ThemeInitial extends ThemeState {
  ThemeInitial() : super(BlocStateType.success);
}

final class DarkThemeState extends ThemeState{
  DarkThemeState(super.stateType);
}

final class LightThemeState extends ThemeState{
  LightThemeState(super.stateType);
}
