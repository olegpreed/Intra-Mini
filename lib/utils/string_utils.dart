String formatKind(String input) {
        String withSpaces = input.replaceAll('_', ' ');
        if (withSpaces.isNotEmpty) {
          return withSpaces[0].toUpperCase() + withSpaces.substring(1);
        }
        return withSpaces;
      }