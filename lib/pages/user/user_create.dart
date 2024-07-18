// ignore_for_file: use_build_context_synchronously

import 'package:appsqflite/pages/user/user_login.dart';
import 'package:appsqflite/pages/util/redirect_screen.dart';
import 'package:appsqflite/services/user_controller.dart';
import 'package:appsqflite/src/shared/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserRegister extends StatefulWidget {
  const UserRegister({super.key});

  @override
  State<UserRegister> createState() => _UserRegisterState();
}

class _UserRegisterState extends State<UserRegister> {
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  bool _showPassword = false;

  // Mensagem de !Validação
  bool _validated = false;
  String _validationMessage = "* Mensagem de validação";
  Widget validationErrorMessage() {
    if (!_validated) {
      return const SizedBox(height: 32); // Padding
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
          const SizedBox(height: 16), // Padding
        ],
      );
    }
  }

  // Validação: Campos de senha correspondem
  bool _passwordFieldsMatch = true;
  Color _passwordFieldOutline = ThemeColors.secondarySubtle;
  void _comparePasswordFields() {
    if (_password1Controller.text == _password2Controller.text) {
      setState(() {
        _passwordFieldsMatch = true;
        _passwordFieldOutline = ThemeColors.secondarySubtle;
      });
    } else {
      setState(() {
        _passwordFieldsMatch = false;
        _passwordFieldOutline = Colors.red;
      });
    }
  }

  // Layout constants
  static const double _labelFontSize = 22;
  static const double _txtBoxFontSize = 18;
  static const double _hintBoxFontSize = 14;

  static const double _txtBoxHeight = 40;
  static const double _iconSize = 28;
  static const double _paddingLabel2TxtField = 3;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: GestureDetector(
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 32,
                          color: Colors.grey,
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserLogin()));
                        },
                      ),
                    ),
                    const SizedBox(width: 44), // Padding
                    // Título
                    Text(
                      'Criar Conta',
                      style: GoogleFonts.leagueSpartan(
                        color: ThemeColors.secondarySubtle,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14), // Padding
                // Label: Usuário
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Usuário',
                      style: GoogleFonts.leagueSpartan(
                        color: ThemeColors.secondary,
                        fontSize: _labelFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Tooltip: UserField
                    GestureDetector(
                      child: Icon(
                        Icons.help,
                        color: ThemeColors.lightGrey,
                        size: 25,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              insetPadding: const EdgeInsets.only(bottom: 364),
                              child: Container(
                                width: 318.375,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  // Regras para criação de usuário
                                  "O seu nome de usuário deve ser único, contendo apenas caracteres alfanuméricos (sem caracteres especiais), não conter espaços vazios e ter no mínimo 5 caracteres.",
                                  style: GoogleFonts.roboto(
                                    color: ThemeColors.secondary,
                                    fontSize: _hintBoxFontSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: _paddingLabel2TxtField), // Padding
                // TextField: Usuário
                SizedBox(
                  height: _txtBoxHeight,
                  child: TextFormField(
                    textAlignVertical: const TextAlignVertical(y: 1),
                    controller: _userNameController,
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
                const SizedBox(height: 10), // Padding
                // Label: E-mail
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'E-mail',
                    style: GoogleFonts.leagueSpartan(
                      color: ThemeColors.secondary,
                      fontSize: _labelFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: _paddingLabel2TxtField), // Padding
                // TextField: E-mail
                SizedBox(
                  height: _txtBoxHeight,
                  child: TextFormField(
                    textAlignVertical: const TextAlignVertical(y: 1),
                    controller: _emailController,
                    maxLength: 80,
                    style: GoogleFonts.roboto(
                      fontSize: _txtBoxFontSize,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: 'E-mail',
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.secondarySubtle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10), // Padding
                // Label: Senha
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Senha',
                      style: GoogleFonts.leagueSpartan(
                        color: ThemeColors.secondary,
                        fontSize: _labelFontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Tooltip: PasswordField
                    GestureDetector(
                      child: Icon(
                        Icons.help,
                        color: ThemeColors.lightGrey,
                        size: 25,
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              insetPadding: const EdgeInsets.only(bottom: 68),
                              child: Container(
                                width: 318.375,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  // Regras para definição de senha
                                  "Sua senha deve ter no mínimo 5 caracteres e não pode ter espaços vazios.",
                                  style: GoogleFonts.roboto(
                                    color: ThemeColors.secondary,
                                    fontSize: _hintBoxFontSize,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: _paddingLabel2TxtField), // Padding
                // TextField: Senha
                SizedBox(
                  height: _txtBoxHeight,
                  child: TextFormField(
                    controller: _password1Controller,
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
                        borderSide: BorderSide(color: _passwordFieldOutline),
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
                            size: _iconSize,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _comparePasswordFields();
                    },
                  ),
                ),
                const SizedBox(height: 10), // Padding
                // Label: Confirmar Senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Confirmar Senha',
                    style: GoogleFonts.leagueSpartan(
                      color: ThemeColors.secondary,
                      fontSize: _labelFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: _paddingLabel2TxtField), // Padding
                // TextField: Confirmar Senha
                SizedBox(
                  height: _txtBoxHeight,
                  child: TextFormField(
                    controller: _password2Controller,
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
                        borderSide: BorderSide(color: _passwordFieldOutline),
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
                            size: _iconSize,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      _comparePasswordFields();
                    },
                  ),
                ),
                validationErrorMessage(),
                Align(
                  alignment: Alignment.centerRight,
                  // Button: Insert
                  child: ElevatedButton(
                    onPressed: () async {
                      // Validations_Script
                      String username = _userNameController.text;
                      String email = _emailController.text;
                      String password1 = _password1Controller.text;
                      String password2 = _password2Controller.text;

                      Result validation;
                      if (username == "" ||
                          email == "" ||
                          password1 == "" ||
                          password2 == "") {
                        setState(() {
                          validation =
                              const Result(success: false, type: "emptyFields");
                          _validated = true;
                          _validationMessage = "* Preencha todos os campos";
                        });
                      } else {
                        if (!_passwordFieldsMatch) {
                          setState(() {
                            validation = const Result(
                                success: false, type: "passwordsMismatch");
                            _validated = true;
                            _validationMessage =
                                "* As senhas inseridas são distintas";
                          });
                        } else {
                          validation = await UserController.insert(
                              email, username, password1);
                          if (!validation.success) {
                            switch (validation.type) {
                              case "invalidUsernameInput":
                                setState(() {
                                  _validated = true;
                                  _validationMessage =
                                      "* Campo de usuário inválido";
                                });
                                break;
                              case "invalidEmailInput":
                                setState(() {
                                  _validated = true;
                                  _validationMessage =
                                      "* Formato de e-mail inválido";
                                });
                                break;
                              case "invalidPasswordInput":
                                if (validation.description == "tooShort") {
                                  setState(() {
                                    _validationMessage = "* Senha muito curta";
                                    _validated = true;
                                  });
                                } else {
                                  setState(() {
                                    _validationMessage = "* Senha inválida";
                                    _validated = true;
                                  });
                                }
                                break;
                              case "conflictedUser":
                                setState(() {
                                  _validated = true;
                                  _validationMessage =
                                      "* Já existe um usuário com este nome de usuário";
                                });
                                break;
                              case "conflictedEmail":
                                setState(() {
                                  _validated = true;
                                  _validationMessage =
                                      "* Já existe um usuário com este e-mail";
                                });
                                break;
                              case "errorOnEmailValidation":
                                setState(() {
                                  _validated = true;
                                  _validationMessage =
                                      "* Erro na verificação de e-mail";
                                });
                                break;
                              default:
                                _validated = true;
                                _validationMessage =
                                    "* Erro de validação não identificado";
                                break;
                            }
                          } else {
                            const String redirectTitle =
                                "Conta criada com sucesso";
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RedirectScreen(
                                  title: redirectTitle,
                                ),
                              ),
                            );
                          }
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        minimumSize: const Size(176, 36),
                        backgroundColor: ThemeColors.primary),
                    child: Text(
                      'Cadastrar',
                      style: TextStyle(
                          color: ThemeColors.background, fontSize: 19),
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
