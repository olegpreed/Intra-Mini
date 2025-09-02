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
  'Korea, Republic of': '🇰🇷',
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
  'Angola': [Color(0xFFd8241b), Color.fromARGB(255, 0, 0, 0)],
  'Armenia': [
    Color(0xFFd90012),
    Color(0xFF0033a0),
    Color.fromARGB(255, 242, 149, 0)
  ],
  'Australia': [Color(0xFF00008B), Color(0xFFFF0000)],
  'Austria': [Color(0xFFFF0000), Color(0xFFFFFFFF)],
  'Belgium': [
    Color(0xFF000000),
    Color.fromARGB(255, 77, 61, 0),
    Color(0xFFFF0000),
  ],
  'Brazil': [
    Color(0xFF009739),
    Color(0xFFFFCC00),
  ],
  'Canada': [Color(0xFFFFFFFF), Color(0xFFFF0000)],
  'Czech Republic': [Color(0xFFFFFFFF), Color(0xFFFF0000), Color(0xFF11457E)],
  'Finland': [Color(0xFFFFFFFF), Color(0xFF002F6C)],
  'France': [Color(0xFF0055A4), Color(0xFFFFFFFF), Color(0xFFEF4135)],
  'Germany': [Color(0xFF000000), Color(0xFFFF0000), Color(0xFFFFCC00)],
  'Italy': [
    Color(0xFF008C45),
    Color.fromARGB(255, 225, 255, 229),
    Color(0xFFCD212A)
  ],
  'Japan': [Color(0xFFFFFFFF), Color(0xFFFF0000)],
  'Jordan': [
    Color(0xFF000000),
    Color(0xFF007A3D),
    Color(0xFFFF0000),
  ],
  'Korea, Republic of': [
    Color(0xFFFFFFFF),
    Color(0xFFFF0000),
    Color(0xFF0000FF)
  ],
  'Lebanon': [Color(0xFFFFFFFF), Color(0xFFFF0000), Color(0xFF007A3D)],
  'Luxembourg': [Color(0xFFFF0000), Color(0xFFFFFFFF), Color(0xFF00A2E8)],
  'Madagascar': [Color(0xFFFFFFFF), Color(0xFFFF0000), Color(0xFF008000)],
  'Malaysia': [Color(0xFF010066), Color(0xFFFF0000), Color(0xFFFFFFFF)],
  'Moldova, Republic of': [
    Color(0xFF0033A0),
    Color(0xFFFFCC00),
    Color(0xFFDA291C)
  ],
  'Morocco': [Color(0xFFFF0000), Color(0xFF006233)],
  'Netherlands': [Color(0xFFFF0000), Color(0xFFFFFFFF), Color(0xFF21468B)],
  'Palestine, State of': [
    Color(0xFF000000),
    Color(0xFFFFFFFF),
    Color(0xFF007A3D),
    Color(0xFFFF0000)
  ],
  'Poland': [Color(0xFFFFFFFF), Color(0xFFFF0000)],
  'Portugal': [
    Color(0xFF006600),
    Color(0xFFFF0000),
  ],
  'Romania': [Color(0xFF002B7F), Color(0xFFFFCC00), Color(0xFFCE1126)],
  'Russian Federation': [
    Color(0xFFFFFFFF),
    Color(0xFF0000FF),
    Color(0xFFFF0000)
  ],
  'Singapore': [Color(0xFFFF0000), Color(0xFFFFFFFF)],
  'South Africa': [
    Color(0xFF007847),
    Color(0xFFFFB612),
    Color(0xFFDE3831),
    Color(0xFF002395)
  ],
  'Spain': [Color(0xFFFF0000), Color(0xFFFFCC00)],
  'Switzerland': [Color(0xFFFFFFFF), Color(0xFFFF0000)],
  'Thailand': [Color(0xFF000066), Color(0xFFFF0000)],
  'Turkey': [
    Color(0xFFFF0000),
    Color(0xFFFFFFFF),
  ],
  'Ukraine': [Color(0xFF0057B7), Color(0xFFFFCC00)],
  'United Arab Emirates': [
    Color(0xFFFF0000),
    Color(0xFF00732F),
    Color(0xFF000000)
  ],
  'United Kingdom': [
    Color(0xFF00247D),
    Color(0xFFCF142B),
  ],
  'United States': [
    Color(0xFF3C3B6E),
    Color(0xFFFFFFFF),
    Color(0xFFB22234),
  ],
};
