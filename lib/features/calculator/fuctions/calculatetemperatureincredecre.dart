class Calculatetemperatureincredecre {
  final String? temperatureRef;
  final String? isaRef;
  final String? minRef;
  final String? maxRef;
  final String? operation;

  Calculatetemperatureincredecre({
    this.temperatureRef, this.isaRef, this.minRef, this.maxRef,
    this.operation,
  });

  String call() {
    if (temperatureRef == null) {
      return "0";
    }

    try {
      final double temperature = double.parse(temperatureRef!.trim());
      final double isa = double.parse(isaRef!.trim());
      final double min = double.parse(minRef!.trim());
      final double max = double.parse(maxRef!.trim());
      double result = temperature.roundToDouble();

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        
        if (opLower == 'increment') {
          if(isa < max ) {
            result += 1.0; }
        } else if (opLower == 'decrement') {
            if(isa > min) {
              result -= 1.0; }
        }

      }

      return result.round().toString();
    } catch (e) {
      return "0";
    }
  }
}