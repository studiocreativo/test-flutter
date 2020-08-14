import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_oauth/firebase_auth_oauth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<void> performLogin(String provider, List<String> scopes,
      Map<String, String> parameters) async {
    try {
      await FirebaseAuthOAuth().openSignInFlow(provider, scopes, parameters);
    } on PlatformException catch (error) {
      debugPrint("${error.code}: ${error.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Test - Miguelon'),
          ),
          body: StreamBuilder(
              initialData: null,
              stream: FirebaseAuth.instance.onAuthStateChanged,
              builder:
                  (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
                return Column(
                  children: [
                    Center(
                      child: Text(snapshot.data == null
                          ? "No Conectado"
                          : snapshot.data.displayName),
                    ),
                    if (snapshot.data == null) ...[
                      RaisedButton(
                        onPressed: () async {
                          await performLogin("microsoft.com", [], {});
                        },
                        child: Text("LogIn con Microsoft"),
                      ),
                    ],
                    if (snapshot.data != null)
                      RaisedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                        child: Text("Salir Sesión"),
                      )
                  ],
                );
              })),
    );
  }
}
