import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/assets/textual_constants.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/artists_services.dart';

class ArtistRemovePage extends StatelessWidget {
  final Artist artist;
  final Function refresh;

  ArtistRemovePage(this.artist, this.refresh, {Key? key}) : super(key: key);

  final Map<String, String> textFieldsValue = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Supprimer : " + artist.name, style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: APP_BAR_COLOR,
      ),
      body: Container(
          margin: const EdgeInsets.all(15.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Center(child: Container(margin: const EdgeInsets.all(10.0), child: const Text("Cette action est irréversible", style: TextStyle(color: Colors.red, fontSize: 15)))),

            Center(child:ElevatedButton.icon(
              style: ElevatedButton.styleFrom(primary: APP_BAR_COLOR),
              label: const Text(CONFIRM_REMOVE, style: TextStyle(color: Colors.white, fontSize: 15)),
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () async {
                if (await deleteArtist(artist) == true) {
                  refresh();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(UPDATE_SUCCESS)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(SAVING_ERROR)),
                  );
                }
              },
            ))
          ])),
    );
  }
}
