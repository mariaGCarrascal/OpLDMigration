class Qnhconverter {
  static int? toHpa(String qnhRaw) {
    if (qnhRaw.isEmpty) return null;

    final prefix = qnhRaw[0].toUpperCase();
    final numberPart = qnhRaw.substring(1);

    if (prefix == 'Q') {
      return int.tryParse(numberPart);
    } else if (prefix == 'A') {
      //Viene en inHg x 100 (ej: A3004 -> 30.04 inHg)
      final val = double.tryParse(numberPart);
      if (val != null) {
        final inHg = val / 100;
        final hpa = inHg * 33.86389;
        return hpa.round();
      }
    }

    return null;
  }

  static String toQnhString(String qnhRaw) {
    final hpa = toHpa(qnhRaw);
    return hpa != null ? '$hpa' : qnhRaw;
  }
}