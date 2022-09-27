import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseFirestore _store = FirebaseFirestore.instance;

class ScaffoldSnackbar {
  ScaffoldSnackbar(this._context);

  final BuildContext _context;

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

FirebaseAuth getAuth() {
  return _auth;
}
FirebaseFirestore getStore(){
  return _store;
}

/// Registration for firebase
/// str.replaceAll(RegExp(r'[a-zA-Z]'), '') ;
Future<void> register(
  BuildContext context,
  String registerUsername,
  String registerEmail,
  String registerpassword,
) async {
  if (registerUsername.contains(RegExp(r'[!-/:-@[-`{-~]'))) {
    ScaffoldSnackbar.of(context)
        .show('Les caractères spéciaux ne sont pas autorisés.');
    return;
  }
  if (registerUsername.length <= 2) {
    ScaffoldSnackbar.of(context)
        .show('Le nom d\'utilisateur doit contenir au moins trois caractères.');
    return;
  }
  if (!registerUsername.contains(RegExp(r'[a-zA-Z]'))) {
    ScaffoldSnackbar.of(context).show(
        'Le nom d\'utilisateur doit contenir au moins un caractère alphabétique');
    return;
  }
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: registerEmail, password: registerpassword);
    ScaffoldSnackbar.of(context).show('Utilisateur créé avec succès');

    Map<String, Object> data = {};
    data["fav"] = [];
    data["status"] = "user";
    data["name"] = registerUsername;
    data["rooms"] = [];

    /// User creation
    FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set(data);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    ); // redirection sur home_page
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'invalid-email':
        {
          ScaffoldSnackbar.of(context).show('Email invalide');
        }
        break;
      case 'weak-password':
        {
          ScaffoldSnackbar.of(context).show('Mot de passe pas assez sécurisé');
        }
        break;
      case 'email-already-in-use':
        {
          ScaffoldSnackbar.of(context).show('Compte déjà existant');
        }
        break;
      default:
        ScaffoldSnackbar.of(context).show('Impossible de créer le compte');
        break;
    }
  }
}

Future<void> signInWithEmailAndPassword(
    BuildContext context, String userEmail, String userPassword) async {
  try {
    final User user = (await _auth.signInWithEmailAndPassword(
            email: userEmail, password: userPassword))
        .user!;
    ScaffoldSnackbar.of(context).show('${user.email} connecté');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    ); // redirection sur home_page
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case 'user-not-found':
        {
          ScaffoldSnackbar.of(context).show('Email incorrect');
        }
        break;
      case 'wrong-password':
        {
          ScaffoldSnackbar.of(context).show('Mot de passe incorrect.');
        }
        break;
      default:
        ScaffoldSnackbar.of(context).show('Connexion impossible');
        break;
    }
  }
}

/// Sign ou method
Future<void> signOut(BuildContext context) async {
  try {
    await _auth.signOut();
    ScaffoldSnackbar.of(context).show('vous êtes déconnecté');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    ); // redirection sur home_page
  } on FirebaseAuthException catch (e) {
    ScaffoldSnackbar.of(context).show('Une erreur inattendue s\'est produit');
  }
}

/// delete methode
Future<void> deleteUser(BuildContext context) async {
  try {
    User? user = _auth.currentUser;
    String id = user!.uid;
    await user.delete();
    //supression du doc utilisateur
    FirebaseFirestore.instance
        .collection('users')
        .doc(id).delete();
    ScaffoldSnackbar.of(context).show('Compte supprimé avec succès');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    ); // redirection sur home_page
  } on FirebaseAuthException catch (e) {
    ScaffoldSnackbar.of(context).show('Une erreur inattendue s\'est produit');
  }
}