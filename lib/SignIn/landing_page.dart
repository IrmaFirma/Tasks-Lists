import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/SignIn/welcomepage.dart';
import 'package:todo_app/home/home_page.dart';
import 'package:todo_app/services/database.dart';

class LandingPageWidget extends StatelessWidget {
  const LandingPageWidget({Key key, @required this.userSnapshot}) : super(key: key);
  final AsyncSnapshot<User> userSnapshot;

  @override
  Widget build(BuildContext context) {
    if (userSnapshot.connectionState == ConnectionState.active) {
      return userSnapshot.hasData ? Provider<Database>(create: (_) => FirestoreDatabase(uid: userSnapshot.data.uid), child: HomePage()) : WelcomePageBuilder();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}