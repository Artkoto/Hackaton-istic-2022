import 'package:intl/intl.dart';


class Artist{
  late String id;
  late String name;
  late String year;
  late String thumbnail_url;
  late String date1;
  late String salle1;
  late String spotify;
  late String deezer;
  late String codeISO;
  late String description;


  Artist(
      this.id,
      this.name,
      this.year,
      this.thumbnail_url,
      this.date1,
      this.salle1,
      this.spotify,
      this.deezer,
      this.codeISO,
      this.description
      );




 String getDateFromTimeStamp(String dateString){
    var tmp = int.tryParse(dateString);
    DateTime date =  DateTime.fromMillisecondsSinceEpoch(tmp! * 1000);
    var jour = TransDay(DateFormat('EEEE').format(date));
    var mois = TransMounth(DateFormat('MMMM').format(date));
    return jour+" "+ date.day.toString()+ " " + mois+ " " + date.year.toString();

  }
  String TransDay(String day){
   String s = "";
   switch (day){
     case "Monday" :
       s = "Lundi";
       break;
     case "Tuesday" :
       s = "Mardi";
       break;
     case "Wednesday" :
       s = "Mercredi";
       break;
     case "Tuesday" :
       s = "Jeudi";
       break;
     case "Friday" :
       s= "Vendredi";
       break;
     case "Saturday" :
       s = "Samedi";
       break;
     case "Sunday" :
       s = "Dimanche";
       break;
   }
   return s;
  }

  String TransMounth(String mounth){
    String s = "";
    switch (mounth){
      case "January" :
        s = "Janvier";
        break;
      case "February" :
        s = "Fevrier";
        break;
      case "March" :
        s = "Mars";
        break;
      case "April" :
        s = "Avril";
        break;
      case "May" :
        s= "Mai";
        break;
      case "June" :
        s = "Juin";
        break;
      case "July" :
        s = "Juillet";
        break;
      case "August" :
        s = "Août";
        break;
      case "Spetember" :
        s = "Septembre";
        break;
      case "October" :
        s = "Octobre";
        break;
      case "November" :
        s = "Novembre";
        break;
      case "December" :
        s= "Decembre";
        break;
    }
    return s;
  }

  String getFlag(String iso){
    String flag = "";
    if (iso.isNotEmpty) {
      String countryCode = iso;
      flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
              (match) =>
              String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    }
    return flag;
  }
}