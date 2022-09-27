
import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/pages/error_page.dart';
import 'package:hackaton_obsidian/pages/loading_page.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/user.dart';
import 'package:hackaton_obsidian/services/user_services.dart';

class FavouritesPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FavouritesPageState();
}

class FavouritesPageState extends State<FavouritesPage> {
  IconData fav = Icons.favorite;
  Future<List<Artist>> favorites = getUserFavorites();
  AppUser user = AppUser("", "", [], "", []);
  Future<AppUser> _getUser() async {
    user = await getUserSettings();
    return getUserSettings();
  }

  Future refresh() async{
    setState(() {
      favorites = getUserFavorites();
    });
  }
  @override
  Widget build(BuildContext context) {
    _getUser();
    return Scaffold(
        extendBodyBehindAppBar: false,
        drawer: NavDrawer(
          pagename: 'Favoris',
        ),
        appBar: CustomAppBar('Vos favoris'),
        body: FutureBuilder<List<Artist>>(
            future: favorites,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const LoadingPage();
              }
              if (snapshot.hasError) {
                return const ErrorPage();
              }
              List<Artist> l  = snapshot.data ?? [];

              return ListView.builder(
                  itemCount: l.length,
                  itemBuilder: (context, index) {
                    return Card(
                            child: ListTile(
                              // Access the fields as defined in FireStore
                              leading: (l[index].thumbnail_url == ""
                                  ? Image.asset(PICTURE_NOT_FOUND)
                                  : Image.network(l[index].thumbnail_url)),
                              title: Text(l[index].name),
                              subtitle: Text(l[index].year),
                              trailing: IconButton(
                                icon: Icon(fav),
                                onPressed: () {
                                  setState(() {
                                    fav = Icons.favorite_outlined;
                                    Artist a = l[index];
                                    user.fav.remove(a.id);
                                    updateCurrentUserFavorites(user);
                                    refresh();
                                  });
                                },
                              ),
                              )
                    );

                  });
            }));
  }
}
