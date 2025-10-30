import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const CreateUserScreen(),
    );
  }
}

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  bool _userCreated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Center(
          child: Text(
            _userCreated
                ? "Bonjour \n${FirebaseAuth.instance.currentUser!.email}"
                : "Et si on créait un utilisateur ?",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
              child: const Text("Se déconnecter"),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                setState(() {
                  _userCreated = false;
                });
              }),
          const SizedBox(width: 10),
          ElevatedButton(
            child: const Text('Créer un utilisateur'),
            onPressed: ()  {
              try {
                  FirebaseAuth.instance
                    .createUserWithEmailAndPassword(
                        email: "${Random().nextInt(100000)}@gmail.com",
                        password: "1234567890")
                    .then((value) {
                  setState(() {
                    _userCreated = true;
                  });
                });

              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  showCloseIcon: true,
                  duration: const Duration(seconds: 10),
                  content: Text(e.message!),
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}
