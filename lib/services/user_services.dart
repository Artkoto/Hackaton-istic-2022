import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:hackaton_obsidian/services/user.dart';
import 'artist.dart';

Future<AppUser> getUserSettings() async {
  AppUser user = AppUser("", "", [], "", []);
  var userId = FirebaseAuth.instance.currentUser;
  if (userId == null){
    return AppUser("", "", [], "", []);
  }
  else{
  await FirebaseFirestore.instance
      .collection('users').doc(userId.uid).get()
      .then((docSnapshot) {
    user.id = userId.uid;
    user.status = docSnapshot.get("status");
    user.fav = docSnapshot.get("fav");
    user.name = docSnapshot.get("name");
    user.rooms = docSnapshot.get("rooms");
  });
  return user;
  }
}

Future<List<Artist>> getUserFavorites() async {
  List<Artist> userFavs = [];

  await getUserSettings().then((AppUser userSnapshot) async {
      for (String artistId in userSnapshot.fav){
        await FirebaseFirestore.instance.collection('data').doc(artistId).get().then((artistSnapshot) async{
          String id = artistSnapshot.id;
          String annee = artistSnapshot.get("annee").toString();
          String name = artistSnapshot.get("artistes").toString();
          String thumbnailUrl = artistSnapshot.get("thumbnail_url").toString();
          String date1 = artistSnapshot.get("1ere_date_timestamp").toString();
          String salle1 = artistSnapshot.get("1ere_salle").toString();
          String spotify = artistSnapshot.get("spotify").toString();
          String deezer = artistSnapshot.get("deezer").toString();
          String codeISO = artistSnapshot.get("cou_iso3_code").toString();
          String description = artistSnapshot.get("description").toString();
          Artist a = Artist(id, name, annee, thumbnailUrl, date1, salle1,spotify,deezer,codeISO, description);
          userFavs.add(a);
        });
      }
  });
  return userFavs;
}



  // await FirebaseFirestore.instance.collection('users').doc(userId).get().then((userSnapshot) async {
  //   for (String artistId in userSnapshot.get("fav")){
  //     await FirebaseFirestore.instance.collection('data').doc(artistId).get().then((docSnapshot) {
  //       String id = docSnapshot.id;
  //       String annee = docSnapshot.get("annee").toString();
  //       String name = docSnapshot.get("artistes").toString();
  //       String thumbnailUrl = docSnapshot.get("thumbnail_url").toString();
  //       String date1 = docSnapshot.get("1ere_date_timestamp").toString();
  //       String salle1 = docSnapshot.get("1ere_salle").toString();
  //       String spotify = docSnapshot.get("spotify").toString();
  //       String deezer = docSnapshot.get("deezer").toString();
  //       String codeISO = docSnapshot.get("cou_iso3_code").toString();
  //       String description = docSnapshot.get("description").toString();
  //       Artist a = Artist(id, name, annee, thumbnailUrl, date1, salle1,spotify,deezer,codeISO, description);
  //       userFavs.add(a);
  //     });
  //   }
  // });


Future<AppUser> updateCurrentUserFavorites(AppUser user) async {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, Object> map = {};
  map["fav"] = user.fav;
  await FirebaseFirestore.instance.collection('users').doc(userId).update(map);
  return user;
}


Future<void> updateName(String name) async {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  Map<String, Object> map = {};
  map["name"] = name;
  await FirebaseFirestore.instance.collection('users').doc(userId).update(map);
  return ;
}

/// not tested
Future<bool> updateRooms(AppUser admin, userIdTarget, List newRooms) async {
  var userId = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection('users').doc(userId).get().then((docSnapshot) {
    String adminStatus = docSnapshot.get("status");
    // Check if user is admin in database.
    if (adminStatus != "admin"){
      return false;
    }
    else{
      Map<String, Object> map = {};
      map["rooms"] = newRooms;
      FirebaseFirestore.instance.collection('users').doc(userIdTarget).update(map);
      return true;
    }
  });
  return false;
}

/// not tested
Future<bool> updateStatus(AppUser admin, userIdTarget, newStatus) async {
  if (!["user", "manager", "admin"].contains(newStatus))  {
    return false;
  }

  var userId = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection('users').doc(userId).get().then((docSnapshot) {
    String adminStatus = docSnapshot.get("status");
    // Check if user is admin in database.
    if (adminStatus != "admin"){
      return false;
    }
    else{
      Map<String, Object> map = {};
      map["status"] = newStatus;
      FirebaseFirestore.instance.collection('users').doc(userIdTarget).update(map);
      return true;
    }
  });
  return false;
}

Future<List<AppUser>> getAllUsers() async {
  List<AppUser> usersList = [];
  await FirebaseFirestore.instance
      .collection('users')
      .get()
      .then((docSnapshot) {
    for (var i = 0; i <= docSnapshot.docs.length - 1; i++) {
      //Skip admins
      if(docSnapshot.docs[i]["status"] != "admin"){
        String id = docSnapshot.docs[i].id;
        String name = docSnapshot.docs[i]["name"].toString();
        List fav = docSnapshot.docs[i]["fav"];
        String status = docSnapshot.docs[i]["status"].toString();
        List rooms = docSnapshot.docs[i]["rooms"];
        usersList.add(AppUser(id, name, fav, status, rooms));
      }
    }
  });
  return usersList;
}


Future<bool> updateUser(AppUser user) async {
  bool result = false;
  Map<String, Object> map = {};
  map["name"] = user.name;
  map["rooms"] = user.rooms;
  map["status"] = user.status;
  await FirebaseFirestore.instance.collection('users').doc(user.id).update(map).then((docSnapshot) {
    result = true;
  }).catchError((docSnapshot) {
    result =  false;
  });
  return result;
}