import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/user.dart';
import 'package:hackaton_obsidian/services/user_services.dart';

/// Use this method to get filtered data (isEqualTo)
Future<List<Artist>> getArtistsFromFilter(String filterTag, var filterValue) async {
  List<Artist> localList = [];
  await FirebaseFirestore.instance
      .collection('data')
      .where(filterTag, isEqualTo: filterValue)
      .get()
      .then((docSnapshot) {
    for (var i = 0; i <= docSnapshot.docs.length - 1; i++) {
      String id = docSnapshot.docs[i].id;
      String annee = docSnapshot.docs[i]["annee"].toString();
      String name = docSnapshot.docs[i]["artistes"].toString();
      String thumbnail_url = docSnapshot.docs[i]["thumbnail_url"].toString();
      String date1 = docSnapshot.docs[i]["1ere_date_timestamp"].toString();
      String salle1 = docSnapshot.docs[i]["1ere_salle"].toString();
      String spotify = docSnapshot.docs[i]["spotify"].toString();
      String deezer = docSnapshot.docs[i]["deezer"].toString();
      String codeISO = docSnapshot.docs[i]["cou_iso3_code"].toString();
      String description = docSnapshot.docs[i]["description"].toString();
      localList.add(Artist(id, name, annee, thumbnail_url, date1, salle1,spotify,deezer, codeISO, description));
    }
  });
  return localList;
}

Future<List<Artist>> getAllArtists() async {
  List<Artist> localList = [];
  await FirebaseFirestore.instance
      .collection('data')
      .get()
      .then((docSnapshot) {
    for (var i = 0; i <= docSnapshot.docs.length - 1; i++) {
      String id = docSnapshot.docs[i].id;
      String annee = docSnapshot.docs[i]["annee"].toString();
      String name = docSnapshot.docs[i]["artistes"].toString();
      String thumbnail_url = docSnapshot.docs[i]["thumbnail_url"].toString();
      String date1 = docSnapshot.docs[i]["1ere_date_timestamp"].toString();
      String salle1 = docSnapshot.docs[i]["1ere_salle"].toString();
      String spotify = docSnapshot.docs[i]["spotify"].toString();
      String deezer = docSnapshot.docs[i]["deezer"].toString();
      String codeISO = docSnapshot.docs[i]["cou_iso3_code"].toString();
      String description = docSnapshot.docs[i]["description"].toString();
      localList.add(Artist(id, name, annee, thumbnail_url, date1, salle1,spotify,deezer, codeISO, description));
    }
  });
  return localList;
}
/// WARNING : Risky method, check that the request is possible in the database
Future<List<Artist>> getRandomArtists(int amount, bool withThumbnailUrl) async{
  List<Artist> randomArtists = [];

  await getAllArtists().then((allArtistsList) async{

    // if there if there are not enough artists
    if (allArtistsList.length < amount){
      print("WARNING : There are not enough artists in the database to meet the criteria");
      return allArtistsList;
    }

    // If there is less Artists with thumbnail_url than asked
    else if (withThumbnailUrl && allArtistsList.where((a) => a.thumbnail_url != "").length < amount){
      print("WARNING : There are not less Artists with thumbnail_url than asked");
      allArtistsList.removeWhere((a) => a.thumbnail_url == "");
      return allArtistsList;
    }
    // If all criteria are met
    else {
      // Randomize list order
      allArtistsList = allArtistsList..shuffle();

      // Remove artists with thumbnail_url == ""
      if (withThumbnailUrl == true) {
        allArtistsList.removeWhere((a) => a.thumbnail_url == "");
      }

      //
      for (Artist artist in allArtistsList) {
        if (randomArtists.length == amount) {
          break;
        }
        else {
          randomArtists.add(artist);
        }
      }
    }
  });
  return randomArtists;
}


Future<List<Artist>> getArtistsByPlaceFromUserSettings() async {

  AppUser userSettings = await getUserSettings();

  List<Artist> localList = [];


  if(userSettings.status == "admin"){
    return await getAllArtists();
  }
  else if(userSettings.status == "manager"){
    for(String place in userSettings.rooms){
      await FirebaseFirestore.instance
          .collection('data')
          .where("1ere_salle", isEqualTo: place)
          .get()
          .then((docSnapshot) {
        for (var i = 0; i <= docSnapshot.docs.length - 1; i++) {
          String id = docSnapshot.docs[i].id;
          String annee = docSnapshot.docs[i]["annee"].toString();
          String name = docSnapshot.docs[i]["artistes"].toString();
          String thumbnail_url = docSnapshot.docs[i]["thumbnail_url"].toString();
          String date1 = docSnapshot.docs[i]["1ere_date_timestamp"].toString();
          String salle1 = docSnapshot.docs[i]["1ere_salle"].toString();
          String spotify = docSnapshot.docs[i]["spotify"].toString();
          String deezer = docSnapshot.docs[i]["deezer"].toString();
          String codeISO = docSnapshot.docs[i]["cou_iso3_code"].toString();
          String description = docSnapshot.docs[i]["description"].toString();

          localList.add(Artist(id, name, annee, thumbnail_url, date1, salle1,spotify,deezer,codeISO,description));
        }
      });
    }
  }
  return localList;
}

Future<bool> updateArtist(Artist artist) async{
  Map<String, Object> artistData = {};
  artistData["artistes"]=artist.name;
  artistData["annee"]=artist.year;
  artistData["thumbnail_url"]=artist.thumbnail_url;
  artistData["1ere_date"]=artist.date1;
  artistData["1ere_salle"]=artist.salle1;
  artistData["spotify"]=artist.spotify;
  artistData["deezer"]=artist.spotify;
  artistData["cou_iso3_code"]=artist.codeISO;
  artistData["description"]=artist.description;
  bool result = false;
  await FirebaseFirestore.instance.collection("data").doc(artist.id).update(artistData).then((docSnapshot) {
    result = true;
  }).catchError((docSnapshot) {
    result =  false;
  });
  return result;
}

Future<bool> deleteArtist(Artist artist) async{
  bool result = false;
  await FirebaseFirestore.instance.collection("data").doc(artist.id).delete().then((docSnapshot) {
    result = true;
  }).catchError((docSnapshot) {
    result =  false;
  });
  return result;
}


Future<bool> addArtist(Artist artist) async{
  bool tmpResult = false;
  Map<String, Object> artistData = {};
  artistData["artistes"]=artist.name;
  artistData["annee"]=artist.year;
  artistData["thumbnail_url"]=artist.thumbnail_url;
  artistData["1ere_date_timestamp"]=artist.date1;
  artistData["1ere_salle"]=artist.salle1;
  artistData["spotify"]=artist.spotify;
  artistData["deezer"]=artist.deezer;
  artistData["cou_iso3_code"]=artist.codeISO;
  artistData["description"]=artist.description;
  await FirebaseFirestore.instance.collection("data").doc().set(artistData).then((docSnapshot) {
    tmpResult = true;
  }).catchError((docSnapshot) {
    tmpResult = false;
  });
  return tmpResult;
}
Future<Artist> getArtistsById(artistId) async {
  Artist artist = Artist("", "", "", "", "", "","","","","");
  await FirebaseFirestore.instance
      .collection('data')
      .doc(artistId)
      .get()
      .then((docSnapshot) {
    String id = docSnapshot.id;
    String annee = docSnapshot.get("annee");
    String name = docSnapshot.get("artistes");
    String thumbnail_url = docSnapshot.get("thumbnail_url");
    String date1 = docSnapshot.get("1ere_date_timestamp");
    String salle1 = docSnapshot.get("1ere_salle");
    String spotify = docSnapshot.get("spotify");
    String deezer = docSnapshot.get("deezer");
    String codeISO = docSnapshot.get("cou_iso3_code");
    String description = docSnapshot.get("description");
    return Artist(id, name, annee, thumbnail_url, date1, salle1,spotify,deezer,codeISO, description);
  }
  );
  return artist;
}



Future<List<Artist>> getUserFavoriteArtists(userSettings) async {
  List<Artist> localList = [];
  var userFavoriteIds = userSettings.fav;
  for(String id in userFavoriteIds){
    final Artist a = await getArtistsById(id);
    localList.add(a);
  }
  return localList;
}

