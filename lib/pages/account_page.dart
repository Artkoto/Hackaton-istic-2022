import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_builder.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/pages/home_page.dart';

import 'package:hackaton_obsidian/services/auth_manager.dart';
import 'package:hackaton_obsidian/services/user.dart';
import 'package:hackaton_obsidian/services/user_services.dart';

String? _appusername ;
Future<AppUser>? _appuser ;
Future refresh() async{
   _appuser = getUserSettings();
}
void updateUsername(String newName){
  _appusername = newName;
}

class AccountPage extends StatefulWidget {
   const AccountPage({Key? key}) : super(key: key);

  final String title = 'Mon compte';

  @override
  State<StatefulWidget> createState() => _AccounPageState();
}

class _AccounPageState extends State<AccountPage> {
  User? user;

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen(
          (User? user) => setState(() => this.user = user),
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
            padding: const EdgeInsets.all(2),
            children: <Widget>[
              _UserInfoCard(user: user),
              const _UserNotifications(),
              const _UserPolitique(),
              _UserActionButtun(user: user),
            ],
          );
        },
      ),
    );
  }
}

//StatefulWidget /////////////////////
class _UserInfoCard extends StatefulWidget {
  const _UserInfoCard({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _UserInfoCardState createState() => _UserInfoCardState();
}

class _UserNotifications extends StatefulWidget {
  const _UserNotifications({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserPolitique extends StatefulWidget {
  const _UserPolitique({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _UserPolitiqueState createState() => _UserPolitiqueState();
}

class _UserActionButtun extends StatefulWidget {
  const _UserActionButtun({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _UserActionButtunState createState() => _UserActionButtunState();
}
/////////////////////////////////

// info user
class _UserInfoCardState extends State<_UserInfoCard> {
  @override
  void initState() {
      refresh();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // redirection sur register_page
        FutureBuilder<AppUser>(
            future : _appuser,
              builder: (context,snapshot) {
              _appusername = (snapshot.data!=null)?snapshot.data!.name : 'marco';
                return Text(
                  widget.user == null
                      ? 'Not signed in'
                      : 'Nom d\'utilisateur: $_appusername\n\n'
                          'Email: ${widget.user!.email}  \n\n'
                          'Id: ${widget.user!.uid}  \n\n'
                          // 'Créé le : ${widget.user!.metadata.creationTime.toString()}\n\n'
                          'Dernière connexion : ${widget.user!.metadata.lastSignInTime}\n',
                  style: const TextStyle(
                      fontSize: FONT_SIZE_TEXT, fontFamily: POLICE_TEXT
                  ),
                );
              }
        )],
        ),
    ),
      );

  }
}

//notifications
class _UserNotificationsState extends State<_UserNotifications> {
  bool isSwitched_push = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //notification
            Visibility(
              child: Container(
                  child: Column(
                children: [
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                            fontSize: FONT_SIZE_TEXT,
                            fontFamily: 'POLICE_TEXT'),
                      ),
                      /* IconButton(
                                 icon : Icon(
                                   Icons.filter_list_outlined,
                                   color:Colors.grey,
                                   size: 25,

                                 ),
                                onPressed: null,
                              ),*/
                      Switch(
                        value: isSwitched_push,
                        onChanged: (value) {
                          setState(() {
                            if(isSwitched_push){
                              FirebaseMessaging.instance.unsubscribeFromTopic("all");
                            }
                            else {
                              FirebaseMessaging.instance.subscribeToTopic("all");
                            }
                            isSwitched_push = value;
                            print(isSwitched_push);
                          });
                        },
                        activeTrackColor: Colors.black,
                        activeColor: Colors.yellow,
                      ),
                    ],
                  )),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}

//politique de confidentialité
class _UserPolitiqueState extends State<_UserPolitique> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Politique de confidentialité
            Visibility(
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Politique de confidentialité',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: FONT_SIZE_TEXT,
                            fontFamily: POLICE_TEXT),
                        recognizer: TapGestureRecognizer()
                          ..onTap= () => showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupPrivacyPolicy(context),
                              ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_drop_down_sharp,
                        color: Colors.black,
                        size: 25,
                      ),
                      //onPressed: null,
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            _buildPopupPrivacyPolicy(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//Boutons d'action
class _UserActionButtunState extends State<_UserActionButtun> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //control buttons
            Visibility(
              visible: widget.user != null,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //refresh icon
                    IconButton(
                      onPressed: () async{
                        refresh();

                      },
                      icon: const Icon(Icons.refresh),
                    ),

                    //snippet icon
                    IconButton(
                      onPressed: () async {await showDialog(
                        context: context,
                        builder: (context) =>
                            UpdateUserDialog(user: widget.user),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) =>  HomePage()),
                            (Route<dynamic> route) => false,
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) =>  const AccountPage()),
                            (Route<dynamic> route) => true,
                      );

                      },
                      icon: const Icon(Icons.text_snippet),
                    ),
                    //delete icon
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (context) =>
                            DeleteUserDialog(user: widget.user),
                      ),
                      icon: const Icon(Icons.delete_forever),
                    ),
                  ],
                ),
              ),
            ),

            //deconnection button
            Visibility(
              child: Container(
                padding: const EdgeInsets.only(top: 70),
                alignment: Alignment.center,
                child: SignInButtonBuilder(
                    fontSize: FONT_SIZE_TEXT,
                    //fontFamily : 'POLICE_TEXT',
                    backgroundColor: Colors.red,
                    icon: Icons.logout,
                    text: 'Se déconnecter',
                    onPressed: () async {
                      await signOut(context);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}

//pop up update profile name
class UpdateUserDialog extends StatefulWidget {
  const UpdateUserDialog({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _UpdateUserDialogState createState() => _UpdateUserDialogState();
}

//pop up update profile name
class DeleteUserDialog extends StatefulWidget {
  const DeleteUserDialog({Key? key, this.user}) : super(key: key);

  final User? user;

  @override
  _DeleteUserDialogState createState() => _DeleteUserDialogState();
}

class _UpdateUserDialogState extends State<UpdateUserDialog> {
  TextEditingController? _nameController;

  @override
  void initState() {
    _nameController = TextEditingController(text: _appusername);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Mettre à jour le profil'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: _nameController,
              autocorrect: false,
              decoration: const InputDecoration(labelText: 'nom'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (_nameController!.text.contains(RegExp(r'[!-/:-@[-`{-~]'))) {
              ScaffoldSnackbar.of(context)
                  .show('Les caractères spéciaux ne sont pas autorisés.');
              return;
            }
            if (_nameController!.text.length <= 2) {
              ScaffoldSnackbar.of(context)
                  .show('Le nom d\'utilisateur doit contenir au moins trois caractères.');
              return;
            }
            if (!_nameController!.text.contains(RegExp(r'[a-zA-Z]'))) {
              ScaffoldSnackbar.of(context).show(
                  'Le nom d\'utilisateur doit contenir au moins un caractère alphabétique');
              return;
            }
             updateName(_nameController!.text);
            setState(()  {
              updateUsername(_nameController!.text);
            });

            ScaffoldSnackbar.of(context).show(
                'Nom d\'utilisateur modifier avec succès');
            Navigator.of(context).pop();
          },
          child: const Text('Mettre à jour'),
        )
      ],
    );
  }
}

//pop up pour la suppresion d'utilisateur
class _DeleteUserDialogState extends State<DeleteUserDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer votre compte'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text(
              "Confirmez-vous la suppression de votre compte ?"),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Non'),
        ),
        TextButton(
          onPressed: () async {
            await deleteUser(context);
          },
          child: const Text('Oui'),
        )

      ],
    );
  }
}


// pop up Privacy_policy
Widget _buildPopupPrivacyPolicy(BuildContext context) {
  return AlertDialog(
    title: const Text('Politique de confidentialité'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
            "Depuis toujours, l’ATM (Association Trans Musicales) est très attentive à "
            "l’utilisation des données personnelles des publics de ses événements.\n\n "
            "L’application du nouveau Règlement Général sur la Protection des Données (RGPD), "
            "entré en vigueur le 25 mai 2018, nous donne l’occasion de vous informer sur"
            " l’utilisation des données personnelles que l’ATM est amenée à collecter.\n"
            "Les données collectées sont utilisées exclusivement pour"
            " permettre la gestion du contrôle d’accès"
            " et pour permettre la réalisation d’enquêtes sociologiques."),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Fermer',
        style : TextStyle( color : Colors.black)),
      ),
    ],
  );
}
