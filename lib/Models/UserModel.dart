import 'dart:convert';

class UserModel {
  final int id;
  final String nome;
  final String sobrenome;
  final String email;
  final String senha;
  final String? avatar;

  UserModel({
    required this.id,
    required this.nome,
    required this.sobrenome,
    required this.email,
    required this.senha,
    this.avatar,
  });

  /// Converte UserModel para Map (útil para SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'sobrenome': sobrenome,
      'email': email,
      'senha': senha,
      'avatar': avatar,
    };
  }

  /// Cria UserModel a partir de Map (útil para SQLite)
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      nome: map['nome'],
      sobrenome: map['sobrenome'],
      email: map['email'],
      senha: map['senha'],
      avatar: map['avatar'],
    );
  }

  /// Converte UserModel para JSON (String)
  String toJson() => json.encode(toMap());

  /// Cria UserModel a partir de JSON (String)
  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
