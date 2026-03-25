import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:teste/Models/UserModel.dart';

class UserController extends GetxController {
  Rx<UserModel?> user = Rx<UserModel?>(null);

  RxList<UserModel> users = <UserModel>[
    UserModel(
      id: 1,
      nome: 'João',
      sobrenome: 'Silva',
      email: 'joao@email.com',
      senha: '123456',
      avatar: 'https://i.pravatar.cc/150?img=1',
    ),
    UserModel(
      id: 2,
      nome: 'Maria',
      sobrenome: 'Oliveira',
      email: 'maria@email.com',
      senha: 'abcdef',
      avatar: 'https://i.pravatar.cc/150?img=2',
    ),
    UserModel(
      id: 3,
      nome: 'Carlos',
      sobrenome: 'Souza',
      email: 'carlos@email.com',
      senha: 'qwerty',
      avatar: 'https://i.pravatar.cc/150?img=3',
    ),
  ].obs;

  ///formulário de criação de usuário
  final formKey = GlobalKey<FormState>();
  TextEditingController nome = TextEditingController();
  TextEditingController sobrenome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  TextEditingController confirmarSenha = TextEditingController();

  void salvar() {
    if (formKey.currentState!.validate()) {
      final res = UserModel(
        id: DateTime.now().millisecondsSinceEpoch,
        nome: nome.text,
        sobrenome: sobrenome.text,
        email: email.text,
        senha: senha.text,
      );

      users.add(res);

      // limpar campos
      nome.clear();
      sobrenome.clear();
      email.clear();
      senha.clear();
      confirmarSenha.clear();

      Get.back();

      Get.snackbar(
        'Sucesso',
        'Usuário válido!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  edit() {}

  void excluir(int id) {
    Get.dialog(
      AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir este usuário?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // fecha o dialog
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              users.removeWhere((user) => user.id == id);
              Get.back(); // fecha o dialog

              Get.snackbar(
                'Sucesso',
                'Usuário excluído!',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
