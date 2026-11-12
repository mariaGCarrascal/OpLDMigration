class Calculatevrefincredecre {
  final String? vReference;
  final String? minReference;
  final String? maxReference;
  final String? operation;

  Calculatevrefincredecre({
    this.vReference, this.minReference, this.maxReference,
    this.operation,
  });

  String call() {
    if (vReference == null) {
      return "5";
    }

    try {
      final int speed = int.parse(vReference!.trim());
      final int speedMin = int.parse(minReference!.trim());
      final int speedMax = int.parse(maxReference!.trim());
      int result = speed;

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        
        if (opLower == 'increment') {
          if(result < speedMax) {
            result += 1; 
          }
        } else if (opLower == 'decrement') {
          if(result > speedMin) {
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