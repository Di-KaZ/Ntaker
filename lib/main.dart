import 'package:flutter/material.dart';
import 'package:n_taker/routes/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const NTaker());
}

class NTaker extends StatelessWidget {
  const NTaker({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'NTaker',
        color: Colors.white,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const Home());
  }
}
