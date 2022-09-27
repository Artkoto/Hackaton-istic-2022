import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/pages/register_page.dart';
import 'package:hackaton_obsidian/services/auth_manager.dart';

/// Entrypoint example for various sign-in flows with Firebase.
class LoginPage extends StatefulWidget {

  LoginPage({Key? key}) : super(key: key);

  /// The page title.
  final String title = 'Connexion';

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  User? user;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) => setState(() => this.user = user),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(
        pagename: '',
      ),
      appBar: CustomAppBar(widget.title),
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: const <Widget>[
              _EmailPasswordForm(),
             // const _EmailLinkSignInSection(),
             //  _AnonymouslySignInSection(),
            //  const _PhoneSignInSection(),
            //  const _OtherProvidersSignInSection(),
            ],
          );
        },
      ),
    );
  }


}


class _EmailPasswordForm extends StatefulWidget {
  const _EmailPasswordForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'Connexion',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (String? value) {
                  if (value!.isEmpty) return 'Please enter some text';
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (String? value) {
                  if (value!.isEmpty) return 'Please enter some text';
                  return null;
                },
                obscureText: true,
              ),
              Container(
                padding: const EdgeInsets.only(top: 16),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  backgroundColor: Colors.black,
                  icon: Icons.mail,
                  text: 'Connexion',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await signInWithEmailAndPassword(context,_emailController.text, _passwordController.text
                      );
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                  icon: Icons.person_add,
                  backgroundColor: Colors.black26,
                  text: 'Inscription',
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage()),), // redirection sur register_page
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}
