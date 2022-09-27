import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hackaton_obsidian/services/post.dart';

Future<List<Post>> getPostsByYear(year) async {
  List<Post> localList = [];
  await FirebaseFirestore.instance
      .collection('posts')
      .where("year", isEqualTo: year)
      .get()
      .then((docSnapshot) {
    for (var i = 0; i <= docSnapshot.docs.length - 1; i++) {
      String id = docSnapshot.docs[i].id;
      String title = docSnapshot.docs[i]["title"].toString();
      String content = docSnapshot.docs[i]["content"].toString();
      String year = docSnapshot.docs[i]["year"].toString();
      int publicationDate = docSnapshot.docs[i]["publication_date"];
      localList.add(Post(id, title, content, year, publicationDate));
    }
  });
  return localList;
}

Future<bool> addPost(Post post) async{
  bool tmpResult = false;
  Map<String, Object> postData = {};
  postData["title"]=post.title;
  postData["year"]=post.year;
  postData["content"]=post.content;
  postData["publication_date"]=post.publicationDate;
  await FirebaseFirestore.instance.collection("posts").doc().set(postData).then((docSnapshot) {
    tmpResult = true;
  }).catchError((docSnapshot) {
    tmpResult = false;
  });
  return tmpResult;
}