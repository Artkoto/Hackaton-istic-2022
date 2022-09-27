
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/user.dart';
import 'package:hackaton_obsidian/services/user_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import 'error_page.dart';
import 'loading_page.dart';

class ArtistPage extends StatefulWidget {
  Artist artist;

  ArtistPage(this.artist ,{Key? key}) : super(key: key);

  @override
  _ArtistPageState createState() => _ArtistPageState();

}
class _ArtistPageState extends State<ArtistPage>{
  bool selec = true;
  Future<AppUser> user = getUserSettings();
  IconData heart_full = Icons.favorite;
  IconData heart_empty = Icons.favorite_outlined;


  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AppUser userVar = AppUser("", "", [], "", []);
  IconData icon = Icons.favorite;



  Icon _getIconFav(AppUser user) {
    if (user.fav.contains(widget.artist.id) == true) {
      selec = true;
      return const Icon(Icons.favorite, color: Colors.red, size: 50,);
    } else {
      selec = false;
      return const Icon(Icons.favorite_outline, color: Colors.red, size: 50);
    }
  }

  AppUser _modifyUserFav(bool selected, AppUser user) {
    if (selected == true) {
      user.fav.add(widget.artist.id);
      updateCurrentUserFavorites(user);
    }
    else {
      user.fav.remove(widget.artist.id);
      updateCurrentUserFavorites(user);
    }
    return user;
  }

 AppUser _modifyFav(AppUser user){
   bool selected = user.fav.contains(widget.artist.id);
   selected = !selected;
   return _modifyUserFav(selected,user);
 }

  Widget _buildContent(AppUser user) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildAvatar(),
        user == null ? _buildInfo(AppUser("","",[],"",[])) : _buildInfo(user),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 110.0,
      height: 110.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white30),
      ),
      margin: const EdgeInsets.only(top: 32.0, left: 16.0),
      padding: const EdgeInsets.all(3.0),
      child: ClipOval(
        child: widget.artist.thumbnail_url == ""
            ? Image.asset(PICTURE_NOT_FOUND, fit: BoxFit.cover)
            : Image.network(widget.artist.thumbnail_url, fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildInfo(AppUser user) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.artist.name + "  " + widget.artist.getFlag(widget.artist.codeISO),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          Text(
            widget.artist.getDateFromTimeStamp(widget.artist.date1),
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.artist.salle1,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.85),
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: 225.0,
            height: 1.0,
          ),
          getMusicIcons(user),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Text(
            widget.artist.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentGuest(){
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.artist.name + "  " + widget.artist.getFlag(widget.artist.codeISO),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30.0,
            ),
          ),
          Text(
            widget.artist.getDateFromTimeStamp(widget.artist.date1),
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            widget.artist.salle1,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.85),
            margin: const EdgeInsets.symmetric(vertical: 16.0),
            width: 225.0,
            height: 1.0,
          ),
          getMusicIconsGuest(),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Text(
            widget.artist.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        extendBodyBehindAppBar: false,
        drawer: NavDrawer(
          pagename: 'Artistes',
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(
            widget.artist.name ,
            style: TextStyle(color: Colors.white),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: FutureBuilder<AppUser>(
          future: user,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingPage();
            } else if (snapshot.hasError) {
              return const ErrorPage();
            } else {
              AppUser user = snapshot.data ?? AppUser("", "", [], "", []);
              return Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  widget.artist.thumbnail_url == ""
                      ? Image.asset(PICTURE_NOT_FOUND, fit: BoxFit.cover)
                      : Image.network(widget.artist.thumbnail_url, fit: BoxFit.cover),
                  BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: (user != AppUser("", "", [], "", [])? _buildContent(user) : _buildContentGuest()),
                    ),
                  ),
                ],
              );
            }
          },
        )
    );
  }



  getMusicIcons(AppUser user) {
    var l = <Widget>[];
    if (!kIsWeb) {
      if (widget.artist.spotify != "") {
        l.add(Row(children: [
          GestureDetector(
              onTap: () => _launchUrl(widget.artist.spotify, "spotify"),
              child: Image.asset(
                'images/icone_spoti.png',
                height: 50,
                width: 50,
              ))
        ],),
        );
      }
      if (widget.artist.deezer != "") {
        l.add(
          Row(children: [
            GestureDetector(
                onTap: () => _launchUrl(widget.artist.deezer, "deezer"),
                child: Image.asset(
                  'images/icone_deezer.png',
                  height: 50,
                  width: 50,
                ))
          ]),
        );
      }

      if (user.status == "user") {
        l.add(
          Row(children: [
            GestureDetector(
              child: _getIconFav(user),
              onTap: (){
                setState(() {
                  AppUser newUser = _modifyFav(user);
                  user = newUser;
                });
              }
            )])
        );
      }
      return Container(
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: l)
      );
    }
    else {
      if (widget.artist.spotify != "") {
        l.add(Row(children: [
          GestureDetector(
              onTap: () => _launchUrl(widget.artist.spotify, "spotify"),
              child: Image.asset(
                'images/icone_spoti.png',
                height: 50,
                width: 50,
              ))
        ],),
        );
      }
      if (widget.artist.deezer != "") {
        l.add(
          Row(children: [
            GestureDetector(
                onTap: () => _launchUrl(widget.artist.deezer, "deezer"),
                child: Image.asset(
                  'images/icone_deezer.png',
                  height: 50,
                  width: 50,
                ))
          ]),
        );
      }
      return Container(
          child:
          Row(mainAxisAlignment: MainAxisAlignment.start, children: l)
      );
    }
  }

  getMusicIconsGuest(){
    var l = <Widget>[];
    if (!kIsWeb) {
      if (widget.artist.spotify != "") {
        l.add(Row(children: [
          GestureDetector(
              onTap: () => _launchUrl(widget.artist.spotify, "spotify"),
              child: Image.asset(
                'images/icone_spoti.png',
                height: 50,
                width: 50,
              ))
        ],),
        );
      }
      if (widget.artist.deezer != "") {
        l.add(
          Row(children: [
            GestureDetector(
                onTap: () => _launchUrl(widget.artist.deezer, "deezer"),
                child: Image.asset(
                  'images/icone_deezer.png',
                  height: 50,
                  width: 50,
                ))
          ]),
        );
      }
      return Container(
          child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: l)
      );
    }
    else {
      if (widget.artist.spotify != "") {
        l.add(Row(children: [
          GestureDetector(
              onTap: () => _launchUrl(widget.artist.spotify, "spotify"),
              child: Image.asset(
                'images/icone_spoti.png',
                height: 50,
                width: 50,
              ))
        ],),
        );
      }
      if (widget.artist.deezer != "") {
        l.add(
          Row(children: [
            GestureDetector(
                onTap: () => _launchUrl(widget.artist.deezer, "deezer"),
                child: Image.asset(
                  'images/icone_deezer.png',
                  height: 50,
                  width: 50,
                ))
          ]),
        );
      }
      return Container(
          child:
          Row(mainAxisAlignment: MainAxisAlignment.start, children: l)
      );
    }
  }

  _launchUrl(String url, String provider) async {
    var res;
    var uri;
    var string;
    if (provider == "spotify") {
      res = url.split(":");
      string = "http://open.spotify.com/" + res[1] + "/" + res[2];
      var uri = Uri.encodeFull(string);
      await launch(uri);
    } else if (provider == "deezer")
      string = "http://deezer.com/fr/album/" + url;
    uri = Uri.encodeFull(string);
    await launch(uri);
  }




}