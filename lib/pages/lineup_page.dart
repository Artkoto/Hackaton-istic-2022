import 'package:flutter/material.dart';
import 'package:hackaton_obsidian/assets/constants.dart';
import 'package:hackaton_obsidian/components/custom_appbar.dart';
import 'package:hackaton_obsidian/components/nav_drawer.dart';
import 'package:hackaton_obsidian/services/artist.dart';
import 'package:hackaton_obsidian/services/artists_services.dart';
import 'artist_page.dart';

class LineupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LineupState();
}

class LineupState extends State<LineupPage> {

  int selectedTimestamp = 1575504000;
  String selectedYear = "2019";//THIS_YEAR;

  Widget dateSquare(timestamp){
    DateTime date =  DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var day = date.day.toString();
    var weekday = WEEKDAYS[date.weekday-1];
    var month = MONTHS[date.month-1];
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedTimestamp = timestamp;
          print("Day container clicked, new selectedTimestamp : " + selectedTimestamp.toString());
        });
      },
      child: Container(
        margin: const EdgeInsets.all(10.0),
        width: 160.0,
        height: 100.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: const DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage(TRANS_BACKGROUND_THEME),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.7),
                offset: const Offset(10, 10),
                blurRadius: 3,
                spreadRadius: -3
            )
          ],
        ),
        child: Center(
          child: Container (
            width: 130,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Center (
              child: Text(
                weekday+". "+day+" "+month,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: FONT_SIZE_TEXT,
                  color: Colors.white
                )
              )
            )
          )
        )
      )
    );
  }

  Future<List<int>> getDays(annee) async {
    List<Artist> artistes = await getArtistsFromFilter("annee", annee);
    List<int> days = [];
    for( var a in artistes) {
      var dateTime = int.parse(a.date1);
      if (!days.contains(dateTime)) {
        days.add(dateTime);
      }
    }
    days.sort((a,b) => a.compareTo(b));
    return days;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      drawer: NavDrawer(pagename: 'Programmation',),
      appBar: CustomAppBar('Programmation'),
      body: Column(
          children : [
            SizedBox(
                height: 120,
                child : FutureBuilder<List<int>>(
                    future: getDays(selectedYear),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<int> days = snapshot.data ?? [];
                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: days.length,
                            itemBuilder: (context, index) {
                              int day = days[index];
                              return dateSquare(day);
                            }
                        );
                      }
                      else if (snapshot.hasError) {
                        return const Center (
                            child : Text (
                              "An error has occured",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: FONT_SIZE_TEXT,
                              ),
                            )
                        );
                      }
                      else {
                        return const Center (
                            child : CircularProgressIndicator()
                        );
                      }
                    }
                )
            ),
            Expanded(
                child : FutureBuilder<List<Artist>>(
                    future: getArtistsFromFilter("1ere_date_timestamp", selectedTimestamp),
                    builder: (context, snapshot) {
                      if(snapshot.hasData) {
                        List<Artist> artists = snapshot.data ?? [];
                        return ListView.builder(
                            itemCount: artists.length,
                            itemBuilder: (context, index) {
                              Artist artist = artists[index];
                              return GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ArtistPage(artist))
                                ),
                                child: Card(
                                  child: ListTile(
                                    // Access the fields as defined in FireStore
                                    leading: (artist.thumbnail_url == ""
                                      ? Image.asset(PICTURE_NOT_FOUND)
                                      : Image.network(artist.thumbnail_url)),
                                    title: Text(artist.name),
                                    subtitle: Text(artist.year),
                                  )
                                )
                              );
                            }
                        );
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
            ),
          ]
      ),
    );
  }
}