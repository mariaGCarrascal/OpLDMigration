class Calculateelevationincredecre {
  final double? elevationReference;
  final double? minReference;
  final double? maxReference;
  final String? operation;

  Calculateelevationincredecre({
    this.elevationReference, this.minReference, this.maxReference,
    this.operation,
  });

  double call() {
    if (elevationReference == null) {
      return elevationReference!;
    }

    try {
      final int elevation = elevationReference!.toInt();;
      final int elevationMin = minReference!.toInt();
      final int elevationMax = maxReference!.toInt();
      int result = elevation;

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        
        if (opLower == 'increment') {
          if(result < elevationMax) {
            result += 1; 
          }
        } else if (opLower == 'decrement') {
          if(result > elevationMin) {
            result -= 1; 
          }
        }
      }

      return result.toDouble();
    } catch (e) {
      return elevationReference!;
    }
  }
}