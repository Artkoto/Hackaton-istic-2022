import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// DATE
String THIS_YEAR = DateTime.now().year.toString();

const String POLICE_TEXT = "arial";
const String POLICE_TITLE = "arial";
const double FONT_SIZE_TEXT = 18;
const double FONT_SIZE_TITLE = 26;
const double FONT_SIZE_SUBTITLE = 12;

// COLORS
const int COLOR_RED = 0xfffe3a3f;
const int COLOR_DARK_BLEU = 0xff21acd5;
const int COLOR_LIGHT_BLEU = 0xffa9e1fb;

// Nav & appBar settings
const Color APP_BAR_COLOR = Colors.black;
const Color CURR_PAGE_COLOR = Color(0xfff8fb60);

// TIMESTAMP CONVERTERS
const List<String> WEEKDAYS = [
  "Lun",
  "Mar",
  "Mer",
  "Jeu",
  "Ven",
  "Sam",
  "Dim",
];
const List<String> MONTHS = [
  "jan.",
  "fev.",
  "mars",
  "avr.",
  "mai",
  "juin",
  "jui.",
  "aout",
  "sep.",
  "oct.",
  "nov.",
  "dec."
];

// Pictures Constants
const String DEFAULT_PICTURE = "https://cdn-icons.flaticon.com/png/512/968/premium/968510.png?token=exp=1638371948~hmac=a7629e66b0dff6cb7906a49168cdca23";
const String PICTURE_NOT_FOUND = "images/pictureNotFound.png";
const String TRANS_LOGO_PICTURE = "images/trans_logo_1.jpg";
const String TRANS_COVER_IMAGE = "images/trans_logo_2.jpg";
const String SPOTIFY_LOGO = "images/icone_spoti.png";
const String DEEZER_LOGO = "images/icone_deezer.png";
const String TRANS_BACKGROUND_THEME = "images/trans_main_theme_background.jpg";

// Text styles
const TextStyle TITLE_STYLE = TextStyle(fontWeight: FontWeight.bold, fontSize: 25);
const TextStyle SUBTITLE_STYLE = TextStyle(fontSize: 18);
const TextStyle INFO_TITLE_STYLE = TextStyle(fontStyle: FontStyle.italic, fontSize: 12);

// Home Cards settings
const double HOME_GRID_FONT_SIZE = 30;
const Color HOME_GRID_FONT_COLOR = Colors.white;
const Color HOME_GRID_FONT_BACKGROUND_COLOR = Colors.black26;
const FontWeight HOME_GRID_FONT_WEIGHT = FontWeight.bold;
const double HOME_GRID_HEIGHT = 200;
const double HOME_GRID_MARGIN_AROUND = 20;
const int NB_ARTISTS_TO_LOAD = 12;

// Loading Page settings
const Color LOADING_ICON_COLOR = Colors.grey;
const double LOADING_ICON_SIZE = 70;

// Posts Page settings
const Color TOP_CARD_BACKGROUND_COLOR = Colors.black;
const Color TOP_CARD_TEXT_COLOR = Color(0xfff8fb60);