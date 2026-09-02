class Calculateqnhincredecre {
  final String? qnhRef;
  final String? operation;

  Calculateqnhincredecre({
    this.qnhRef,
    this.operation,
  });

  String call() {
    if (qnhRef == null) {
      return "0";
    }

    try {
      double result = double.parse(qnhRef!.trim());

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        final double diff1013_4 = (result - 1013.4).abs();
        final double diff1013_3 = (result - 1013.3).abs();
        final double diff1013_25 = (result - 1013.25).abs();
        final double diff1013_2 = (result - 1013.2).abs();

        if (opLower == 'increment') {
          if (diff1013_2 < 0.001) {
            result = 1013.25;
          } else if (diff1013_25 < 0.001) {
            result = 1013.3;
          } else if (diff1013_3 < 0.001) {
            result = 1013.4;
          } else {
            result = result + 0.1;
          }
        } else if (opLower == 'decrement') {
          if (diff1013_4 < 0.001) {
            result = 1013.3;
          } else if (diff1013_3 < 0.001) {
            result = 1013.25;
          } else if (diff1013_25 < 0.001) {
            result = 1013.2;
          } else {
            result = result - 0.1;
          }
        }
      }

      if ((result - 1013.25).abs() < 0.001) {
        return "1013.25";
      }

      return double.parse(result.toStringAsFixed(2)).toStringAsFixed(1);
      
    } catch (e) {
      return "0";
    }
  }
}