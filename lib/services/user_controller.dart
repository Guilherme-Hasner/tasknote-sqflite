// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:appsqflite/models/user.dart';
import 'package:appsqflite/services/database.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Result {
  final bool success;
  final String? type;
  final String? description;

  const Result({required this.success, this.type, this.description});
}

class EmailController {
  static Result validate(String email) {
    if (EmailValidator.validate(email)) return const Result(success: true);
    return const Result(success: false, type: "invalidEmailInput");
  }

  static Future<Result> sendEmail(
      String email, String subject, String body) async {
    const String sender = 'responsesender.ghti@gmail.com';
    const String password = 'CEET@gui42';

    final smtpServer = gmail(sender, password);

    final message = Message()
      ..from = const Address(sender, 'Tasks - Experimental App')
      ..recipients = [email]
      ..subject = subject
      ..text = body;

    bool emailSent = true;
    String errorType = "";
    String errorList = "";

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      String errorResponse =
          'The following errors were found while attempting to send the email:';
      for (int i = 0; i < e.problems.length; i++) {
        errorResponse += "\n" + "${(i + 1)} - " + e.problems[i].msg;
      }
      emailSent = false;
      errorType = e.message;
      errorList = errorResponse;
    }
    return Result(success: emailSent, type: errorType, description: errorList);
  }
}

class UserController {
  static Result validateUsername(String? username) {
    String failureMessage = "invalidUsernameInput";

    if (username == null || username == "") {
      String falureDescription = "empty";
      return Result(
          success: false, type: failureMessage, description: falureDescription);
    }

    RegExp validChars = RegExp(r"[a-zA-Z0-9]");
    String temp = username.replaceAll(validChars, '');
    if (temp != "") {
      String falureDescription = "invalidChars";
      return Result(
          success: false, type: failureMessage, description: falureDescription);
    }

    if (username.length < 5) {
      String falureDescription = "tooShort";
      return Result(
          success: false, type: failureMessage, description: falureDescription);
    }

    return const Result(success: true);
  }

  static Result validatePassword(String? password) {
    String failureMessage = "invalidPasswordInput";

    if (password == null || password == "") {
      String falureDescription = "empty";
      return Result(
          success: false, type: failureMessage, description: falureDescription);
    }

    RegExp validChars = RegExp(r"[a-zA-Z0-9!@#$%^&*()_+=\-{}|:;'`~<>,.?]+");
    String temp = password.replaceAll(validChars, '');
    if (temp != "") {
      String falureDescription = "invalidChars";
      return Result(
          success: false, type: failureMessage, description: falureDescription);
    }

    if (password.length < 5) {
      String falureDescription = "tooShort";
      return Result(
          success: false, type: failureMessage, description: falureDescription);
    }

    return const Result(success: true);
  }

  static Future<Result> insert(
      String email, String username, String password) async {
    Result result;

    result = validateUsername(username);
    if (!result.success) return result;

    result = EmailController.validate(email);
    if (!result.success) return result;

    result = validatePassword(password);
    if (!result.success) return result;

    // Verifica se já existe um usuário com esse username
    bool existingUser = await DatabaseHelper.checkDbforUser(username);
    if (existingUser) {
      return const Result(success: false, type: 'conflictedUser');
    }

    // Verifica se já existe um usuário com este email
    bool emailInDb = await DatabaseHelper.checkDbforEmail(email);
    if (emailInDb) {
      return const Result(success: false, type: 'conflictedEmail');
    } else {
      if (!EmailValidator.validate(email)) {
        return const Result(success: false, type: "invalidEmailInput");
      }
      /*
      // Verifica se o email existe e envia um email de confirmação caso exista
      const String emailSubject = "Tasks - Conta criada com sucesso";
      String emailBody =
          "Sua conta (Nome de usuário: $username) foi criada com sucesso!";

      result = await EmailController.sendEmail(email, emailSubject, emailBody);
      if (!result.success) {
        return Result(
            success: false,
            type: "errorOnEmailValidation",
            description: result.type);
      }
      */
    }

    final User user = User(email: email, user: username, password: password);
    DatabaseHelper.insertUser(user);
    return const Result(success: true);
  }

  static Future<Result> sendPasswordChangeRequest(String email) async {
    Result result;

    result = EmailController.validate(email);
    if (!result.success) return result;

    // Verifica se existe um usuário com este email
    bool emailInDb = await DatabaseHelper.checkDbforEmail(email);
    if (!emailInDb) {
      return const Result(success: false, type: 'emailNotRegistered');
    } else {
      String token = await DatabaseHelper.generateToken(email);
      const String emailSubject = "Tasks - Solicitação de Alteração de Senha";
      String emailBody =
          "O usuário deste e-mail recebeu uma solicitação de alteração de senha.\n" +
              "Para alterar a sua senha use o seguinte token dentre os próximos 30 minutos:\n$token\n\n" +
              "Caso você não tenha solicitado uma alteração de senha por favor desconsidere.";
      result = await EmailController.sendEmail(email, emailSubject, emailBody);
      if (!result.success) {
        return Result(
            success: false,
            type: "failOnEmailSendRequest",
            description: result.type);
      }
    }
    return const Result(success: true, type: "passwordChangeRequestEmailSent");
  }

  static Future<int> getUserFromEmail(String? email) async {
    bool result = false;
    if (email != null) {
      result = await DatabaseHelper.checkDbforEmail(email);
    }
    if (result) {
      int? id = await DatabaseHelper.selectUserByEmail(email!);
      return id!;
    }
    return -1;
  }

  static Future<Result> login(String username, String password) async {
    if (username == "") {
      return const Result(
          success: false, type: 'emptyFields', description: 'username');
    }
    if (password == "") {
      return const Result(
          success: false, type: 'emptyFields', description: 'password');
    }
    if (await DatabaseHelper.checkDbforUser(username)) {
      User user = await DatabaseHelper.selectUserByUsername(username);

      if (password == user.password) {
        await DatabaseHelper.changeLoginState(user.id!);
        return Result(
            success: true, type: user.id.toString(), description: user.user);
      }
      return const Result(
          success: false,
          type: 'loginFailed',
          description: 'passwordIncorrect');
    } else {
      return const Result(
          success: false, type: 'loginFailed', description: 'userNotFound');
    }
  }
}
