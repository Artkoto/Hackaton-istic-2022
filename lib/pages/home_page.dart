import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/artists_services.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'artist_page.dart';
import 'error_page.dart';
import 'loading_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget artistProfileDisplay(artist) {
    return Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                image: NetworkImage(artist.thumbnail_url),
              ),
            ),
            height: HOME_GRID_HEIGHT,
          ),
          Container(
            height: HOME_GRID_HEIGHT,
            decoration: BoxDecoration(
                color: Colors.white,
                gradient: LinearGradient(
                    begin: FractionalOffset.topCenter,
                    end: FractionalOffset.bottomCenter,
                    colors: [
                      Colors.grey.withOpacity(0.0),
                      Colors.black,
                    ],
                    stops: [0.0,1.0]
                )
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 0),
            height: HOME_GRID_HEIGHT,
            alignment: Alignment.bottomLeft,
            child: Text(
                artist.name,
                style: const TextStyle(
                    fontFamily: POLICE_TEXT,
                    fontWeight: HOME_GRID_FONT_WEIGHT,
                    fontSize: HOME_GRID_FONT_SIZE,
                    color: HOME_GRID_FONT_COLOR)
            ),
          )
        ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(
          pagename: 'Accueil',
        ),
        appBar: CustomAppBar('Accueil'),
        body: Container(
            margin: const EdgeInsets.only(top: 0),
            child: FutureBuilder<List<Artist>>(
                future: getRandomArtists(NB_ARTISTS_TO_LOAD, true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LoadingPage();
                  } else if (snapshot.hasError) {
                    return const ErrorPage();
                  } else {
                    List<Artist> artists = snapshot.data ?? [];
                    return ResponsiveGridList(
                        // WARNING : MAY CAUSE INFINITY ERROR
                        desiredItemWidth: 350.0,
                        minSpacing: 0,
                        children: artists.map((i) {
                          return GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ArtistPage(i)
                                )
                            ),
                            child: artistProfileDisplay(i)
                          );
                        }).toList());
                  }
                }
            )
        )
    );
  }
}
