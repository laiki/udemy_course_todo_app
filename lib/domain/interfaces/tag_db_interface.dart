import 'package:todo_app/data/models/tag.dart';

abstract class TagDBInterface {
  
  Future<bool> createTag(Tag tag);

  Stream<List<Tag>> getAllTags();

  Future<bool> updateTag(Tag tag);

  Future<bool> deleteTag(String id);

}