class Formatslope{

  final String? slopeRef;

    Formatslope({ 
      this.slopeRef
    });
    
  String call() {
    try {
      final number = double.tryParse(slopeRef ?? '');
      if (number == null) return slopeRef ?? '0';
      return number == number.toInt() ? number.toInt().toString() : number.toString();
    } catch (e) {
      return '0'; 
    }
  }
  
}