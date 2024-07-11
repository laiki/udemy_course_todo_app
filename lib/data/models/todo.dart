import 'package:uuid/uuid.dart';

class Todo {

  final String uuid;
  String name;
  bool status;
  final DateTime? dateCreated;
  DateTime? dateLastModified;
  DateTime? dateDue;
  List<String>? tag;
  int? priority;

  Todo(
    this.name, 
    this.dateCreated, 
    {
      String? uuid,
      this.status = false,
      this.dateLastModified, 
      this.dateDue, 
      List<String>? tag, 
      this.priority
    }) : uuid = uuid ?? const Uuid().v1()
        ,tag = tag ?? [];

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'status': status,
    'dateCreated': dateCreated?.toIso8601String(),
    'dateLastModified': dateLastModified?.toIso8601String(),
    'dateDue': dateDue?.toIso8601String(),
    'tag': tag,
    'priority': priority
  };

  factory Todo.fromJson(Map<String, dynamic> json){
    return Todo(
      json['name'],
      DateTime.tryParse(json['dateCreated'] as String? ?? ''),
      uuid: json['uuid'],
      status: json['status'],
      dateLastModified: DateTime.tryParse(json['dateLastModified']as String? ?? ''),
      dateDue: DateTime.tryParse(json['dateDue']as String? ?? ''),
      tag: List<String>.from(json['tag'] ?? []),
      priority: json['priority']
    );
  }
}