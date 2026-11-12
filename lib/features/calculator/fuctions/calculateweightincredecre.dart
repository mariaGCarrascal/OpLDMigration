class Calculateweightincredecre {
  final double? weightReference;
  final double? minReference;
  final double? maxReference;
  final String? operation;

  Calculateweightincredecre({
    this.weightReference, this.minReference, this.maxReference,
    this.operation,
  });

  double call() {
    if (weightReference == null) {
      return weightReference!;
    }
  
    try {
      final int weight = weightReference!.toInt();
      final int min = minReference!.toInt();
      final int max = maxReference!.toInt();
      int result = weight;

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        
        if (opLower == 'increment') {
          if(result < max) {
            result += 100; 
          }
        } else if (opLower == 'decrement') {
          if(result > min) {
            result -= 100; 
          }
        }
      }

      return result.toDouble();
    } catch (e) {
      return weightReference!;
    }
  }
}