import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/assets/textual_constants.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/artists_services.dart';
import 'package:hackaton_obsidian/services/user.dart';
import 'manager_page.dart';

class AddArtistPage extends StatelessWidget {
  AppUser currentUser;
  AddArtistPage(this.currentUser, {Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _thumbnailController = TextEditingController();
  final TextEditingController _date1Controller = TextEditingController();
  final TextEditingController _salle1Controller = TextEditingController();
  final TextEditingController _codeISOController = TextEditingController();
  final TextEditingController _spotifyController = TextEditingController();
  final TextEditingController _deezerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: NavDrawer(
        pagename: 'Ajouter',
      ),
      appBar: CustomAppBar('Ajouter'),
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
                          controller: _nameController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.person_outlined),
                            hintText: 'Nom de scene',
                            labelText: 'Nom',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return TEXT_REQUIRED;
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: _yearController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            hintText: 'Année',
                            labelText: 'Année',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return TEXT_REQUIRED;
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: _thumbnailController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.collections_outlined),
                            hintText: 'Couverture',
                            labelText: 'Couverture',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _thumbnailController.text = "";
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: _date1Controller,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today),
                            hintText: 'Date ISO',
                            labelText: 'Date ISO',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return TEXT_REQUIRED;
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: _salle1Controller,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.room_outlined),
                            hintText: 'Salle',
                            labelText: 'Salle',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return TEXT_REQUIRED;
                            }
                            else if (currentUser.status == "manager"){
                              if(!currentUser.rooms.contains(value)){
                                return 'Merci de saisir une salle qui vous est attribuée : ' + currentUser.rooms.toString();
                              }
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: _codeISOController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.flag_outlined),
                            hintText: 'Code ISO',
                            labelText: 'Code ISO',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return TEXT_REQUIRED;
                            }
                            return null;
                          }),
                      TextFormField(
                          controller: _spotifyController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.music_note_outlined),
                            hintText: 'Spotify',
                            labelText: 'Spotify',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _spotifyController.text = "";
                            }
                            return null;
                          }
                          ),
                      TextFormField(
                          controller: _deezerController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.music_note_outlined),
                            hintText: 'Deezer',
                            labelText: 'Deezer',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _deezerController.text = "";
                            }
                            return null;
                          }
                      ),
                      TextFormField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.description_outlined),
                            hintText: 'Description',
                            labelText: 'Description',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              _descriptionController.text = "";
                            }
                            return null;
                          }
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 40, top: 40.0),
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(primary: APP_BAR_COLOR),
                            label: const Text('Valider', style: TextStyle(color: Colors.white)),
                            icon: const Icon(Icons.done, color: Colors.white),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                Artist tmpArtist = Artist("", _nameController.text, _yearController.text, _thumbnailController.text, _date1Controller.text, _salle1Controller.text, _spotifyController.text, _deezerController.text, _codeISOController.text, _descriptionController.text);

                                if (await addArtist(tmpArtist) == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(UPDATE_SUCCESS)));
                                  _nameController.text = "";
                                  _yearController.text = "";
                                  _thumbnailController.text = "";
                                  _date1Controller.text = "";
                                  _salle1Controller.text = "";
                                  _codeISOController.text = "";
                                  _spotifyController.text = "";
                                  _deezerController.text = "";
                                  _descriptionController.text = "";
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
