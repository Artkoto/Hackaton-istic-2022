import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/pages/account_page.dart';
import 'package:hackaton_obsidian/pages/login_page.dart';
import 'package:hackaton_obsidian/services/auth_manager.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;
  final String pagetitle;

  CustomAppBar(
      this.pagetitle,
      {  Key? key,}) : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return AppBar(
      key: _scaffoldKey,
      backgroundColor: APP_BAR_COLOR,
      elevation: 0,
      leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.white,
            size: 25,
          ),
          onPressed: () {Scaffold.of(context).openDrawer();}
      ),
      actions: [
        PopupMenuButton(
            onSelected: (result) async {
              if (result == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => (getAuth().currentUser!=null)?const AccountPage():LoginPage() ),
                );
              }
              else if (result == 2) {
                await signOut(context);
              }

            },
            icon: const Icon(
              Icons.person_outlined,
              color: Colors.white,
              size: 25,
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ListTile(
                    leading : const Icon(Icons.login, color : Colors.black),
                    title : Text((getAuth().currentUser!=null)?"Mon compte":"Connexion")),
                value: 1,
              ),
              if(getAuth().currentUser!=null) const PopupMenuItem(
                child :
                ListTile(
                    leading : Icon(Icons.power_settings_new, color : Color(
                        0xffe31a1a)),
                    title : Text("Déconnexion")),
                value: 2,
              )
            ]
        )
      ],
      title: Text(pagetitle, style: TextStyle(color: Colors.white)),
    );
  }
}
