import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/constants/strings/app_strings.dart';
import 'package:xml/xml.dart';
import 'package:flutter_application_5/constants/features/home/data/airportdata.dart';
import 'package:flutter_application_5/constants/design/text/app_text.dart';
import 'package:flutter_application_5/constants/features/calculator/presentation/calculatorpage.dart';
import 'package:flutter_application_5/service_dataxml/opldservice.dart';
 
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
  //Nota: VREF ADD inicia por 5kt en Normal y tiene limite de 0 a 30, en Non-Normal en N/A cuando solo son los 3 de Airspeed Unreliable.
  //Nota: Dependiendo de configuracion Non-Normal, el texto de Vref cambia por tener su valor dentro del nodo como VrefLabel, mismo caso para flaps como flapLabel que toma solo la parte de flap del texto.
  //Nota: Los valores en metro al lado cifras en ft son la conversion de pies a metros.
  //Noat: La conversion de pies a metros es multiplicar ft * 0.3048. Usar el metodo .round en la variable de resultado de la operacion.
  //Nota: la reduccion solo permite 5 digitos si son 0, pero si tiene valor que no sea 0 al inicio solo permite 4 digitos
 
  // Variables clave de listas
  List<String> aircraftTypes = [];
  final List<String> landingTypes = ['Normal', 'Non-Normal'];
  List<String> configurationTypes = [];
  List<String> _flapsNon = [];
  List<String> targetFlap = [];
  List<String> targetConfig = [];
  final airportTypes = Airportdata.airportNames;
  Map<String, String> elevations = Airportdata.airportElevation;
  Map<String, String> refQNH = Airportdata.airportRefQNH;
  Map<String, String> refTemp = Airportdata.airportAverageRefTemp;
  Map<String, List<String>> refRunway = {};
  XmlDocument? _xmlDocument;
  //Variables clave
  String? elevation;
  String? qnh;
  String? temperature;
  bool _isReady = false;
  String? selectedAircraftType = '737-700W/CFM56-7B22';
  String? selectedLandingType = 'Normal';
  String? selectedAirportType = 'PTY';
  String? selectedConfigurationType;
  String? selectedConfigurationFlap;
 
  @override
  void initState() {
    super.initState();
    loadXml();
  }
 
  Future<void> loadXml() async {
    final XmlDocument document = OpLdService.instance.document;
    if (!mounted) return;
    final aircraftElements = document.findAllElements('aircraft');
 
    setState(() {
      _xmlDocument = document;
      aircraftTypes = aircraftElements
          .map((element) => element.getAttribute('label') ?? '')
          .where((label) => label.isNotEmpty)
          .toList();
 
      loadConfig();
 
      _isReady = true;
    });
  }
 
  void searchFlaps() {
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
 
    if (selectedConfigurationType != null) {
      _flapsNon = targetFlap
          .where((f) => f.getAttribute('id') == selectedConfigurationType)
          .map((e) => e.getAttribute('flapLabel'))
          .where((label) => label != null)
          .cast<String>()
          .toList();
    }
  }
 
  void loadConfig() {
    if (_xmlDocument == null || selectedAircraftType == null) {
      return;
    }
 
    final targetConfig = _xmlDocument!
        .findAllElements('aircraft')
        .where(
          (a) =>
              a.getAttribute('id') == selectedAircraftType ||
              a.getAttribute('label') == selectedAircraftType,
        )
        .expand((aircraft) => aircraft.findAllElements('landingCondition'))
        .where((lc) => lc.getAttribute('label')?.toUpperCase() == 'NON-NORMAL')
        .expand((lc) => lc.findAllElements('nonNormalConfiguration'))
        .map((e) => e.getAttribute('longLabel'))
        .whereType<String>()
        .toSet()
        .toList();
 
    configurationTypes = targetConfig;
 
    if (configurationTypes.isNotEmpty) {
      selectedConfigurationType = configurationTypes.first;
      searchFlaps();
    } else {
      selectedConfigurationType = null;
      _flapsNon.clear();
    }
  }
 
  void _onGoPressed() async {
    if (!_isReady) {
      return;
    }
 
    elevation = elevations[selectedAirportType] ?? "Unknown";
    qnh = refQNH[selectedAirportType] ?? "Unknown";
    temperature = refTemp[selectedAirportType] ?? "Unknown";
    refRunway = Airportdata.airportRunwayData(selectedAirportType);
    if (selectedLandingType == 'Non-Normal' && _flapsNon.isNotEmpty) {
      selectedConfigurationFlap = _flapsNon.first;
    }
 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CalculatorPage(
          aircraft: selectedAircraftType,
          normalNon: selectedLandingType,
          configuration: selectedConfigurationType,
          airport: selectedAirportType,
          airportEl: elevation,
          airportQNH: qnh,
          airportTemp: temperature,
          airportRunway: refRunway,
          nonflaps: selectedConfigurationFlap,
        ),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text(
          AppStrings.appHeaderHome,
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: AppColors.borderHomeDropdowns,
                    width: 2,
                  ),
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
                        fontSize: 25,
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
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.placeholder,
                            width: 1,
                          ),
                        ),
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
                          selectedConfigurationType = null;
                          selectedConfigurationFlap = null;
                          _flapsNon.clear();
                          loadConfig();
                        });
                        if (selectedLandingType == 'Non-Normal') {
                          loadConfig();
                        }
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
                          fontSize: 25,
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
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.placeholder,
                            width: 1,
                          ),
                        ),
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
                          selectedConfigurationType = null;
                          selectedConfigurationFlap = null;
                          _flapsNon.clear();
                          if (newValue != 'Non-Normal') {
                            configurationTypes.clear();
                          }
                        });
                        if (newValue == 'Non-Normal') {
                          loadConfig();
                        }
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
                            fontSize: 25,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      // Configuration Picker
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        initialValue:
                            configurationTypes.contains(
                              selectedConfigurationType,
                            )
                            ? selectedConfigurationType
                            : null,
                        hint: const Text(
                          'Seleccionar una configuracion',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.placeholderDark,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.placeholder,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.placeholder,
                              width: 1,
                            ),
                          ),
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
                              style: TextStyle(
                                color: AppColors.placeholderDark,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedConfigurationType = newValue;
                            searchFlaps();
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
                          fontSize: 25,
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
                          fontSize: 25,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.placeholder,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.placeholder,
                            width: 1,
                          ),
                        ),
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
            ],
          ),
          Positioned(
            bottom: 0,
            child: OpLDAppText.regular(
              AppStrings.appVersionNumber,
              color: AppColors.placeholder,
            ),
          ),
        ],
      ),
    );
  }
}