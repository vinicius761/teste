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
import 'package:teste/utils/DB.dart';

class UserController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadUsers(); // carrega usuários do SQLite ao iniciar
  }

  Rx<UserModel?> user = Rx<UserModel?>(null);

  RxList<UserModel> users = <UserModel>[].obs;

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
      avatarPath.value = photo.path;
    }
  }

  Future<void> loadUsers() async {
    final dbUsers = await DatabaseHelper.instance.getUsers();
    users.assignAll(dbUsers); // atualiza a lista reativa
  }

  void salvar() async {
    if (formKey.currentState!.validate()) {
      final newUser = UserModel(
        id: DateTime.now().millisecondsSinceEpoch,
        nome: nome.text,
        sobrenome: sobrenome.text,
        email: email.text,
        senha: senha.text,
        avatar: avatarPath.value.isEmpty ? null : avatarPath.value,
      );

      // salva no SQLite
      await DatabaseHelper.instance.insertUser(newUser);

      // atualiza a lista reativa
      users.add(newUser);

      // limpa campos
      nome.clear();
      sobrenome.clear();
      email.clear();
      senha.clear();
      confirmarSenha.clear();
      avatarPath.value = '';

      Get.back();
      Get.snackbar(
        'Sucesso',
        'Usuário salvo no banco!',
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

  void updateUser() async {
    if (formEditKey.currentState!.validate()) {
      final updatedUser = UserModel(
        id: idEdit.value,
        nome: nomeEdit.text,
        sobrenome: sobrenomeEdit.text,
        email: emailEdit.text,
        senha: senhaEdit.text,
        avatar: avatarPath.value,
      );

      // atualiza no SQLite
      await DatabaseHelper.instance.updateUser(updatedUser);

      // atualiza a lista reativa
      final index = users.indexWhere((u) => u.id == idEdit.value);
      if (index != -1) {
        users[index] = updatedUser;
        users.refresh();
      }

      isEditing.value = false;
      Get.back();
      Get.snackbar(
        'Sucesso',
        'Usuário atualizado no banco!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void excluir(int id) async {
    Get.dialog(
      AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Tem certeza que deseja excluir este usuário?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancelar')),
          TextButton(
            onPressed: () async {
              // remove do SQLite
              await DatabaseHelper.instance.deleteUser(id);

              // remove da lista reativa
              users.removeWhere((u) => u.id == id);

              Get.back();
            },
            child: Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
