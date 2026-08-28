class Calculateslopeincredecre {
  final String? slopeReference;
  final String? minReference;
  final String? maxReference;
  final String? operation;

  Calculateslopeincredecre({
    this.slopeReference, 
    this.minReference, 
    this.maxReference,
    this.operation,
  });

  String call() {
    if (slopeReference == null) {
      return "0.0";
    }

    try {
      final double slope = double.parse(slopeReference!.trim());
      final double slopeMin = double.parse(minReference!.trim());
      final double slopeMax = double.parse(maxReference!.trim());
      double result = slope;

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        
        if (opLower == 'increment') {
          if (result < slopeMax) {
            result += 0.1; 
          } 
        } else if (opLower == 'decrement') {
          if (result > slopeMin) {
            result -= 0.1; 
          } 
        }
      }

      result = double.parse(result.toStringAsFixed(1));

      return result.toString();
    } catch (e) {
      return "0.0";
    }
  }
}