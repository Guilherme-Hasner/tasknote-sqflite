// ignore_for_file: use_build_context_synchronously

import 'package:appsqflite/pages/task/task_list.dart';
import 'package:appsqflite/pages/user/user_create.dart';
import 'package:appsqflite/pages/user/user_restoreAccountRequest.dart';
import 'package:appsqflite/services/user_controller.dart';
import 'package:appsqflite/src/shared/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  // Mensagem de !Validação
  bool _validated = false;
  String _validationMessage = "* Mensagem de validação";
  Widget validationErrorMessage() {
    if (!_validated) {
      return const SizedBox(height: 30); // Padding
    } else {
      return Column(
        children: <Widget>[
          const SizedBox(height: 12), // Padding
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _validationMessage,
              style: GoogleFonts.roboto(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 10), // Padding
        ],
      );
    }
  }

  // Layout constants
  static const double _labelFontSize = 22;
  static const double _txtBoxFontSize = 18;
  static const double _secondaryFontSize = 19;

  static const double _txtBoxHeight = 40;
  static const double _buttonHeight = 36;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 100),
        scrollDirection: Axis.vertical,
        child: Center(
          child: SizedBox(
            width: 320,
            height: 680,
            child: Column(
              children: <Widget>[
                // Título
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Tasks',
                      style: GoogleFonts.leagueSpartan(
                        color: ThemeColors.secondary,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' - Login',
                      style: GoogleFonts.leagueSpartan(
                        color: ThemeColors.secondarySubtle,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24), // Padding
                // Label: Usuário
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Usuário',
                    style: GoogleFonts.leagueSpartan(
                      color: ThemeColors.secondary,
                      fontSize: _labelFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 3), // Padding
                // TextField: Usuário
                SizedBox(
                  height: _txtBoxHeight,
                  child: TextFormField(
                    textAlignVertical: const TextAlignVertical(y: 1),
                    controller: _userController,
                    maxLength: 25,
                    style: GoogleFonts.roboto(
                      fontSize: _txtBoxFontSize,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Usuário',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.secondarySubtle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14), // Padding
                // Label: Senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Senha',
                    style: GoogleFonts.leagueSpartan(
                      color: ThemeColors.secondary,
                      fontSize: _labelFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 3), // Padding
                // TextField: Senha
                SizedBox(
                  height: _txtBoxHeight,
                  child: TextFormField(
                    textAlignVertical: const TextAlignVertical(y: 1),
                    controller: _passwordController,
                    maxLength: 30,
                    obscureText: !_showPassword,
                    obscuringCharacter: '*',
                    style: GoogleFonts.roboto(
                      fontSize: _txtBoxFontSize,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'Senha',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.secondarySubtle),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword = !_showPassword;
                            });
                          },
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                validationErrorMessage(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Redirect: Recuperar Conta
                    GestureDetector(
                      onTap: () {
                        // Validations_Script
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const UserPasswordChangeRequest()));
                      },
                      child: Text(
                        'Esqueceu a senha?',
                        style: GoogleFonts.leagueSpartan(
                          color: ThemeColors.primaryMediumDark,
                          fontSize: _secondaryFontSize,
                        ),
                      ),
                    ),
                    // Button: Entrar
                    ElevatedButton(
                      onPressed: () async {
                        // Validations_Script
                        String username = _userController.text;
                        String password = _passwordController.text;

                        Result validation =
                            await UserController.login(username, password);
                        if (validation.success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TaskListScreen(),
                            ),
                          );
                        } else {
                          setState(() {
                            _validated = true;
                          });
                          if (validation.type == "emptyFields") {
                            _validationMessage = "* Preencha todos os campos";
                          } else {
                            _validationMessage =
                                "* Usuário ou senha incorretos";
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          minimumSize: const Size(120, _buttonHeight),
                          backgroundColor: ThemeColors.primary),
                      child: Text(
                        'Entrar',
                        style: GoogleFonts.leagueSpartan(
                          color: ThemeColors.background,
                          fontSize: _secondaryFontSize,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24), // Padding
                // Label: Redirect - Criar Conta
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 21,
                          height: 2,
                          color: ThemeColors.primaryMediumDark,
                        ),
                      ),
                    ),
                    Text(
                      'Ainda não possui uma conta?',
                      style: GoogleFonts.leagueSpartan(
                        color: ThemeColors.primaryMediumDark,
                        fontSize: _secondaryFontSize,
                      ),
                    ),
                    SizedBox(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 21,
                          height: 2,
                          color: ThemeColors.primaryMediumDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20), // Padding
                ElevatedButton(
                  // Button: Criar Conta
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserRegister()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      minimumSize: const Size(328, _buttonHeight),
                      backgroundColor: ThemeColors.primaryLightDark),
                  child: Text(
                    'Crie uma conta',
                    style: GoogleFonts.leagueSpartan(
                      color: ThemeColors.background,
                      fontSize: _secondaryFontSize,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
