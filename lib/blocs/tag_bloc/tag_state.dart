part of 'tag_bloc.dart';

@immutable
sealed class TagState {
  final BlocStateType blocStateType;

  const TagState(this.blocStateType);

}

final class TagInitial extends TagState {
  const TagInitial() : super(BlocStateType.success);
}

final class TagCreatedState extends TagState {
  const TagCreatedState(super.blocStateType);
}

final class ReadAllTagsState extends TagState {
  final List<Tag>? tags;

  const ReadAllTagsState(super.blocStateType, {this.tags});

}

final class TagDeletedState extends TagState {
  const TagDeletedState(super.blocStateType);
}

final class TagUpdatedState extends TagState {
  const TagUpdatedState(super.blocStateType);
}
