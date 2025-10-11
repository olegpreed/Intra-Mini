import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:forty_two_planet/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableText extends StatelessWidget {
  const ClickableText({super.key, required this.text, required this.style});
  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: _buildTextSpans(text, context),
    );
  }

  TextSpan _buildTextSpans(String text, BuildContext context) {
    // Regular expression to find URLs in the text
    final RegExp urlRegExp = RegExp(
      r'(?:(?:https?://|www\.)[^\s]+)',
      caseSensitive: false,
      multiLine: false,
    );

    Color? accentColor = context.myTheme.intra;

    // Split the text by URLs and build TextSpan
    final List<TextSpan> spans = [];
    final List<String> parts = text.split(urlRegExp);
    final Iterable<Match> matches = urlRegExp.allMatches(text);

    // Add text spans for parts and URLs
    for (int i = 0; i < parts.length; i++) {
      // Add the non-link text
      spans.add(
          TextSpan(text: parts[i], style: style)); // Use the provided style

      // Add the link text
      if (i < matches.length) {
        final url = matches.elementAt(i).group(0);
        spans.add(
          TextSpan(
            text: url,
            style: style.copyWith(
              color: accentColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                if (url != null) {
                  final uri = Uri.tryParse(url); // Convert String to Uri
                  if (uri != null && await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    throw 'Could not launch $url';
                  }
                }
              },
          ),
        );
      }
    }

    return TextSpan(children: spans);
  }
}
