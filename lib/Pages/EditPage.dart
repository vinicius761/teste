import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:teste/Components/AppbarComponent.dart';
import 'package:teste/Controllers/UserController.dart';

class EditPage extends StatelessWidget {
  final controller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarComponent(title: 'Editar Usuário'),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Form(
          key: controller.formEditKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.nomeEdit,
                decoration: InputDecoration(
                  hintText: 'Digite seu nome',
                  labelText: 'Nome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome obrigatório';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: controller.sobrenomeEdit,
                decoration: InputDecoration(
                  hintText: 'Digite seu Sobrenome',
                  labelText: 'Sobrenome',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Sobrenome obrigatório';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: controller.emailEdit,
                decoration: InputDecoration(
                  hintText: 'Digite seu E-mail',
                  labelText: 'E-mail',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email obrigatório';
                  }
                  if (!value.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),

              TextFormField(
                controller: controller.senhaEdit,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Digite sua Senha',
                  labelText: 'Senha',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha obrigatória';
                  }

                  if (value.length < 6) {
                    return 'Senha deve ter no mínimo 6 caracteres';
                  }

                  return null;
                },
              ),

              TextFormField(
                controller: controller.confirmarSenhaEdit,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirme sua Senha',
                  labelText: 'Confirme sua Senha',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirmação obrigatória';
                  }

                  if (value != controller.senhaEdit.text) {
                    return 'As senhas não conferem';
                  }

                  return null;
                },
              ),

              SizedBox(height: 20),

              InkWell(
                onTap: controller.updateUser,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(15),
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'Salvar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
