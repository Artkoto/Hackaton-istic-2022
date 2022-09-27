import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/artists_services.dart';
import 'artist_edition_page.dart';
import 'artist_remove_page.dart';
import 'error_page.dart';
import 'loading_page.dart';

///
/// Widget for displaying error page.
///

class ManagerPage extends StatefulWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  _ManagerListState createState() => _ManagerListState();
}

class _ManagerListState extends State<ManagerPage> {
  Future<List<Artist>> propList = getArtistsByPlaceFromUserSettings();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future refresh() async{
    setState(() {
      propList = getArtistsByPlaceFromUserSettings();
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(
          pagename: 'Management',
        ),
        appBar: CustomAppBar('Management'),
        body: Center(
            child: FutureBuilder<List<Artist>>(
                future: propList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const LoadingPage();
                  }
                  if (snapshot.hasError) {
                    return const ErrorPage();
                  }
                  List<Artist> artists = snapshot.data ?? [];
                  return ListView.builder(
                      itemCount: artists.length,
                      itemBuilder: (context, index) {
                        Artist artist = artists[index];
                        return GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistEditionPage(artist, refresh))),
                            child : Card(
                              child: Container(
                                height: 55,
                                color: Colors.white,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 15),
                                    ClipRRect(borderRadius: BorderRadius.circular(5.0), child: (artist.thumbnail_url == ""? Image.asset(PICTURE_NOT_FOUND): Image.network(artist.thumbnail_url))),
                                    const SizedBox(width: 15),
                                    Expanded(child: Text(artist.name),
                                    ),
                                    Container(
                                      width: 1,
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(width: 5),
                                    IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistEditionPage(artist, refresh)));
                                        setState(() {});
                                        }
                                    ),
                                    const SizedBox(width: 5),
                                    Container(
                                      width: 1,
                                      margin: const EdgeInsets.symmetric(vertical: 6),
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(width: 5),
                                    IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ArtistRemovePage(artist, refresh)));
                                        }
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                ),
                              ),
                            )
                        );

                      });
                })
        ));

  }
}
