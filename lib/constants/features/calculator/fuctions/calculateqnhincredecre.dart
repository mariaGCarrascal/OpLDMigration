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

        if (result == 1013.3) {
          result = 1013.25;
          
        } else if (result == 1013.25) {
          result = 1013.2;

        } else {
          
          if (opLower == 'increment') {
            result = result + 0.1;
          } else if (opLower == 'decrement') {
            result = result - 0.1;
          }
        }
      }

      return result.toStringAsFixed(1);
      
    } catch (e) {
      return "0";
    }
  }
}