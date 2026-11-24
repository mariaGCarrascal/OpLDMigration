class Calculateisa{

  final String? altitudRef;
  final String? temperatureRef;

    Calculateisa({ 
    this.altitudRef, this.temperatureRef
    });
    
  String call() {
    if (altitudRef == null || temperatureRef == null) {
      return "0";
    }

    try {
      final double altitud = double.parse(altitudRef!.trim());
      final double temperature = double.parse(temperatureRef!.trim());
      final double tempRounded = temperature.roundToDouble();
      final double altitudRounded = altitud.roundToDouble();

      final double result = tempRounded - 15 + (0.0019812 * altitudRounded);

      return result.round().toString();
    } catch (e) {
      return "0"; 
    }
  }
  
} 