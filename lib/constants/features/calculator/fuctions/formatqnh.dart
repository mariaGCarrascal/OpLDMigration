class Formatqnh{
  final String? qnhRef;

  const Formatqnh({this.qnhRef});

  String call() {
    try {
      final input = qnhRef?.trim() ?? '';
      final number = double.tryParse(input);

      if (number == null) return input;

      if (number % 1 == 0) {
        return number.toInt().toString();
      }

      return number.toString();
    } catch (e) {
      return qnhRef!;
    }
  }
}