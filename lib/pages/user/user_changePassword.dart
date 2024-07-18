import 'package:appsqflite/pages/user/user_login.dart';
import 'package:appsqflite/pages/util/redirect_screen.dart';
import 'package:appsqflite/services/database.dart';
import 'package:appsqflite/services/user_controller.dart';
import 'package:appsqflite/src/shared/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserRedefinePassword extends StatefulWidget {
  final int userId;
  const UserRedefinePassword({super.key, required this.userId});

  @override
  State<UserRedefinePassword> createState() => _UserRedefinePasswordState();
}

class _UserRedefinePasswordState extends State<UserRedefinePassword> {
  int get _userId => widget.userId;

  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  bool _showPassword = false;

  // Mensagem de !Validação
  bool _validated = false;
  String _validationMessage = "* Mensagem de validação";
  Widget validationErrorMessage() {
    if (!_validated) {
      return const SizedBox(height: 28); // Padding
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
  static const double _buttonFontSize = 19;

  static const double _txtBoxHeight = 40;
  static const double _buttonHeight = 36;
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
                // Título
                Text(
                  'Redefinir senha',
                  style: GoogleFonts.leagueSpartan(
                    color: ThemeColors.secondarySubtle,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12), // Padding
                // Label: Senha
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Senha',
                    style: GoogleFonts.leagueSpartan(
                      color: ThemeColors.secondaryLight,
                      fontSize: _labelFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: _paddingLabel2TxtField), // Padding
                // TextField: Nova senha
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
                      hintText: 'Nova Senha',
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
                      color: ThemeColors.secondaryLight,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    // Button: Cancelar
                    ElevatedButton(
                      onPressed: () {
                        // Validations_Script
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const UserLogin()));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          minimumSize: const Size(56, _buttonHeight),
                          backgroundColor: ThemeColors.secondaryLight),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                            color: ThemeColors.background,
                            fontSize: _buttonFontSize),
                      ),
                    ),
                    // Button: Salvar Alterações
                    ElevatedButton(
                      onPressed: () {
                        Result validation;
                        if (_password1Controller.text == "" ||
                            _password2Controller.text == "") {
                          setState(() {
                            validation =
                                const Result(success: false, type: "empty");
                            _validated = true;
                            _validationMessage = "* Preencha todos os campos";
                          });
                          return;
                        }
                        _comparePasswordFields();
                        if (!_passwordFieldsMatch) {
                          setState(() {
                            validation = const Result(
                                success: false, type: "passwordsMismatch");
                            _validated = true;
                            _validationMessage =
                                "* As senhas inseridas são distintas";
                          });
                        } else {
                          validation = UserController.validatePassword(
                              _password1Controller.text);
                          if (!validation.success) {
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
                          } else {
                            DatabaseHelper.updatePassword(
                                _password1Controller.text, _userId);
                            const String redirectTitle =
                                "Senha alterada com sucesso";

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
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          minimumSize: const Size(120, _buttonHeight),
                          backgroundColor: ThemeColors.primary),
                      child: Text(
                        'Alterar senha',
                        style: TextStyle(
                            color: ThemeColors.background,
                            fontSize: _buttonFontSize),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
