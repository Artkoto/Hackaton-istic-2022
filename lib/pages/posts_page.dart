import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/services/post.dart';
import 'package:hackaton_obsidian/services/posts_services.dart';
import 'package:hackaton_obsidian/services/user.dart';
import 'package:hackaton_obsidian/services/user_services.dart';
import 'package:hackaton_obsidian/services/notification_services.dart';
import 'package:hackaton_obsidian/assets/textual_constants.dart';

class PostsPage extends StatefulWidget {

  PostsPage({Key? key}) : super(key: key);
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  Future<List<Post>> postList = getPostsByYear(THIS_YEAR);

  Future refresh() async{
    setState(() {
      postList = getPostsByYear(THIS_YEAR);
    });
  }

  String displayDate(timestamp){
    DateTime publication = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    DateTime now = DateTime.now();

    var today = DateTime(now.year, now.month, now.day);
    var yesterday = DateTime(now.year, now.month, now.day-1);
    var dayOfPublication = DateTime(publication.year, publication.month, publication.day);

    var publicationHourDisplay = " à "+publication.hour.toString() +"h"+ publication.minute.toString();
    var publicationDateDisplay = "";
    if(dayOfPublication == today){
      publicationDateDisplay = "aujourd'hui"+publicationHourDisplay;
    } else if (dayOfPublication == yesterday){
      publicationDateDisplay = "hier"+publicationHourDisplay;
    } else {
      publicationDateDisplay = "le "+publication.day.toString() +" "+MONTHS[publication.month-1]+publicationHourDisplay;
    }

    return publicationDateDisplay;
  }

  Widget displayPost(publicationDate, title, content){
    return Center (
        child : ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Container (
                decoration: BoxDecoration(
                  color: TOP_CARD_BACKGROUND_COLOR,
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  image: const DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage(TRANS_BACKGROUND_THEME),
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        offset: const Offset(10, 10),
                        blurRadius: 5,
                        spreadRadius: -3
                    )
                  ],
                ),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        padding: const EdgeInsets.all(10.0),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            border: Border.all(
                              color: TOP_CARD_TEXT_COLOR,
                            ),
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5)
                            )
                        ),
                        child : ListTile(
                          leading: Image.asset(TRANS_LOGO_PICTURE),
                          title: Text(
                              title,
                              style : const TextStyle(
                                color: TOP_CARD_TEXT_COLOR,
                                fontWeight: FontWeight.bold,
                                fontSize: FONT_SIZE_TITLE,
                              )
                          ),
                          subtitle: Text(
                              displayDate(publicationDate),
                              style : const TextStyle(
                                color: TOP_CARD_TEXT_COLOR,
                                fontSize: FONT_SIZE_SUBTITLE,
                              )
                          ),
                        )
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                          padding: const EdgeInsets.all(10.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              border: Border.all(
                                color: TOP_CARD_TEXT_COLOR,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5)
                              )
                          ),
                          child : Text(
                              content,
                              style : const TextStyle(
                                color: Colors.black,
                                fontSize: FONT_SIZE_TEXT,
                              )
                          )
                      )
                    ]
                )
            )
        )
    );
  }

  Widget newPostDialog(BuildContext context){
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _contentController = TextEditingController();

    return AlertDialog(
      title: const Text(
        'Nouvelle annonce',
        textAlign: TextAlign.center,
      ),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text(
            'Annuler',
            style: TextStyle(
              color: Colors.grey
            ),
          ),
        ),
        OutlinedButton(
          child: const Text(
            'Valider',
            style: TextStyle(
              color: Colors.grey
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              DateTime now = DateTime.now();
              var publicationDate = (now.millisecondsSinceEpoch/1000).round();
              Post tmpPost = Post(
                  "",
                  _titleController.text,
                  _contentController.text,
                  now.year.toString(),
                  publicationDate
              );
              if (await addPost(tmpPost) == true) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(UPDATE_SUCCESS)));
                sendNotification(_titleController.text, _contentController.text);
                _titleController.text = "";
                _contentController.text = "";
                print(publicationDate);
                refresh();
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text(SAVING_ERROR)),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                    Text(INVALID_FORM)
                ),
              );
            }
          },
        )
      ],
      content: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  maxLength: 256,
                  decoration: const InputDecoration(
                    labelText: 'Titre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TEXT_REQUIRED;
                    }
                    return null;
                  }
                ),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Contenu',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return TEXT_REQUIRED;
                    }
                    return null;
                  }
                ),
                Container(
                  padding: const EdgeInsets.only(left: 40, top: 40.0),
                ),
              ]
            )
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: NavDrawer(pagename: 'Annonces',),
      appBar: CustomAppBar('Annonces'),
      floatingActionButton: FutureBuilder<AppUser>(
          future: getUserSettings(),
          builder: (context, snapshot) {
            Widget widgetToReturn = Container();
            if (snapshot.connectionState != ConnectionState.done) {
              widgetToReturn = Container();
            } else if (snapshot.connectionState == ConnectionState.done) {
              AppUser userSettings = snapshot.data ??
                  AppUser("", "", [], "", []);
              if (userSettings.status == "manager" ||
                  userSettings.status == "admin") {
                  widgetToReturn = FloatingActionButton(
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => newPostDialog(context),
                    )
                  },
                  child: const Icon(
                    Icons.add_alert,
                    color: CURR_PAGE_COLOR,
                  ),
                  backgroundColor: Colors.black,
                );
              }
            }
            return widgetToReturn;
          }
      ),
      body : FutureBuilder<List<Post>>(
          future: postList,
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              List<Post> posts = snapshot.data ?? [];
              if(posts.isEmpty){
                return const Center(
                    child: Text("Pas d'annonces trouvées")
                );
              } else {
                return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      Post post = posts[index];
                      return displayPost(
                          post.publicationDate, post.title, post.content);
                    }
                );
              }
            }
            else if (snapshot.hasError) {
              return Center (
                  child : Text (
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: FONT_SIZE_TEXT,
                    ),
                  )
              );
            }
            else {
              return const Center ( child: CircularProgressIndicator() );
            }
          }
      )
    );
  }
}