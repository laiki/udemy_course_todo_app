import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/data/models/tag.dart';
import 'package:todo_app/domain/helpers/firestore_keys.dart';
import 'package:todo_app/domain/interfaces/tag_db_interface.dart';

class TagFirestoreService implements TagDBInterface {  
  
  static final CollectionReference usersCollectionRef = FirebaseFirestore.instance.collection(USERS_COLLECTION_KEY);

  @override
  Future<bool> createTag(Tag tag) async{
    final tagsCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TAG_COLLECTION_KEY);

    final tagDocRef = tagsCollectionRef.doc(tag.uuid);

    final data = tag.toJson();

    await tagDocRef.set(data);

    return true;
  }

  @override
  Future<bool> deleteTag(String id) async{
    final tagsCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TAG_COLLECTION_KEY);

    final tagDocRef = tagsCollectionRef.doc(id);

    await tagDocRef.delete();

    return true;
  }

  @override
  Stream<List<Tag>> getAllTags() {
    final tagCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TAG_COLLECTION_KEY);

    return tagCollectionRef.snapshots().map((snapshot) {
      List<Tag> tags = [];
      for (var element in snapshot.docs) {
        Tag tag = Tag.fromJson(element.data());
        tags.add(tag);
      }
      return tags;
    });
  }

  @override
  Future<bool> updateTag(Tag tag) async{
    final tagsCollectionRef = 
      usersCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection(TAG_COLLECTION_KEY);

    final tagDocRef = tagsCollectionRef.doc(tag.uuid);

    final data = tag.toJson();

    await tagDocRef.update(data);

    return true;
  }
}
