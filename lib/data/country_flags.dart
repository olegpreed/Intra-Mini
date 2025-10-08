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
  'Angola': [const Color(0xFFd8241b), const Color.fromARGB(255, 0, 0, 0)],
  'Armenia': [
    const Color(0xFFd90012),
    const Color(0xFF0033a0),
    const Color.fromARGB(255, 242, 149, 0)
  ],
  'Australia': [const Color(0xFF00008B), const Color(0xFFFF0000)],
  'Austria': [const Color(0xFFFF0000), const Color(0xFFFFFFFF)],
  'Belgium': [
    const Color(0xFF000000),
    const Color.fromARGB(255, 77, 61, 0),
    const Color(0xFFFF0000),
  ],
  'Brazil': [
    const Color(0xFF009739),
    const Color(0xFFFFCC00),
  ],
  'Canada': [const Color(0xFFFFFFFF), const Color(0xFFFF0000)],
  'Czech Republic': [const Color(0xFFFFFFFF), const Color(0xFFFF0000), const Color(0xFF11457E)],
  'Finland': [const Color(0xFFFFFFFF), const Color(0xFF002F6C)],
  'France': [const Color(0xFF0055A4), const Color(0xFFFFFFFF), const Color(0xFFEF4135)],
  'Germany': [const Color(0xFF000000), const Color(0xFFFF0000), const Color(0xFFFFCC00)],
  'Italy': [
    const Color(0xFF008C45),
    const Color.fromARGB(255, 225, 255, 229),
    const Color(0xFFCD212A)
  ],
  'Japan': [const Color(0xFFFFFFFF), const Color(0xFFFF0000)],
  'Jordan': [
    const Color(0xFF000000),
    const Color(0xFF007A3D),
    const Color(0xFFFF0000),
  ],
  'Korea, Republic of': [
    const Color(0xFFFFFFFF),
    const Color(0xFFFF0000),
    const Color(0xFF0000FF)
  ],
  'Lebanon': [const Color(0xFFFFFFFF), const Color(0xFFFF0000), const Color(0xFF007A3D)],
  'Luxembourg': [const Color(0xFFFF0000), const Color(0xFFFFFFFF), const Color(0xFF00A2E8)],
  'Madagascar': [const Color(0xFFFFFFFF), const Color(0xFFFF0000), const Color(0xFF008000)],
  'Malaysia': [const Color(0xFF010066), const Color(0xFFFF0000), const Color(0xFFFFFFFF)],
  'Moldova, Republic of': [
    const Color(0xFF0033A0),
    const Color(0xFFFFCC00),
    const Color(0xFFDA291C)
  ],
  'Morocco': [const Color(0xFFFF0000), const Color(0xFF006233)],
  'Netherlands': [const Color(0xFFFF0000), const Color(0xFFFFFFFF), const Color(0xFF21468B)],
  'Palestine, State of': [
    const Color(0xFF000000),
    const Color(0xFFFFFFFF),
    const Color(0xFF007A3D),
    const Color(0xFFFF0000)
  ],
  'Poland': [const Color(0xFFFFFFFF), const Color(0xFFFF0000)],
  'Portugal': [
    const Color(0xFF006600),
    const Color(0xFFFF0000),
  ],
  'Romania': [const Color(0xFF002B7F), const Color(0xFFFFCC00), const Color(0xFFCE1126)],
  'Russian Federation': [
    const Color(0xFFFFFFFF),
    const Color(0xFF0000FF),
    const Color(0xFFFF0000)
  ],
  'Singapore': [const Color(0xFFFF0000), const Color(0xFFFFFFFF)],
  'South Africa': [
    const Color(0xFF007847),
    const Color(0xFFFFB612),
    const Color(0xFFDE3831),
    const Color(0xFF002395)
  ],
  'Spain': [const Color(0xFFFF0000), const Color(0xFFFFCC00)],
  'Switzerland': [const Color(0xFFFFFFFF), const Color(0xFFFF0000)],
  'Thailand': [const Color(0xFF000066), const Color(0xFFFF0000)],
  'Turkey': [
    const Color(0xFFFF0000),
    const Color(0xFFFFFFFF),
  ],
  'Ukraine': [const Color(0xFF0057B7), const Color(0xFFFFCC00)],
  'United Arab Emirates': [
    const Color(0xFFFF0000),
    const Color(0xFF00732F),
    const Color(0xFF000000)
  ],
  'United Kingdom': [
    const Color(0xFF00247D),
    const Color(0xFFCF142B),
  ],
  'United States': [
    const Color(0xFF3C3B6E),
    const Color(0xFFFFFFFF),
    const Color(0xFFB22234),
  ],
};
