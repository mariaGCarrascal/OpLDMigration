class OatConverter {
  static int? toCelsius(String oatRaw) {
    if (oatRaw.isEmpty) return null;

    final parts = oatRaw.trim().split('/');
    if (parts.isEmpty || parts[0].isEmpty) return null;

    final tempString = parts[0].toUpperCase();

    if (tempString.startsWith('M')) {
      final numericPart = tempString.substring(1);
      final value = int.tryParse(numericPart);
      return value != null ? -value : null;
    }

    return int.tryParse(tempString);
  }

  static String toCleanString(String oatRaw) {
    final temp = toCelsius(oatRaw);
    return temp != null ? '$temp' : '';
  }
}