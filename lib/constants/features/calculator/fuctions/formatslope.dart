class Formatslope{

  final String? slopeRef;
  final String? airportRef;

    Formatslope({ 
      this.slopeRef, this.airportRef
    });
    
  String call() {
    try {
      final number = double.tryParse(slopeRef ?? '');
      if (number == null) return slopeRef ?? '0';

      if (number % 1 == 0) {
        return number.toInt().toString();
      }

      return airportRef != 'XXX'
          ? number.toStringAsFixed(2)
          : number.toString();

    } catch (e) {
      return '0'; 
    }
  }
  
}