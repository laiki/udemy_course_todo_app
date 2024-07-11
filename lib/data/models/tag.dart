import 'package:uuid/uuid.dart';

class Tag {

  final String uuid;
  String name;
  int color;

  Tag(this.name, this.color, {String? uuid}) : uuid = uuid ?? const Uuid().v1();

  Map<String, dynamic> toJson() => {
    'uuid': uuid,
    'name': name,
    'color': color
  };

  factory Tag.fromJson(Map<String, dynamic> json){
    return Tag(
      json['name'],
      json['color'],
      uuid: json['uuid']
    );
  }

}