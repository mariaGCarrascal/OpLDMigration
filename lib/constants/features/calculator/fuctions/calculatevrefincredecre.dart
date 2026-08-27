class Calculatevrefincredecre {
  final String? vReference;
  final String? operation;

  Calculatevrefincredecre({
    this.vReference,
    this.operation,
  });

  String call() {
    if (vReference == null) {
      return "5";
    }

    try {
      final int speed = int.parse(vReference!.trim());
      int result = speed;

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        
        if (opLower == 'increment') {
          if(result < 30) {
            result += 1; 
          }
        } else if (opLower == 'decrement') {
          if(result > 0) {
            result -= 1; 
          }
        }
      }

      return result.toString();
    } catch (e) {
      return "5";
    }
  }
}