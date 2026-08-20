import 'dart:math';
class Calculatealtitud {

  final String? elevationRef;
  final String? qnhRef;

    Calculatealtitud({ 
    this.elevationRef, this.qnhRef
    });
    
  String call() {
    if (elevationRef == null || qnhRef == null) {
      return "0";
    }

    try {
      final double elevation = double.parse(elevationRef!.trim());
      final double qnh = double.parse(qnhRef!.trim());

      final double result = elevation + 145442.15 * (1 - pow(qnh / 1013.25, 0.190263));
      
      return result.round().toString();
    } catch (e) {
      return "0"; 
    }
  }
  
} 