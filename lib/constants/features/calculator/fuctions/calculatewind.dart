import 'dart:math' as math;

class Calculatewind{

  final String? rwyidRef;
  final String? windRef;
  final String? windpickerRef;
  final String? operation;

    Calculatewind({ 
      this.rwyidRef, this.windRef, this.windpickerRef, this.operation,
    });
    
  List <String> call() {
    List<String> results = [];

    if (rwyidRef == null || windRef == null || windpickerRef == null) {
      results.addAll(['0', '0', '0']);
      return results;
    }

    int windInput = int.parse(windRef!.trim());
    final double rwyHdg = double.parse(rwyidRef!.trim());
    final double windDir = double.parse(windpickerRef!.trim());
    final double radianes = (rwyHdg - windDir) * (math.pi / 180.0);

    if (operation != null) {
      final String opLower = operation!.trim().toLowerCase();
        
      if (opLower == 'increment') {
          windInput += 1; 

        } else if (opLower == 'decrement') {
          if(windInput > 0) {
            windInput -= 1; 
          }
        }
    }

    try {

      double windTagVal = (windInput * math.cos(radianes)).round().toDouble();
      double crossWindVal = (windInput * math.sin(radianes)).round().toDouble();
      String headtailVal = windTagVal.toString();
      String crossWind = crossWindVal.toString();

      results.addAll(['$windInput', headtailVal, crossWind]);
        
      return results;
    } catch (e) {
      return results = []; 
    }
  }
  
} 
