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

      if (airportRef != 'XXX') {
        return number.toStringAsFixed(2);
      }

      return number == number.toInt() ? number.toInt().toString() : number.toString();
    } catch (e) {
      return '0'; 
    }
  }
  
}