// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:generac/model.dart';

class UserModel extends GenericModelFunction<UserModel> {
  num id;
  String name;
  String email;
  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  UserModel copyWith({
    num? id,
    String? name,
    String? email,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
    };
  }

  @override
  String toJson() => json.encode(toMap());

  @override
  String toString() => 'UserModel(id: $id, name: $name, email: $email)';

  @override
  UserModel fromJson(String source) {
    return fromMap(json.decode(source));
  }

  @override
  UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as num,
      name: map['name'] as String,
      email: map['email'] as String,
    );
  }
}
