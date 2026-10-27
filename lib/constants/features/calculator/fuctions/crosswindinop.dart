class Crosswindinop {
  final Map<String, String>? dataMap;
  final List<String>? conditionList;

  Crosswindinop({
    this.dataMap,
    this.conditionList
  });

  Map<String, String> call() {
    Map<String, String> updatedMap = Map<String, String>.from(dataMap!);

    try {
      for (final condition in conditionList!) {
        final String index = condition.trim();

        if(condition != 'DRY') {
          if (updatedMap.containsKey(index)) {
            final String? rawValue = updatedMap[index];

            if (rawValue != null && rawValue.trim().isNotEmpty) {
              final int? numericValue = int.tryParse(rawValue.trim());

              if (numericValue != null) {
                final int newValue = numericValue - 5;
                updatedMap[index] = newValue.toString();
              }
            }
          }
        }
      }

      return updatedMap;
    } catch (e) {
      return updatedMap;
    }
  }
}