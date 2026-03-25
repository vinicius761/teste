import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_picker/image_picker.dart';
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

  ///formulário de edir de usuário
  final formEditKey = GlobalKey<FormState>();
  TextEditingController nomeEdit = TextEditingController();
  TextEditingController sobrenomeEdit = TextEditingController();
  TextEditingController emailEdit = TextEditingController();
  TextEditingController senhaEdit = TextEditingController();
  TextEditingController confirmarSenhaEdit = TextEditingController();
  final ImagePicker picker = ImagePicker();
  RxString avatarPath = ''.obs;

  RxBool isEditing = false.obs;
  RxInt idEdit = 0.obs;

  Future<void> tirarFoto() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      avatarPath.value = photo.path; // 👈 SALVA O CAMINHO
    }
  }

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

  void editar(int id) {
    final res = users.firstWhere((u) => u.id == id);

    nomeEdit.text = res.nome;
    sobrenomeEdit.text = res.sobrenome;
    emailEdit.text = res.email;
    senhaEdit.text = res.senha;
    confirmarSenhaEdit.text = res.senha;

    idEdit.value = id;
    isEditing.value = true;

    Get.toNamed('/edit');
  }

  void updateUser() {
    if (formEditKey.currentState!.validate()) {
      final index = users.indexWhere((u) => u.id == idEdit.value);

      if (index != -1) {
        users[index] = UserModel(
          id: idEdit.value,
          nome: nomeEdit.text,
          sobrenome: sobrenomeEdit.text,
          email: emailEdit.text,
          senha: senhaEdit.text,
          avatar: avatarPath.value,
        );

        users.refresh();

        isEditing.value = false;

        Get.back();

        Get.snackbar(
          'Sucesso',
          'Usuário atualizado!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

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
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
