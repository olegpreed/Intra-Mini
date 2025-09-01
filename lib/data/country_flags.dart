import 'package:flutter/material.dart';

Map<String, String> countryFlags = {
  '': '',
  'Angola': '🇦🇴',
  'Armenia': '🇦🇲',
  'Australia': '🇦🇺',
  'Austria': '🇦🇹',
  'Belgium': '🇧🇪',
  'Brazil': '🇧🇷',
  'Canada': '🇨🇦',
  'Czech Republic': '🇨🇿',
  'Finland': '🇫🇮',
  'France': '🇫🇷',
  'Germany': '🇩🇪',
  'Italy': '🇮🇹',
  'Japan': '🇯🇵',
  'Jordan': '🇯🇴',
  'Korea, Republic of': '🇰🇷', // South Korea
  'Lebanon': '🇱🇧',
  'Luxembourg': '🇱🇺',
  'Madagascar': '🇲🇬',
  'Malaysia': '🇲🇾',
  'Moldova, Republic of': '🇲🇩',
  'Morocco': '🇲🇦',
  'Netherlands': '🇳🇱',
  'Palestine, State of': '🇵🇸',
  'Poland': '🇵🇱',
  'Portugal': '🇵🇹',
  'Romania': '🇷🇴',
  'Russian Federation': '🇷🇺',
  'Singapore': '🇸🇬',
  'South Africa': '🇿🇦',
  'Spain': '🇪🇸',
  'Switzerland': '🇨🇭',
  'Thailand': '🇹🇭',
  'Turkey': '🇹🇷',
  'Ukraine': '🇺🇦',
  'United Arab Emirates': '🇦🇪',
  'United Kingdom': '🇬🇧',
  'United States': '🇺🇸',
};

Map<String, List<Color>?> countryColors = {
  '': null,
  'Angola': [
    Color(0xFF000000),
    Color(0xFFFF0000),
    Color(0xFFFFCC00)
  ], // black, red, yellow
  'Armenia': [
    Color(0xFFFF0000),
    Color(0xFF0000FF),
    Color(0xFFFFA500)
  ], // red, blue, orange
  'Australia': [
    Color(0xFF00008B),
    Color(0xFFFFFFFF),
    Color(0xFFFF0000)
  ], // dark blue, white, red
  'Austria': [Color(0xFFFF0000), Color(0xFFFFFFFF)], // red, white
  'Belgium': [
    Color(0xFFFF0000),
    Color(0xFFFFCC00),
    Color(0xFF000000)
  ], // red, yellow, black
  'Brazil': [
    Color(0xFF009739),
    Color(0xFFFFCC00),
    Color(0xFF002776)
  ], // green, yellow, blue
  'Canada': [Color(0xFFFFFFFF), Color(0xFFFF0000)], // white, red
  'Czech Republic': [
    Color(0xFFFFFFFF),
    Color(0xFFFF0000),
    Color(0xFF11457E)
  ], // white, red, blue
  'Finland': [Color(0xFFFFFFFF), Color(0xFF002F6C)], // white, blue
  'France': [
    Color(0xFF0055A4),
    Color(0xFFFFFFFF),
    Color(0xFFEF4135)
  ], // blue, white, red
  'Germany': [
    Color(0xFF000000),
    Color(0xFFFF0000),
    Color(0xFFFFCC00)
  ], // black, red, yellow
  'Italy': [
    Color(0xFF008C45),
    Color(0xFFFFFFFF),
    Color(0xFFCD212A)
  ], // green, white, red
  'Japan': [Color(0xFFFFFFFF), Color(0xFFFF0000)], // white, red
  'Jordan': [
    Color(0xFF000000),
    Color(0xFF007A3D),
    Color(0xFFFF0000),
    Color(0xFFFFFFFF)
  ], // black, green, red, white
  'Korea, Republic of': [
    Color(0xFFFFFFFF),
    Color(0xFFFF0000),
    Color(0xFF000000),
    Color(0xFF0000FF)
  ], // white, red, blue, black
  'Lebanon': [
    Color(0xFFFFFFFF),
    Color(0xFFFF0000),
    Color(0xFF007A3D)
  ], // white, red, green
  'Luxembourg': [
    Color(0xFFFF0000),
    Color(0xFFFFFFFF),
    Color(0xFF00A2E8)
  ], // red, white, light blue
  'Madagascar': [
    Color(0xFFFFFFFF),
    Color(0xFFFF0000),
    Color(0xFF008000)
  ], // white, red, green
  'Malaysia': [
    Color(0xFF010066),
    Color(0xFFFFCC00),
    Color(0xFFFF0000),
    Color(0xFFFFFFFF)
  ], // blue, yellow, red, white
  'Moldova, Republic of': [
    Color(0xFF0033A0),
    Color(0xFFFFCC00),
    Color(0xFFDA291C)
  ], // blue, yellow, red
  'Morocco': [Color(0xFFFF0000), Color(0xFF006233)], // red, green
  'Netherlands': [
    Color(0xFFFF0000),
    Color(0xFFFFFFFF),
    Color(0xFF21468B)
  ], // red, white, blue
  'Palestine, State of': [
    Color(0xFF000000),
    Color(0xFFFFFFFF),
    Color(0xFF007A3D),
    Color(0xFFFF0000)
  ], // black, white, green, red
  'Poland': [Color(0xFFFFFFFF), Color(0xFFFF0000)], // white, red
  'Portugal': [
    Color(0xFF006600),
    Color(0xFFFF0000),
    Color(0xFFFFCC00)
  ], // green, red, yellow
  'Romania': [
    Color(0xFF002B7F),
    Color(0xFFFFCC00),
    Color(0xFFCE1126)
  ], // blue, yellow, red
  'Russian Federation': [
    // Color(0xFFFFFFFF),
    Color(0xFF0000FF),
    Color(0xFFFF0000)
  ], // white, blue, red
  'Singapore': [Color(0xFFFFFFFF), Color(0xFFFF0000)], // white, red
  'South Africa': [
    Color(0xFF007847),
    Color(0xFFFFB612),
    Color(0xFF000000),
    Color(0xFFFFFFFF),
    Color(0xFFDE3831),
    Color(0xFF002395)
  ], // green, yellow, black, white, red, blue
  'Spain': [Color(0xFFFF0000), Color(0xFFFFCC00)], // red, yellow
  'Switzerland': [Color(0xFFFFFFFF), Color(0xFFFF0000)], // white, red
  'Thailand': [
    Color(0xFF000066),
    // Color(0xFFFFFFFF),
    Color(0xFFFF0000)
  ], // blue, white, red
  'Turkey': [Color(0xFFFFFFFF), Color(0xFFFF0000)], // white, red
  'Ukraine': [Color(0xFFFFCC00), Color(0xFF0057B7)], // yellow, blue
  'United Arab Emirates': [
    Color(0xFF00732F),
    Color(0xFFFF0000),
    Color(0xFFFFFFFF),
    Color(0xFF000000)
  ], // green, red, white, black
  'United Kingdom': [
    Color(0xFF00247D),
    Color(0xFFFFFFFF),
    Color(0xFFCF142B)
  ], // blue, white, red
  'United States': [
    Color(0xFFB22234),
    Color(0xFFFFFFFF),
    Color(0xFF3C3B6E)
  ], // red, white, blue
};
