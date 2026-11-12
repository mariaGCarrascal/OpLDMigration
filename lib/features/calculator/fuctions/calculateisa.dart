class Calculateisa{

  final String? elevationRef;
  final String? temperatureRef;

    Calculateisa({ 
    this.elevationRef, this.temperatureRef
    });
    
  String call() {
    if (elevationRef == null || temperatureRef == null) {
      return "0";
    }

    try {
      final double elevation = double.parse(elevationRef!.trim());
      final double temperature = double.parse(temperatureRef!.trim());
      final double tempRounded = temperature.roundToDouble();
      final double elevationRounded = elevation.roundToDouble();

      final double result = tempRounded - 15 + (0.0019812 * elevationRounded);

      return result.round().toString();
    } catch (e) {
      return "0"; 
    }
  }
  
} 