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
}
