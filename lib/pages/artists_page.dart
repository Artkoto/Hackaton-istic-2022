import 'package:filter_list/filter_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/pages/error_page.dart';
import 'package:hackaton_obsidian/pages/loading_page.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/artists_services.dart';
import 'artist_page.dart';

enum filter_type { none, artist, other }

class ArtistsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ArtistsPageState();
}

class ArtistsPageState extends State<ArtistsPage> {
  List<String> placesList = [];
  List<String> selectedPlacesList = [];

  List<String> yearList = [];
  List<String> selectedYearList = [];

  String searchCriteria = "";

  List<Artist> allArtists = [];

  filter_type currentFilterType = filter_type.none;

  Widget Filters() {
    return Column(children: [
      Row(children: [
        const Padding(padding: EdgeInsets.only(left: 10)),
        Expanded(
            child: TextField(
          decoration: const InputDecoration(
            hintText: 'Rechercher ',
            hintStyle: TextStyle(
              fontSize: FONT_SIZE_TEXT,
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: APP_BAR_COLOR),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: APP_BAR_COLOR),
            ),
          ),
          cursorColor: APP_BAR_COLOR,
          onChanged: (text) {
            searchCriteria = text.toLowerCase();
            currentFilterType = filter_type.artist;
            setState(() {});
          },
        )),
        const Padding(padding: EdgeInsets.only(right: 10)),
      ]),
      const SizedBox(
        height: 10,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        FutureBuilder<List<String>>(
            future: getPlaces(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                placesList = snapshot.data ?? [];
              }
              return OutlinedButton(
                  onPressed: () => {
                        currentFilterType = filter_type.other,
                        _openFilterDialog(
                            placesList, selectedPlacesList, "place"),
                      },
                  style: OutlinedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    primary: Colors.grey,
                  ),
                  child: const Text("Salle"));
            }),
        FutureBuilder<List<String>>(
            future: getYear(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                yearList = snapshot.data ?? [];
              }
              return OutlinedButton(
                  onPressed: () => {
                        currentFilterType = filter_type.other,
                        _openFilterDialog(yearList, selectedYearList, "year"),
                      },
                  style: OutlinedButton.styleFrom(
                    textStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    primary: Colors.grey,
                  ),
                  child: const Text("Annee"));
            }),
        OutlinedButton(
            onPressed: () => {
                  currentFilterType = filter_type.none,
                  selectedYearList = [],
                  selectedPlacesList = [],
                  setState(() {})
                },
            style: OutlinedButton.styleFrom(
              textStyle: const TextStyle(
                fontSize: 16,
              ),
              primary: Colors.grey,
            ),
            child: const Text("Restaurer"))
      ])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: false,
        drawer: NavDrawer(
          pagename: 'Artistes',
        ),
        appBar: CustomAppBar('Artistes'),
        body: Column(children: [
          Filters(),
          Expanded(
              child: FutureBuilder<List<Artist>>(
                  future: getAllArtists(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const LoadingPage();
                    }
                    if (snapshot.hasError) {
                      return const ErrorPage();
                    }
                    allArtists = snapshot.data ?? [];
                    List<Artist> artists = [];
                    switch (currentFilterType) {
                      case filter_type.none:
                        artists = allArtists;
                        break;
                      case filter_type.artist:
                        artists = filterByArtist();
                        break;
                      case filter_type.other:
                        artists = otherFilter();
                        break;
                    }
                    return ListView.builder(
                        itemCount: artists.length,
                        itemBuilder: (context, index) {
                          Artist artist = artists[index];
                          return GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ArtistPage(artist))),
                              child: Card(
                                  child: ListTile(
                                // Access the fields as defined in FireStore
                                leading: (artist.thumbnail_url == ""
                                    ? Image.asset(PICTURE_NOT_FOUND)
                                    : Image.network(artist.thumbnail_url)),
                                title: Text(artist.name),
                                subtitle: Text(artist.year),
                              )));
                        });
                  }))
        ]));
  }

  void _openFilterDialog(data, selectedData, type) async {
    await FilterListDialog.display<String>(context,
        listData: data,
        selectedListData: selectedData,
        height: 480,
        hideheader: true,
        hideCloseIcon: true,
        selectedTextBackgroundColor: APP_BAR_COLOR,
        selectedChipTextStyle: const TextStyle(
          color: CURR_PAGE_COLOR,
        ),
        buttonSpacing: 10,
        applyButonTextBackgroundColor: APP_BAR_COLOR,
        applyButtonTextStyle: const TextStyle(
          color: CURR_PAGE_COLOR,
          fontSize: FONT_SIZE_TEXT,
        ),
        applyButtonText: "Appliquer",
        controlButtonTextStyle: const TextStyle(
          color: APP_BAR_COLOR,
          fontSize: FONT_SIZE_TEXT,
        ),
        resetButtonText: "Reset",
        allButtonText: "Tout", choiceChipLabel: (item) {
      return item;
    }, validateSelectedItem: (list, val) {
      return list!.contains(val);
    }, onItemSearch: (list, text) {
      if (list!.any(
          (element) => element.toLowerCase().contains(text.toLowerCase()))) {
        return list
            .where(
                (element) => element.toLowerCase().contains(text.toLowerCase()))
            .toList();
      } else {
        return [];
      }
    }, onApplyButtonClick: (list) {
      if (list != null) {
        setState(() {
          if (type == "place") {
            selectedPlacesList = List.from(list);
          } else if (type == "year") {
            selectedYearList = List.from(list);
          }
        });
      }
      Navigator.pop(context);
    });
  }

  Future<List<String>> getPlaces() async {
    List<Artist> artistes = await getAllArtists();
    List<String> places = [];
    for (var a in artistes) {
      if (!places.contains(a.salle1)) {
        places.add(a.salle1);
      }
    }
    places.sort((a, b) => a.compareTo(b));
    return places;
  }

  Future<List<String>> getYear() async {
    List<Artist> artistes = await getAllArtists();
    List<String> years = [];
    for (var a in artistes) {
      if (!years.contains(a.year)) {
        years.add(a.year);
      }
    }
    years.sort((a, b) => a.compareTo(b));
    return years;
  }

  List<Artist> filterByArtist() {
    List<Artist> res = [];
    allArtists.forEach((artist) {
      if (artist.name.toLowerCase().contains(searchCriteria) ||
          artist.salle1.toLowerCase().contains(searchCriteria) ||
          artist.year.toLowerCase().contains(searchCriteria)) {
        res.add(artist);
      }
    });
    return res;
  }

  List<Artist> otherFilter() {
    List<Artist> res = [];
    List<String> places = [];
    List<String> years = [];
    // Si rien n'est sélectionné, pas de filtrage ( = filtrage sur tout)
    if (selectedPlacesList.isEmpty)
      places = placesList;
    else
      places = selectedPlacesList;
    if (selectedYearList.isEmpty)
      years = yearList;
    else
      years = selectedYearList;
    allArtists.forEach((artist) {
      if (places.contains(artist.salle1) && years.contains(artist.year)) {
        res.add(artist);
      }
    });
    return res;
  }
}
