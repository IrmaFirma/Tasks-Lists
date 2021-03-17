import 'package:flutter/material.dart';

class Lists{
  final String name;
  final String comment;
  final String id;

  Lists({@required this.name, this.comment, this.id});

  factory Lists.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    final String comment = data['comment'];
    return Lists(name: name, comment: comment, id: documentId);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'comment': comment};
  }

}