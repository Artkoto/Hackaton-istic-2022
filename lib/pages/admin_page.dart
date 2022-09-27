import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/assets/textual_constants.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/services/user.dart';
import 'package:hackaton_obsidian/services/user_services.dart';
import 'error_page.dart';
import 'loading_page.dart';

///
/// Widget for displaying error page.
///
class AdminPage extends StatelessWidget {
  AdminPage({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static String _displayStringForOption(AppUser option) => "Id: " + option.id;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _favController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  AppUser currentEditableUser = AppUser("","",[],"",[]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: NavDrawer(
          pagename: 'Administration',
        ),
        appBar: CustomAppBar('Administration'),
        body: Container(
            margin: const EdgeInsets.all(10),
            child: ListView(children: <Widget>[
              const Text("Type User Id :"),
              FutureBuilder<List<AppUser>>(
                  future: getAllUsers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const LoadingPage();
                    }
                    if (snapshot.hasError) {
                      return const ErrorPage();
                    }
                    List<AppUser> users = snapshot.data ?? [];
                    return Autocomplete<AppUser>(
                      displayStringForOption: _displayStringForOption,
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<AppUser>.empty();
                        }
                        return users.where((AppUser option) {
                          return option.id
                              .toLowerCase()
                              .startsWith(textEditingValue.text.toLowerCase());
                        });
                      },
                      onSelected: (AppUser selection) {
                        print('Selected ${_displayStringForOption(selection)}');
                        _idController.text = selection.id;
                        _favController.text = selection.fav.toString();
                        _nameController.text = selection.name;
                        _roomsController.text = selection.rooms.toString();
                        _statusController.text = selection.status;

                        currentEditableUser = selection;
                      },
                    );
                  }),
              const Divider(
                height: 20,
                thickness: 1,
                indent: 20,
                endIndent: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                        enabled: false,
                        controller: _idController,
                        decoration: const InputDecoration(icon: Icon(Icons.person), hintText: 'Id', labelText: 'Id',),
                        ),
                    TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(icon: Icon(Icons.calendar_today), hintText: 'Nom', labelText: 'Nom',),
                        ),
                    TextFormField(
                        controller: _statusController,
                        decoration: const InputDecoration(icon: Icon(Icons.collections_outlined), hintText: 'Statut', labelText: 'Statut',),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          else if(value != "admin" && value != "user" && value != "manager"){
                            return USER_STATUS_REQUIREMENT_ERROR;
                          }
                          return null;
                        }),
                    TextFormField(
                        controller: _roomsController,
                        decoration: const InputDecoration(icon: Icon(Icons.calendar_today), hintText: 'Salles', labelText: 'Salles',),
                        ),
                    TextFormField(
                        controller: _favController,
                        enabled: false,
                        decoration: const InputDecoration(icon: Icon(Icons.room_outlined), hintText: 'Favoris', labelText: 'Favoris',),
                        ),
                    Container(
                        padding: const EdgeInsets.only(left: 40, top: 40.0),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(primary: APP_BAR_COLOR),
                          label: const Text('Valider', style: TextStyle(color:Colors.white)),
                          icon: const Icon(Icons.done, color: Colors.white),
                          onPressed: () async {
                            if (_formKey.currentState!.validate() && currentEditableUser.id != "") {
                              // Set new status
                              currentEditableUser.status = _statusController.text;

                              // Set new name
                              currentEditableUser.name = _nameController.text;

                              _roomsController.text = _roomsController.text.replaceAll("[", "").replaceAll("]", "");
                              List roomsAsList = _roomsController.text.split(",");
                              roomsAsList.forEach((element) {element.trim();});
                              roomsAsList.removeWhere((element) => element=="");

                              currentEditableUser.rooms = roomsAsList;

                              await updateUser(currentEditableUser).then((docSnapshot) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(USER_UPDATE_SUCCESS)),);
                              }).catchError((docSnapshot) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(SAVING_ERROR)),);
                              });

                            }
                            else {
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
            ])));
  }
}
