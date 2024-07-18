import 'package:appsqflite/pages/user/user_login.dart';
import 'package:appsqflite/src/shared/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RedirectScreen extends StatefulWidget {
  final String title;

  const RedirectScreen({super.key, required this.title});

  @override
  State<RedirectScreen> createState() => _RedirectScreenState();
}

class _RedirectScreenState extends State<RedirectScreen> {
  String get _title => widget.title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 80),
        scrollDirection: Axis.vertical,
        child: Center(
          child: SizedBox(
            width: 320,
            height: 680,
            child: Column(
              children: <Widget>[
                // Título
                Text(
                  _title,
                  style: GoogleFonts.leagueSpartan(
                    color: ThemeColors.secondaryLight,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7.25), // Padding
                // Horizontal Line
                Container(
                  height: 1,
                  width: 300,
                  color: ThemeColors.secondarySubtle,
                ),
                const SizedBox(height: 16), // Padding
                Text(
                  "Clique em continuar para ir para tela de login",
                  style: GoogleFonts.roboto(
                    color: ThemeColors.secondarySubtle,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 28), // Padding
                ElevatedButton(
                  // Button: Redirect to LoginForm
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserLogin()));
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      minimumSize: const Size(326, 36),
                      backgroundColor: ThemeColors.primaryLightDark),
                  child: Text(
                    'Continuar',
                    style: GoogleFonts.leagueSpartan(
                      color: ThemeColors.background,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
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
