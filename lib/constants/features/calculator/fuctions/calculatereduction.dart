class Calculatereduction{

  final String? reductionRef;
  final String? ldaRef;

    Calculatereduction({ 
      this.ldaRef, this.reductionRef
    });
    
  String call() {
    if (reductionRef == null) {
      return "$ldaRef";
    }

    try {
      final int lda = int.parse(ldaRef!.trim());
      final int reduction = int.parse(reductionRef!.trim());

      final int result = (lda - (reduction * 3.28084).round());

      return result.round().toString();
    } catch (e) {
      return "$ldaRef"; 
    }
  }
  
} 
