// ignore_for_file: use_build_context_synchronously

import 'package:appsqflite/pages/user/user_changePassword.dart';
import 'package:appsqflite/pages/user/user_login.dart';
import 'package:appsqflite/services/database.dart';
import 'package:appsqflite/services/user_controller.dart';
import 'package:appsqflite/src/shared/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class UserPasswordChangeRequest extends StatefulWidget {
  const UserPasswordChangeRequest({super.key});

  @override
  State<UserPasswordChangeRequest> createState() =>
      _UserPasswordChangeRequestState();
}

class _UserPasswordChangeRequestState extends State<UserPasswordChangeRequest> {
  final _emailController = TextEditingController();

  bool _initialPageState = true; // Estado 0 - Enviar e-mail
  bool _emailControllerEnabled = true;

  // Texto para Estado 1.1 - Inserir Token de Validação
  static const String _tokenInsertionLabel1 =
      "Insira abaixo o código de verificação enviado no seu e-mail.";
  // Texto para Estado 1.2 - Conferir e-mail e inserir Token de Validação
  static const String _tokenInsertionLabel2 =
      "Digite o e-mail que solicitou a recuperação acima e o código recebido abaixo.";
  String _tokenInsertionLabel =
      _tokenInsertionLabel1; // Texto do Estado 1 padrão: Texto para Estado 1.1

  Widget bottomPage() {
    // Estado 0 - Enviar e-mail
    if (_initialPageState) {
      return SizedBox(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              // Button: Enviar E-mail de Recuperação => Estado 1.1
              onPressed: () async {
                // Validations_Script
                String emailField = _emailController.text.replaceAll(" ", "");
                if (emailField == "") {
                  setState(() {
                    _validation = true;
                    _validationMessage =
                        "* Preencha o campo com o e-mail cadastrado";
                  });
                  return;
                }
                bool emailRegistered =
                    await DatabaseHelper.checkDbforEmail(_emailController.text);
                if (emailRegistered) {
                  setState(() {
                    _validation = false;
                    _emailControllerEnabled = false;
                    _initialPageState = false;
                  });
                } else {
                  setState(() {
                    _validation = true;
                    _validationMessage =
                        "* Não existe um usuário com este e-mail";
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  minimumSize: const Size(326, 34),
                  backgroundColor: ThemeColors.primaryLightDark),
              child: Text(
                'Enviar e-mail de recuperação',
                style: GoogleFonts.leagueSpartan(
                  color: ThemeColors.background,
                  fontSize: 19,
                ),
              ),
            ),
            const SizedBox(height: 16), // Padding
            // Label: Expandir para inserir token
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Já enviou um e-mail de recuperação?',
                style: GoogleFonts.leagueSpartan(
                  color: ThemeColors.secondarySubtle,
                  fontSize: 19,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
            // Expand: Inserir Token => Estado 1.2
            GestureDetector(
              onTap: () {
                setState(() {
                  _validation = false;
                  _tokenInsertionLabel = _tokenInsertionLabel2;
                  _initialPageState = false;
                });
              },
              child: Text(
                'Clique aqui para inserir o código de verificação',
                style: GoogleFonts.leagueSpartan(
                  color: Colors.blueGrey,
                  fontSize: 17,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0,
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Estado 1: Validação de Token

    final tokenField1 = TextEditingController();
    FocusNode fnTokenField1 = FocusNode();
    final tokenField2 = TextEditingController();
    FocusNode fnTokenField2 = FocusNode();
    final tokenField3 = TextEditingController();
    FocusNode fnTokenField3 = FocusNode();
    final tokenField4 = TextEditingController();
    FocusNode fnTokenField4 = FocusNode();

    // Layout constants
    const double tokenFieldWidth = 40;
    const double tokenFieldFontSize = 18;
    const double tokenFieldPadding = 20;

    return SizedBox(
      child: Column(
        children: <Widget>[
          // Texto para Estado 1.1/1.2
          Text(
            _tokenInsertionLabel,
            style: GoogleFonts.leagueSpartan(
              color: Colors.blueGrey,
              fontSize: 18,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 12), // Padding
          // Label: Token
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Código de verificação',
              style: GoogleFonts.leagueSpartan(
                color: ThemeColors.secondaryLight,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 14), // Padding
          SizedBox(
            width: 400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                // TokenField 1
                SizedBox(
                  width: tokenFieldWidth,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: tokenField1,
                    focusNode: fnTokenField1,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (value.toString() != "") {
                        fnTokenField2.requestFocus();
                      }
                    },
                    style: GoogleFonts.roboto(
                      fontSize: tokenFieldFontSize,
                      fontWeight: FontWeight.w300,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.secondarySubtle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: tokenFieldPadding), // Padding
                // TokenField 2
                SizedBox(
                  width: tokenFieldWidth,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: tokenField2,
                    focusNode: fnTokenField2,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (value.toString() != "") {
                        fnTokenField3.requestFocus();
                      }
                    },
                    style: GoogleFonts.roboto(
                      fontSize: tokenFieldFontSize,
                      fontWeight: FontWeight.w300,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.secondarySubtle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: tokenFieldPadding), // Padding
                // TokenField 3
                SizedBox(
                  width: tokenFieldWidth,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: tokenField3,
                    focusNode: fnTokenField3,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (value.toString() != "") {
                        fnTokenField4.requestFocus();
                      }
                    },
                    style: GoogleFonts.roboto(
                      fontSize: tokenFieldFontSize,
                      fontWeight: FontWeight.w300,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.secondarySubtle),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: tokenFieldPadding), // Padding
                // TokenField 4
                SizedBox(
                  width: tokenFieldWidth,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: tokenField4,
                    focusNode: fnTokenField4,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                    onChanged: (value) {
                      if (value.toString() != "") {
                        fnTokenField1.requestFocus();
                      }
                    },
                    style: GoogleFonts.roboto(
                      fontSize: tokenFieldFontSize,
                      fontWeight: FontWeight.w300,
                      color: ThemeColors.secondaryLight,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: ThemeColors.secondarySubtle),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28), // Padding
          // Button: Autenticar Código
          ElevatedButton(
            onPressed: () async {
              // Validations_Script
              int userId =
                  await UserController.getUserFromEmail(_emailController.text);
              if (userId != -1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserRedefinePassword(
                      userId: userId,
                    ),
                  ),
                );
              } else {
                setState(() {
                  _validation = true;
                  _validationMessage =
                      "* Não existe um usuário com este e-mail";
                });
              }
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
                minimumSize: const Size(326, 36),
                backgroundColor: ThemeColors.primaryMediumDark),
            child: Text(
              'Autenticar',
              style: GoogleFonts.leagueSpartan(
                color: ThemeColors.background,
                fontSize: 19,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mensagem de !Validação
  bool _validation = false;
  String _validationMessage = "* ";
  Widget validationErrorMessage() {
    if (!_validation) {
      return const SizedBox(height: 24); // Padding
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
                      // Voltar - ArrowBack
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
                    const SizedBox(width: 14), // Padding
                    // Título
                    Text(
                      'Recuperar Conta',
                      style: GoogleFonts.leagueSpartan(
                        color: ThemeColors.secondarySubtle,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12), // Padding
                // Label: E-mail
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'E-mail',
                    style: GoogleFonts.leagueSpartan(
                      color: ThemeColors.secondary,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 3), // Padding
                // TextField: E-mail
                SizedBox(
                  height: 40,
                  child: TextFormField(
                    textAlignVertical: const TextAlignVertical(y: 1),
                    controller: _emailController,
                    enabled: _emailControllerEnabled,
                    maxLength: 80,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
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
                validationErrorMessage(),
                bottomPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
