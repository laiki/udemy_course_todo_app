import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:todo_app/core/bloc_state_type.dart';
import 'package:todo_app/data/models/tag.dart';
import 'package:todo_app/domain/interfaces/tag_db_interface.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  TagBloc() : super(const TagInitial()) {

    final getIt = GetIt.instance;

    on<CreateTagEvent>((event, emit) async{
      emit(const TagCreatedState(BlocStateType.loading));

      bool tagCreated = await getIt<TagDBInterface>().createTag(event.tag);

      if(tagCreated){
        emit(const TagCreatedState(BlocStateType.success));

      } else {
        emit(const TagCreatedState(BlocStateType.error));
      }
    });

    on<ReadAllTagsEvent>((event, emit) async{
      emit(const ReadAllTagsState(BlocStateType.loading));

      try {
        
        await emit.forEach(
          getIt<TagDBInterface>().getAllTags(), 
          onData: (List<Tag> tags) => 
            ReadAllTagsState(BlocStateType.success, tags: tags));
      
      } catch (ex){

        emit(const ReadAllTagsState(BlocStateType.error));

      }
    });

    on<UpdateTagEvent>((event, emit) async{
      emit(const TagUpdatedState(BlocStateType.loading));

      bool tagUpdated = await getIt<TagDBInterface>().updateTag(event.tag);

      if(tagUpdated){
        emit(const TagUpdatedState(BlocStateType.success));

      } else {
        emit(const TagUpdatedState(BlocStateType.error));
      }
    });

    on<DeleteTagEvent>((event, emit) async{
      emit(const TagDeletedState(BlocStateType.loading));

      bool tagDeleted = await getIt<TagDBInterface>().deleteTag(event.id);

      if(tagDeleted){
        emit(const TagDeletedState(BlocStateType.success));

      } else {
        emit(const TagDeletedState(BlocStateType.error));
      }
    });
  }
}
