import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/auth.dart';

Future<void> login(
    {required String name,
      required String password,
      required BuildContext context,
      required Function update}) async {
  if (name == "" || password == "") {
    showSnack(text: "Введите имя и пароль.", context: context);
    return;
  }
  String response = await loginUser(name, password);
  if (response == "Server error") {
    showSnack(text: "Ошибка.Попробуйте позже.", context: context);
    return;
  }
  if (response == "Invalid credentials") {
    showSnack(text: "Вы ввели неверное имя или пароль.", context: context);
    return;
  }

  saveUser(User(login: name,password: password));
  update();
}

void showSnack({required String text, required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text),
  ));
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required this.update});

  Function update;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 500,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Center(
                    child: Text('С возвращением в ЭнергоКонтрольАдмин!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold))),
                const SizedBox(height: 20),
                const Text('Авторизация', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 20),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    hintText: 'Логин',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Пароль',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => login(
                      name: nameController.text,
                      password: passwordController.text,
                      context: context,
                      update: update),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    minimumSize: const Size(88, 44), // Specific size
                  ),
                  child: const Text('Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
