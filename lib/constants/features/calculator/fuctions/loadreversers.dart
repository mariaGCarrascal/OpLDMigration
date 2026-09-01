class Loadreversers{

  final List<String> valuesRef;

  Loadreversers({ 
    required this.valuesRef,
  });
    
  List<String> call() {
    List<String> reversers = [];
    String? nombre;

    try {
      final int counter = int.parse(valuesRef[16].trim());
      final int max = int.parse(valuesRef[17].trim());

    for (int i = counter; i <= max; i++) {
      nombre = '$i revsr Inop';
      reversers.add(nombre); 
    }

      return reversers;

    } catch (e) {
      return reversers = []; 
    }
  }
  
} 
