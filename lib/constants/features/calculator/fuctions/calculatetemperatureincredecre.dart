class Calculatetemperatureincredecre {
  final String? temperatureRef;
  final String? operation;

  Calculatetemperatureincredecre({
    this.temperatureRef,
    this.operation,
  });

  String call() {
    if (temperatureRef == null) {
      return "0";
    }

    try {
      final double temperature = double.parse(temperatureRef!.trim());
      double result = temperature.roundToDouble();

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        
        if (opLower == 'increment') {
          result += 1.0; 
        } else if (opLower == 'decrement') {
          result -= 1.0; 
        }
      }

      return result.round().toString();
    } catch (e) {
      return "0";
    }
  }
}