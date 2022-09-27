import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/pages/add_artist_page.dart';
import 'package:hackaton_obsidian/pages/admin_page.dart';
import 'package:hackaton_obsidian/pages/artists_page.dart';
import 'package:hackaton_obsidian/pages/favourites_page.dart';
import 'package:hackaton_obsidian/pages/home_page.dart';
import 'package:hackaton_obsidian/pages/lineup_page.dart';
import 'package:hackaton_obsidian/pages/loading_page.dart';
import 'package:hackaton_obsidian/pages/manager_page.dart';
import 'package:hackaton_obsidian/pages/posts_page.dart';
import 'package:hackaton_obsidian/services/user.dart';
import 'package:hackaton_obsidian/services/user_services.dart';

class NavDrawer extends StatelessWidget {
  final String pagename;

  NavDrawer({Key? key, required this.pagename}) : super(key: key);

  Color pageNameColor(pageName) {
    if (pageName == pagename) {
      return CURR_PAGE_COLOR;
    } else {
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [
      const DrawerHeader(
        child: Text(''),
        decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                fit: BoxFit.fitWidth, image: AssetImage(TRANS_COVER_IMAGE))),
      ),
      ListTile(
        tileColor: Colors.black,
        leading: Icon(Icons.home, color: pageNameColor('Accueil')),
        title:
        Text('Accueil', style: TextStyle(color: pageNameColor('Accueil'))),
        onTap: () => {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) =>  HomePage()),
                (Route<dynamic> route) => false,
          )
        },
      ),
      ListTile(
          tileColor: Colors.black,
          leading: Icon(Icons.music_note, color: pageNameColor('Artistes')),
          title: Text('Artistes',
              style: TextStyle(color: pageNameColor('Artistes'))),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ArtistsPage()),
            )
          }),
      ListTile(
          tileColor: Colors.black,
          leading: Icon(Icons.calendar_today_rounded,
              color: pageNameColor('Programmation')),
          title: Text('Programmation',
              style: TextStyle(color: pageNameColor('Programmation'))),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LineupPage()),
            )
          }),
      ListTile(
          tileColor: Colors.black,
          leading: Icon(Icons.notifications, color: pageNameColor('Annonces')),
          title: Text('Annonces',
              style: TextStyle(color: pageNameColor('Annonces'))),
          onTap: () => {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostsPage()),
            )
          }),
    ];

    return Drawer(
        child: Container(
            color: Colors.black,
            child: FutureBuilder<AppUser>(
                future: getUserSettings(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LoadingPage();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    AppUser userSettings =
                        snapshot.data ?? AppUser("", "", [], "", []);

                    if (userSettings.status == "user") {
                      widgets.add(ListTile(
                          tileColor: Colors.black,
                          leading: Icon(Icons.favorite,
                              color: pageNameColor('Favoris')),
                          title: Text('Favoris', style: TextStyle(color: pageNameColor('Favoris'))),
                          onTap: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FavouritesPage()),
                            )
                          }));
                    } else {
                      if (userSettings.status == "manager" || userSettings.status == "admin") {
                        widgets.add(const Divider(
                          height: 5,
                          thickness: 1,
                          indent: 10,
                          endIndent: 50,
                          color: Colors.white,));

                        widgets.add(ListTile(
                          tileColor: Colors.black,
                          leading: Icon(Icons.add, color: pageNameColor('Ajouter')),
                          title: Text('Ajouter', style: TextStyle(color: pageNameColor('Ajouter'))),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddArtistPage(userSettings)))
                          },
                        ));

                        widgets.add(ListTile(
                          tileColor: Colors.black,
                          leading: Icon(Icons.settings, color: pageNameColor('Management')),
                          title: Text('Management', style: TextStyle(color: pageNameColor('Management'))),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ManagerPage()))
                          },
                        ));

                      } if (userSettings.status == "admin") {
                        widgets.add(ListTile(
                          tileColor: Colors.black,
                          leading: Icon(Icons.add_moderator_outlined, color: pageNameColor('Administration')),
                          title: Text('Administration', style: TextStyle(color: pageNameColor('Administration'))),
                          onTap: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminPage()))
                          },
                        ));
                      }
                    }
                    return ListView(
                        padding: EdgeInsets.zero, children: widgets);
                  } else {
                    return ListView(
                        padding: EdgeInsets.zero, children: widgets);
                  }
                })));
  }
}
