import 'dart:convert';

class UserModel {
  final int    id;
  final String nombre;
  final String apellido;
  final String email;
  final String rol;
  final bool   activo;

  const UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.rol,
    required this.activo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id:       json['id'],
    nombre:   json['nombre'],
    apellido: json['apellido'],
    email:    json['email'],
    rol:      json['rol'],
    activo:   json['activo'] == true || json['activo'] == 1,
  );

  Map<String, dynamic> toJson() => {
    'id':       id,
    'nombre':   nombre,
    'apellido': apellido,
    'email':    email,
    'rol':      rol,
    'activo':   activo,
  };

  static UserModel fromJsonString(String source) =>
      UserModel.fromJson(jsonDecode(source) as Map<String, dynamic>);

  String get fullName => '$nombre $apellido';
}
