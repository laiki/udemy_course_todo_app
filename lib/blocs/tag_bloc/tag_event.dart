part of 'tag_bloc.dart';

@immutable
sealed class TagEvent {}

class CreateTagEvent implements TagEvent {
  final Tag tag;

  CreateTagEvent(this.tag);
}

class ReadAllTagsEvent implements TagEvent {}

class UpdateTagEvent implements TagEvent {
  final Tag tag;

  UpdateTagEvent(this.tag);
}

class DeleteTagEvent implements TagEvent {
  final String id;

  DeleteTagEvent(this.id);
}
