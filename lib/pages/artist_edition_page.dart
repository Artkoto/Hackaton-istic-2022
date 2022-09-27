import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/assets/textual_constants.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/artists_services.dart';

class ArtistEditionPage extends StatelessWidget {
  final Artist artist;
  final Function refresh;

  ArtistEditionPage(this.artist, this.refresh, {Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  final Map<String, String> textFieldsValue = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editer : " + artist.name, style:const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: APP_BAR_COLOR,
      ),
      body: Container(
          margin: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
              child: Stack(children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                      initialValue: artist.name,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person_outlined),
                        hintText: 'Nom de scene',
                        labelText: 'Nom',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return TEXT_REQUIRED;
                        } else {
                          textFieldsValue["name"] = value;
                        }
                        return null;
                      }),
                  TextFormField(
                      initialValue: artist.year,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        hintText: 'Année',
                        labelText: 'Année',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return TEXT_REQUIRED;
                        } else {
                          textFieldsValue["year"] = value;
                        }
                        return null;
                      }),
                  TextFormField(
                      initialValue: artist.thumbnail_url,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.collections_outlined),
                        hintText: 'Couverture',
                        labelText: 'Couverture',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          textFieldsValue["thumbnail_url"] = "";
                        } else {
                          textFieldsValue["thumbnail_url"] = value;
                        }
                        return null;
                      }),
                  TextFormField(
                      initialValue: artist.date1,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        hintText: 'Date Timestamp',
                        labelText: 'Date Timestamp',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return TEXT_REQUIRED;
                        } else {
                          textFieldsValue["date1"] = value;
                        }
                        return null;
                      }),
                  TextFormField(
                      initialValue: artist.salle1,
                      enabled: false,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.room_outlined),
                        hintText: 'Salle',
                        labelText: 'Salle',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return TEXT_REQUIRED;
                        } else {
                          textFieldsValue["salle1"] = value;
                        }
                        return null;
                      }),
                  TextFormField(
                      initialValue: artist.description,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.description_outlined),
                        hintText: 'Description',
                        labelText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          textFieldsValue["description"] = "";
                        } else {
                          textFieldsValue["description"] = value;
                        }
                        return null;
                      }),
                  TextFormField(
                      initialValue: artist.codeISO,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.flag_outlined),
                        hintText: 'Code ISO',
                        labelText: 'Code ISO',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          textFieldsValue["iso"] = "";
                        } else {
                          textFieldsValue["iso"] = value;
                        }
                        return null;
                      }),
                  TextFormField(
                      initialValue: artist.deezer,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.music_note_outlined),
                        hintText: 'Deezer',
                        labelText: 'Deezer',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          textFieldsValue["deezer"] = "";
                        } else {
                          textFieldsValue["deezer"] = value;
                        }
                        return null;
                      }),
                  TextFormField(
                      initialValue: artist.spotify,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.music_note_outlined),
                        hintText: 'Spotify',
                        labelText: 'Spotify',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          textFieldsValue["spotify"] = "";
                        } else {
                          textFieldsValue["spotify"] = value;
                        }
                        return null;
                      }),
                  Container(
                      padding: const EdgeInsets.only(left: 40, top: 40.0),
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(primary: APP_BAR_COLOR),
                        label: const Text('Valider', style: TextStyle(color: Colors.white)),
                        icon: const Icon(Icons.done, color: Colors.white),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            var name = textFieldsValue["name"];
                            var year = textFieldsValue["year"];
                            var thumbnailurl = textFieldsValue["thumbnail_url"];
                            var date1 = textFieldsValue["date1"];
                            var salle1 = textFieldsValue["salle1"];

                            var description = textFieldsValue["description"];
                            var iso = textFieldsValue["iso"];
                            var deezer = textFieldsValue["deezer"];
                            var spotify = textFieldsValue["spotify"];

                            if (name != null) {
                              artist.name = name;
                            }
                            if (year != null) {
                              artist.year = year;
                            }
                            if (thumbnailurl != null) {
                              artist.thumbnail_url = thumbnailurl;
                            }
                            if (date1 != null) {
                              artist.date1 = date1;
                            }
                            if (salle1 != null) {
                              artist.salle1 = salle1;
                            }
                            if (description != null) {
                              artist.description = description;
                            }
                            if (iso != null) {
                              artist.codeISO = iso;
                            }
                            if (deezer != null) {
                              artist.deezer = deezer;
                            }
                            if (spotify != null) {
                              artist.spotify = spotify;
                            }

                            if (await updateArtist(artist) == true) {
                              refresh();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(UPDATE_SUCCESS)),
                              );
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
                                      Text(INVALID_FORM)),
                            );
                          }
                        },
                      )),
                ],
              ),
            )
          ]))),
    );
  }
}
