import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/services/auth_manager.dart';

class RegisterPage extends StatefulWidget {
  /// The page title.
  final String title = 'Inscription';
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RegisterPageState() ;
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User? user;
    return Scaffold(
      drawer: NavDrawer(
        pagename: '',
      ),
      appBar: CustomAppBar(widget.title),
      body: Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Nom d\'utilisateur'),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Nom d\'utilisateur obligatoire !';
                    }
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Email obligatoire !';
                    }
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Mot de passe'),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Password obligatoire !';
                    }
                  },
                  obscureText: true,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: SignInButtonBuilder(
                    icon: Icons.person_add,
                    backgroundColor: Colors.black54,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await register(context,_usernameController.text,_emailController.text,_passwordController.text);
                      }
                    },
                    text: 'Register',
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(""),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

