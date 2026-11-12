class Calculatetempisa{

  final String? altitudRef;
  final String? temperatureRef;
  final String? isaRef;
  final String? minRef;
  final String? maxRef;
  final String? operation;

    Calculatetempisa({ 
      this.altitudRef, this.temperatureRef, this.isaRef, this.minRef, this.maxRef, this.operation
    });


  List<String> call() {
    final List<String> results = [];
    if (temperatureRef == null || isaRef == null) {
      results.addAll(['0', '0']);
      return results;
    }

    int isa = int.parse(isaRef!.trim());
    final int min = int.parse(minRef!.trim());
    final int max = int.parse(maxRef!.trim());

    try {

      if (operation != null) {
        final String opLower = operation!.trim().toLowerCase();
        
        if (opLower == 'increment') {
          if(isa < max ) {
            isa += 1; }
        } else if (opLower == 'decrement') {
            if(isa > min) {
              isa -= 1; }
        }

      }

      final double altitud = double.parse(altitudRef!.trim());
      final double altitudRounded = altitud.roundToDouble();
      final double tempResult = (15 - (0.0019812 * (altitudRounded).round())) + (isa).toDouble().round();

      results.addAll([isa.toString(), tempResult.toString()]);

      return results;
    } catch (e) {
      return results;
    }
  }
}