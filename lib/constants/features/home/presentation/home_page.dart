import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/constants/strings/app_strings.dart';
import 'package:flutter/services.dart';
import 'package:xml/xml.dart';
import 'package:flutter_application_5/constants/features/home/data/airportdata.dart';
import 'package:flutter_application_5/constants/design/text/app_text.dart';
import 'package:flutter_application_5/constants/features/calculator/presentation/calculatorpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Ruta hacia la etiqueta o nodo comments para obtener los valores internos de ese nodo en Normal = <aircraft id="737-700W/CFM56-7B22"> -> <landingCondition id="NORMAL LANDING> -> <Flap id='Flaps 15' flapValue='15' label='FLAPS 15'> ->Comments
  //Ruta hacia la etiqueta o nodo de comments en Nonnormal = <aircraft id="737-700W/CFM56-7B22"-> <landingCondition id="NON-NORMAL LANDING"> -> <nonNormalConfiguration id= 'Airspeed Unreliable (Flaps 15)> -> Comments
  //Nota: Los comentarios que se traen cuando es Normal, son solo de Flap 15 y varian es por el tipo de avion solamente, si non-normal, ya es por el tipo de configuracion.
  //Nota: Los Flaps inician en 30 y el autobrake en 3 en Normal, en Non-normal varian por la configuracion el Flap y el autobrake en automatic.
  //Nota: Los reversers se mantienen en default en el 1er valor de los datos del Aeropuerto, Reversers en 0 revsr Inop y Speedbrakes en Automatic (excepto en Non-Nomral que sale N/A) en Normal y Non-Normal.
  //Nota: VREF ADD inicia por 5kt en Normal, en Non-Normal en N/A. 
  //Nota: Dependiendo de configuracion Non-Normal, el texto de Vref cambia por tener su valor dentro del nodo como VrefLabel, mismo caso para flaps como flapLabel que toma solo la parte de flap del texto.
  //Nota: Los valores en metro al lado cifras en ft son la conversion de pies a metros.
  //Noat: La conversion de pies a metros es multiplicar ft * 0.3048. Usar el metodo .round en la variable de resultado de la operacion.
   
  // Variables clave
  List<String> aircraftTypes = [];
  final List<String> landingTypes = ['Normal', 'Non-Normal'];
  List<String> configurationTypes = [];
  List<String> _comentariosNon = [];
  List<String> targetFlap = [];
  final airportTypes = Airportdata.airportNames;
  Map<String, String> elevations = Airportdata.airportElevation;
  Map<String, String> refQNH = Airportdata.airportRefQNH;
  Map<String, String> refTemp = Airportdata.airportAverageRefTemp;
  XmlDocument? _xmlDocument;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    loadXml();
  }

  Future<void> loadXml() async {
    final String xmlString = await rootBundle.loadString(
      'assets/data/tables/OpLDinfoFromTables.xml',
    );

    final XmlDocument document = XmlDocument.parse(xmlString);
    if (!mounted) return;
    final aircraftElements = document.findAllElements('aircraft');
    final configElements = document.findAllElements('nonNormalConfiguration');

    setState(() {
      _xmlDocument = document;
      aircraftTypes = aircraftElements
          .map((element) => element.getAttribute('label') ?? '')
          .where((label) => label.isNotEmpty)
          .toList();

      configurationTypes = configElements
          .map((element) => element.getAttribute('id') ?? '')
          .where((label) => label.isNotEmpty)
          .toSet()
          .toList();
      
      _isReady = true;
    });
  }

  void loadComments(){
    print('paso 3: se esta ejecutando loadComments.');
      if(_xmlDocument == null) return;
      print('paso 5: examinando condiciones');
      Iterable<XmlElement> targetFlap = [];

      if (selectedAircraftType != null && selectedLandingType != null) {
        targetFlap = _xmlDocument!
            .findAllElements('aircraft')
            .where(
              (a) =>
                  a.getAttribute('id') == selectedAircraftType ||
                  a.getAttribute('label') == selectedAircraftType,
            )
            .expand((l) => l.findAllElements('landingCondition'))
            .where(
              (lc) =>
                  lc.getAttribute('label')?.toUpperCase() ==
                  selectedLandingType?.toUpperCase(),
            )
            .expand((f) => f.findAllElements('nonNormalConfiguration'));
      }
      print('paso 6: Extrayendo comentarios de acuerdo a las condiciones.');
      if (selectedConfigurationType != null) {
        _comentariosNon = targetFlap
            .where((f) => f.getAttribute('id') == selectedConfigurationType)
            .expand((c) => c.findAllElements('Comments'))
            .map((e) => e.innerText)
            .toList();
      }
      print('paso 7: se extrajo los comentarios: $_comentariosNon');
  }

  // Selected input values
  String? selectedAircraftType = '737-700W/CFM56-7B22';
  String? selectedLandingType = 'Normal';
  String? selectedAirportType = 'PTY';
  String? selectedConfigurationType = 'Airspeed Unreliable (Flaps 15)';
  String? elevation;
  String? qnh;
  String? temperature;
  Map<String, List<String>> refRunway = {};

  void _onGoPressed() async {
    if(!_isReady) {
      return;
    }
    print(
      " paso 1: se oprimio en boton, el arreglo va vacio: ${_comentariosNon}",
    );
    print(" paso 2: se va a ejecutar la funcion loadcoments");

    loadComments();

    elevation = elevations[selectedAirportType] ?? "Unknown";
    qnh = refQNH[selectedAirportType] ?? "Unknown";
    temperature = refTemp[selectedAirportType] ?? "Unknown";
    refRunway = Airportdata.airportRunwayData(selectedAirportType); 
    //print(refRunway);
    
    print("Comentarios llegando despues del filtro $_comentariosNon");
    print(selectedAirportType);

    List<String> comentarios = [];

    for (int i = 0; i < _comentariosNon.length; i++) {
      comentarios.add(_comentariosNon[i]);
      //print(_comentariosNon[i]);
    }
    if (comentarios.isNotEmpty) {
      print(
        "La variable va lista con el contenido de los comentarios hacia calculatorpage",
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            CalculatorPage(
              comentariosNon: comentarios, aircraft: selectedAircraftType, 
              normalNon: selectedLandingType, configuration: selectedConfigurationType, 
              airport: selectedAirportType, airportEl: elevation, airportQNH: qnh, airportTemp: temperature, airportRunway: refRunway,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text(AppStrings.appHeaderHome, style: TextStyle(color: AppColors.white),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: AppColors.white, width: 2)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Aircraft Selection
                  const Text(
                    AppStrings.aircraftSection,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Aircraft Picker
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: selectedAircraftType,
                    hint: Text(
                      '737-700W/CFM56-7B22',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.placeholderDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.placeholder,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
                    items: aircraftTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: AppColors.placeholderDark),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedAircraftType = newValue;
                      });
                    },
                  ),

                  // Label Landing Selection
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      AppStrings.normalNonnormalSection,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Landing picker
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: selectedLandingType,
                    hint: const Text(
                      'Normal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.placeholderDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.placeholder,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
                    items: landingTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: AppColors.placeholderDark),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedLandingType = newValue;
                        if (newValue != 'Non-Normal') {
                          selectedConfigurationType = null;
                        }
                      });
                    },
                  ),

                  // Configuration Type
                  if (selectedLandingType == 'Non-Normal') ...[
                    const Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        AppStrings.aircraftConfig,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Configuration Picker
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      initialValue: selectedConfigurationType,
                      hint: const Text(
                        'Airspeed Unreliable (Flaps 15)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.placeholderDark,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.placeholder,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                      ),
                      items: configurationTypes.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: AppColors.placeholderDark),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedConfigurationType = newValue;
                        });
                      },
                    ),
                  ],

                  // Label Airport Selection
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      AppStrings.airportSection,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  // Airport Picker
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: selectedAirportType,
                    hint: Text(
                      'PTY',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.placeholderDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.placeholder,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                    ),
                    items: airportTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: TextStyle(color: AppColors.placeholderDark),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        selectedAirportType = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            // Boton GO para ir a la pantalla de calculadora
            Center(
              child: ElevatedButton(
                onPressed: _isReady ? _onGoPressed : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black,
                  foregroundColor: AppColors.iconDark,
                  fixedSize: const Size(150, 150),
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(200),
                    side: BorderSide(color: AppColors.iconDark, width: 1),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  AppStrings.goButton,
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 100),
            Center(
              child: OpLDAppText.regular(
                AppStrings.appVersionNumber,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
