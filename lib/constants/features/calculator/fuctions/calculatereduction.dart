class Calculatereduction{

  final String? netRef;
  final String? reductionRef;
  final String? ldaRef;

    Calculatereduction({ 
    this.netRef, this.ldaRef, this.reductionRef
    });
    
  String call() {
    if (reductionRef == null) {
      return "$ldaRef";
    }

    try {
      final int netlda = int.parse(netRef!.trim());
      final int reduction = int.parse(reductionRef!.trim());

      final int result = (reduction - netlda).abs();

      return result.round().toString();
    } catch (e) {
      return "$ldaRef"; 
    }
  }
  
} 
