class Loadreversers{

  final List<String> valuesRef;

  Loadreversers({ 
    required this.valuesRef,
  });
    
  List<String> call() {
    List<String> reversers = [];
    String? nombre;
    //String? counter;
    //String? max;

    try {
      final int counter = int.parse(valuesRef[16].trim());
      final int max = int.parse(valuesRef[17].trim());
      //counter = valuesRef?[16];
      //max = valuesRef?[17];
      //int.parse(counter!.trim());
      //int.parse(max!.trim());


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
