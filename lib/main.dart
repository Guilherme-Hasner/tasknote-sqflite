import 'package:appsqflite/pages/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:appsqflite/src/shared/themes/theme.dart';
import 'package:appsqflite/src/shared/themes/util.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const AppTasksSqflite());
}

class AppTasksSqflite extends StatelessWidget {
  const AppTasksSqflite({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Retrieves the default theme for the platform
    // TextTheme textTheme = Theme.of(context).textTheme;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Poppins");

    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
      ],
      locale: const Locale.fromSubtags(countryCode: 'BR', languageCode: 'pt'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      home: const SplashScreen(),
    );
  }
}
