import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculateAltitud.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculateelevationincredecre.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculateisa.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculateqnhincredecre.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculatereduction.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculateslopeincredecre.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculatetemperatureincredecre.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculatevrefincredecre.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculateweightincredecre.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/customDigitFormatter.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/loadautobrakes.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/loadcomments.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/loadreversers.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/searchautobrakedefault.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/searchdefault.dart';
import 'package:flutter_application_5/constants/features/home/data/airportdata.dart';
import 'package:flutter_application_5/constants/strings/app_strings.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {

  final String? aircraft;
  final String? normalNon;
  final String? configuration;
  final String? airport;
  final String? airportEl;
  final String? airportQNH;
  final String? airportTemp;
  final Map<String, List<String>>? airportRunway;
  final String? nonflaps;
  const CalculatorPage({
    super.key, 
    this.aircraft, this.normalNon, this.configuration, 
    this.airport, this.airportEl, this.airportQNH, this.airportTemp, this.airportRunway, this.nonflaps
  });
//Pendientes:
//Buscar solucion cuando se presiona el boton de suma y resta que cambia la variable de altitud en QNH, de momento se paraliza.
//Cambiar la visual del card results juntandolo y usar Divider.
//Calculo de Vientos y traer/usar valores default, min y max de viento.
//Traer los datos para los calculos que dan resultado del OpLD performance y el calculo de remaing a final (netLDA - opldResults)
//Logica de cambio de colores en el OpLD.

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  //Variables para las selecciones 
  int _counter = 0;
  //Nota la reduccion solo permite 5 digitos si son 0, pero si tiene valor que no sea 0 al inicio solo permite 4 digitos
  String? _currentReduction;
  String? netLDA;
  String? opldResult;
  String? remainingResult;
  late double _currentLadWeight;
  late double _currentElevation;
  double? altitudMax;
  double? altitudMin;
  late double sliderMin;
  late double sliderMax;
  int? _divisions;
  String? isa;
  String? selectedRunway;
  String? selectedMag;
  String? selectedWind;
  String? selectedAircraft;
  String? selectedLanding;
  String? selectedAirport;
  String? selectedConfiguration;
  String? selectedAirportElevation;
  String? selectedFlaps;
  String? selectedReversers;
  String? selectedAutoBrake;
  String? selectedAirportQNH;
  String? selectedAirportTemperature;
  String? selectedCondition;
  String? nonFlap;
  String? selectedSpeedBrakeType = 'AUTOMATIC';
  String? rwyRcc;
  String? rwyId;
  String? rwySlope;
  String? rwySlopeMin;
  String? rwySlopeMax;
  String? rwyLda;
  String? vRef;
  String? vMax;
  String? vMin;
  String? isaMax;
  String? isaMin;
  late double weightMIN;
  late double weightMAX;
  String? altitud;
  bool _isExpanded = false;
  //Variables de listas y Maps de los DropDownlists
  List<String>? listaComments = [];
  List<String>? weightsAircraft = [];
  List<String>? defaultAircraft = [];
  Map<String, List<String>>? selectedAirportRunway;
  List<String>? selectedSlopeValues = [];
  List<String>? selectedAircraftWeight = [];
  final List<String> normalFlaps = ['FLAPS 15', 'FLAPS 30', 'FLAPS 40'];
  List<String>? reversersList = [];
  List<String>? autoBrakeOptions;
  final List<String> speedBrakesTypes = ['AUTOMATIC', 'MANUAL'];
  final List<String> rwyConditions = ['DRY', 'GOOD', 'GOOD TO MEDIUM', 'MEDIUM', 'MEDIUM TO POOR', 'POOR'];
  final List<String> rwymagOptions = ['000', '001', '002', '003', '004', '005', '006', '007', '008', '009', '010',
                                      '011', '012', '013', '014', '015', '016', '017', '018', '019', '020', '021',
                                      '022', '023', '024', '025', '026', '027', '028', '029', '030', '031', '032',
                                      '033', '034', '035', '036', '037', '038', '039', '040', '041', '042', '043',
                                      '044', '045', '046', '047', '048', '049', '050', '051', '052', '053', '054',
                                      '055', '056', '057', '058', '059', '060', '061', '062', '063', '064', '065',
                                      '066', '067', '068', '069', '070', '071', '072', '073', '074', '075', '076',
                                      '077', '078', '079', '080', '081', '082', '083', '084', '085', '086', '087',
                                      '088', '089', '090', '091', '092', '093', '094', '095', '096', '097', '098',
                                      '099', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109',
                                      '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120',
                                      '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131',
                                      '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142',
                                      '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153',
                                      '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164',
                                      '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175',
                                      '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186',
                                      '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197',
                                      '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208',
                                      '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219',
                                      '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230',
                                      '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241',
                                      '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252',
                                      '253', '254', '255', '256', '257', '258', '259', '260', '261', '262', '263',
                                      '264', '265', '266', '267', '268', '269', '270', '271', '272', '273', '274',
                                      '275', '276', '277', '278', '279', '280', '281', '282', '283', '284', '285',
                                      '286', '287', '288', '289', '290', '291', '292', '293', '294', '295', '296',
                                      '297', '298', '299', '300', '301', '302', '303', '304', '305', '306', '307',
                                      '308', '309', '310', '311', '312', '313', '314', '315', '316', '317', '318',
                                      '319', '320', '321', '322', '323', '324', '325', '326', '327', '328', '329',
                                      '330', '331', '332', '333', '334', '335', '336', '337', '338', '339', '340',
                                      '341', '342', '343', '344', '345', '346', '347', '348', '349', '350', '351',
                                      '352', '353', '354', '355', '356', '357', '358', '359', '360'
  ];
  final List<String> windDirection = ['000', '010', '020', '030', '040', '050', '060', '070', '080', '090', '100',
                                      '110', '120', '130', '140', '150', '160', '170', '180', '190', '200', '210',
                                      '220', '230', '240', '250', '260', '270', '280', '290', '300', '310', '320',
                                      '330', '340', '350', '360'];
  Map<String, List<String>> conditionNotes = Airportdata.rcaTable;
  List<String>? rwyNote = [];

  @override
  void initState() {
    super.initState();
    selectedAircraft = widget.aircraft;
    defaultAircraft = Searchdefault(aircraftRef: selectedAircraft)();
    selectedCondition = defaultAircraft?[19];
    updateRwyCondition('$selectedCondition');
    _currentLadWeight = double.parse(defaultAircraft?[4] ?? '0');
    weightMAX = double.parse(defaultAircraft?[5] ?? '0');
    weightMIN = double.parse(defaultAircraft?[6] ?? '0');
    isaMin = defaultAircraft?[13];
    isaMax = defaultAircraft?[14];
    selectedLanding = widget.normalNon;
    selectedConfiguration = widget.configuration;
    selectedAirport = widget.airport;
    selectedAirportQNH = widget.airportQNH;
    reversersList = Loadreversers(valuesRef: defaultAircraft!)();
    
    if(selectedLanding == 'Normal') {
      selectedFlaps = defaultAircraft?[1];
      listaComments = Loadcomments(aircraftRef: selectedAircraft, landingRef: selectedLanding,configurationRef: selectedConfiguration, flapRef: selectedFlaps)();
      selectedAutoBrake = defaultAircraft?[2];
      autoBrakeOptions = Loadautobrakes(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration, flapRef: selectedFlaps, conditionRef: selectedCondition)();
    } else {
      selectedFlaps = widget.nonflaps;
      nonFlap = widget.nonflaps;
      listaComments = Loadcomments(aircraftRef: selectedAircraft, landingRef: selectedLanding,configurationRef: selectedConfiguration, flapRef: selectedFlaps)();
      selectedAutoBrake = Searchautobrakedefault(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration, conditionRef: selectedCondition)();
      autoBrakeOptions = Loadautobrakes(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration, flapRef: selectedFlaps, conditionRef: selectedCondition)();
    }

    if(selectedAirport != 'XXX') {
      selectedAirportElevation = widget.airportEl;
      selectedAirportTemperature = widget.airportTemp;
      selectedAirportRunway = widget.airportRunway;
      selectedRunway = selectedAirportRunway?.keys.first;
      selectedSlopeValues = selectedAirportRunway?[selectedRunway];
      rwyId = selectedSlopeValues?[0]; 
      rwyLda = selectedSlopeValues?[1];
      netLDA = rwyLda;
      opldResult = rwyLda; 
      rwySlope = selectedSlopeValues?[2];
      altitud = Calculatealtitud(elevationRef: selectedAirportElevation, qnhRef: selectedAirportQNH)();
      isa = Calculateisa(elevationRef: selectedAirportElevation, temperatureRef: selectedAirportTemperature)();
    } else {
      altitudMin = double.parse(defaultAircraft?[9] ?? '0');
      altitudMax = double.parse(defaultAircraft?[10] ?? '0');
      sliderMin = (altitudMin! / 1000).ceil() * 1000;
      sliderMax = (altitudMax! / 1000).floor() * 1000;
      _divisions = ((sliderMax - sliderMin) / 1000).round();
      selectedAirportTemperature = '26.0';
      _currentElevation = double.parse(defaultAircraft?[18] ?? '0');
      isa = Calculateisa(elevationRef: _currentElevation.toString(), temperatureRef: selectedAirportTemperature)();
      rwyId = '0000'; 
      rwyLda = '0000'; 
      rwySlope = '0';
      netLDA = rwyLda;
      opldResult = '8143';
      rwySlopeMin = defaultAircraft?[11];
      rwySlopeMax = defaultAircraft?[12];
    } 
    _currentLadWeight = double.parse(defaultAircraft?[4] ?? '0');
    weightMAX = double.parse(defaultAircraft?[5] ?? '0');
    weightMIN = double.parse(defaultAircraft?[6] ?? '0');
    vRef = defaultAircraft?[0];
    vMin = defaultAircraft?[7];
    vMax = defaultAircraft?[8];
    
  }

  void updateRwyCondition(String condition) {
    final values = conditionNotes[condition] ?? ["Unknown"];
    rwyRcc = values.first;
    rwyNote = values.skip(1).toList();
  }

  void _increment() {
    setState(() {
      _counter++;
    });
  }

  void _decrement() {
    setState(() {
      if (_counter > 0) {
        _counter--;
      }
    });
  }
  

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Center(
          child: Text(
            '$selectedAircraft',
            style: TextStyle(fontSize: 22, color: AppColors.white),
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna Izquierda (Airport Information y Aircraft Configuration)
                Expanded(
                  child: Column(
                    children: [
                      //Airport Information Header
                      Card(
                        color: AppColors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                AppStrings.airportInfo,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                              ),
                              Text(
                                '$selectedAirport', // TextForSelectedAirport
                                style: TextStyle(color: AppColors.iconDark),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Rwy ID, si es XXX, se muestra el texto RWY MAG HDG y los valores pasan a ser numerico como Wind. En aumento de +1 hasta 360
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [     
                              if (selectedAirport != 'XXX') ...[
                                Text(
                                  AppStrings.rwyId,
                                  style: TextStyle(
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Text(
                                  '($rwyId°)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor3Dark,
                                  ),
                                ),
                                SizedBox(width: screenSize.width * 0.18),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    initialValue: selectedRunway,
                                    hint: Text(
                                     '$selectedRunway',
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
                                    items: (selectedAirportRunway?.keys ?? <String>{}).map((value) {
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
                                        selectedSlopeValues = selectedAirportRunway?[newValue];
                                        rwyId = selectedSlopeValues?[0]; 
                                        rwyLda = selectedSlopeValues?[1]; 
                                        rwySlope = selectedSlopeValues?[2];
                                      });
                                    },
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  AppStrings.rwyMag, 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 18.0),
                                PopupMenuButton<String>(
                                  initialValue: selectedMag,
                                  onSelected: (String newValue) {
                                    setState(() {
                                      selectedMag = newValue;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return rwymagOptions.map((String opcion) {
                                      return PopupMenuItem<String>(
                                        value: opcion,
                                        child: Text(opcion),
                                      );
                                    }).toList();
                                  },
                                  child: Container(
                                    width: 150,
                                    height: 50,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.placeholder,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(color: AppColors.placeholder, width: 1.0),
                                    ),
                                    child: Text(
                                      selectedMag ?? '000',
                                      style: TextStyle(
                                        color: AppColors.iconDark,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],


                            ],
                          ),
                        ),
                      ),

                      //Rwy condition
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.rwyCond,
                                style: TextStyle(
                                  color: AppColors.white, 
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.12),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true, 
                                  initialValue: selectedCondition,
                                  hint: Text(
                                    '$selectedCondition',
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
                                  items: rwyConditions.map((String value) {
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
                                    if (newValue == null) return;

                                    setState(() {
                                      selectedCondition = newValue;
                                      updateRwyCondition(newValue);
                                      if(selectedLanding == 'Non-Normal') {
                                        selectedAutoBrake = Searchautobrakedefault(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration, conditionRef: selectedCondition)();
                                        autoBrakeOptions = Loadautobrakes(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration, flapRef: selectedFlaps, conditionRef: selectedCondition)();
                                      } else {
                                        autoBrakeOptions = Loadautobrakes(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration, flapRef: selectedFlaps, conditionRef: selectedCondition)();
                                      }
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Rwy slope, en vista XXX se muestra un valor en porcentaje (color verde), y botones de suma y resta
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [                             
                              Expanded(
                                child: Text(
                                  AppStrings.rwySlop,
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                              const Spacer(),
                              if (selectedAirport != 'XXX')
                                Expanded(
                                  child: Text(
                                    '$rwySlope %',
                                    style: TextStyle(color: AppColors.textColor3Dark, fontSize: 15,),
                                  ),
                                )
                              else ...[
                                Expanded(
                                  child: Text(
                                    '$rwySlope %',
                                    style: TextStyle(color: AppColors.textColor2Dark),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                      setState(() {
                                          rwySlope = Calculateslopeincredecre(slopeReference: rwySlope, minReference: rwySlopeMin, maxReference: rwySlopeMax, operation: 'decrement')();
                                        });
                                      },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.placeholder,
                                    foregroundColor: AppColors.iconDark,
                                    minimumSize: const Size(50, 50),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: const BorderSide(color: AppColors.placeholder, width: 1.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: AppColors.iconDark,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                        rwySlope = Calculateslopeincredecre(slopeReference: rwySlope, minReference: rwySlopeMin, maxReference: rwySlopeMax, operation: 'increment')();
                                      });
                                    },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.placeholder,
                                    foregroundColor: AppColors.iconDark,
                                    minimumSize: const Size(50, 50),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: const BorderSide(color: AppColors.placeholder, width: 1.0),
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.iconDark,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      //Elevation, la vista cambia si es el aeropuerto es XXX
                      Card(
                            color: AppColors.cardDark,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: AppColors.placeholder, 
                                width: 2.0,         
                              ),
                              borderRadius: BorderRadius.circular(12.0), 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(AppStrings.elevation, style: const TextStyle(color: AppColors.white)),
                                      if (selectedAirport == 'XXX') ...[
                                            SizedBox(width: screenSize.width * 0.22),
                                            Text(
                                              '$_currentElevation ${AppStrings.ft}',
                                              style: const TextStyle(color: AppColors.textColor3Dark, fontSize: 15,),
                                            ),
                                            const SizedBox(width: 10.0),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                    _currentElevation = Calculateelevationincredecre(elevationReference: _currentElevation, minReference: weightMIN, maxReference: weightMAX, operation: 'decrement')();
                                                  });
                                                },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.placeholder,
                                                foregroundColor: AppColors.iconDark,
                                                minimumSize: const Size(50, 50),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  side: const BorderSide(color: AppColors.placeholder, width: 1.0),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                color: AppColors.iconDark,
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                    _currentElevation = Calculateelevationincredecre(elevationReference: _currentElevation, minReference: weightMIN, maxReference: weightMAX, operation: 'increment')();
                                                  });
                                                },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.placeholder,
                                                foregroundColor: AppColors.iconDark,
                                                minimumSize: const Size(50, 50),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  side: const BorderSide(color: AppColors.placeholder, width: 1.0),
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: AppColors.iconDark,
                                                size: 20,
                                              ),
                                            ),
                                         ] else ...[
                                            SizedBox(width: screenSize.width * 0.20),
                                            Text(
                                              '$selectedAirportElevation ${AppStrings.ft}',
                                              style: TextStyle(color: AppColors.textColor3Dark, fontSize: 15,),
                                            ),
                                          ]
                                    ],
                                  ),
                                  if (selectedAirport == 'XXX') 
                                    Slider(
                                      activeColor: AppColors.iconDark,
                                      thumbColor: AppColors.iconDark,
                                      value: _currentElevation.clamp(sliderMin, sliderMax),
                                      min: sliderMin,
                                      max: sliderMax,
                                      divisions: _divisions,
                                      onChanged: (double val) {
                                        setState(() {
                                          _currentElevation = val;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                      ),

                      //LDA y boton de ajustes de reduccion, no se muestra si el aeropuerto es XXX
                      if (selectedAirport != 'XXX') 
                       Card(
                            color: AppColors.cardDark,
                            shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.placeholder, 
                              width: 2.0,         
                            ),
                            borderRadius: BorderRadius.circular(12.0), 
                          ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min, 
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        AppStrings.lda,
                                        style: TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '$rwyLda ${AppStrings.ft}',
                                        style: TextStyle(
                                          color: AppColors.textColor3Dark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '(${(double.tryParse(rwyLda ?? '0')! * 0.3048).round()}${AppStrings.m})',
                                        style: TextStyle(
                                          color: AppColors.textColor3Dark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isExpanded = !_isExpanded;
                                            _currentReduction = '';
                                            netLDA = rwyLda;
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.black,
                                          side: BorderSide(color: AppColors.placeholderDark),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                        ),
                                        child: Text(
                                          AppStrings.ldaAdjust,
                                          style: TextStyle(color: AppColors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  
                                  if (_isExpanded) ...[
                                    const SizedBox(height: 10), 
                                    Row(
                                      children: [
                                        Text(
                                          AppStrings.reduction,
                                          style: TextStyle(color: AppColors.white, fontSize: 15),
                                        ),
                                        const SizedBox(width: 45), 
                                        SizedBox(
                                          width: 150,
                                          height: 50,
                                          child: TextField(
                                            controller: TextEditingController(text: _currentReduction)
                                              ..selection = TextSelection.fromPosition(
                                                TextPosition(offset: (_currentReduction ?? '').length),
                                              ),
                                            keyboardType: TextInputType.number, 
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly,
                                              Customdigitformatter(),
                                            ],
                                            onChanged: (String newValue) {
                                              setState(() {
                                                _currentReduction = newValue; 
                                                netLDA = Calculatereduction(netRef: netLDA, ldaRef: rwyLda, reductionRef: _currentReduction)();
                                              });
                                            },
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: AppColors.iconDark,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            decoration: InputDecoration(
                                              hintText: AppStrings.reductionLow,
                                              hintStyle: const TextStyle(color: AppColors.iconDark),
                                              filled: true,
                                              fillColor: AppColors.placeholder,
                                              contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(color: AppColors.placeholder, width: 1.0),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(color: AppColors.placeholder, width: 1.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8.0),
                                                borderSide: const BorderSide(color: AppColors.placeholder, width: 1.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 15), 
                                        Text(
                                          AppStrings.m,
                                          style: TextStyle(color: AppColors.placeholderDark, fontSize: 15),
                                        ),
                                        if (_currentReduction?.isNotEmpty ?? false) ...[
                                          const SizedBox(width: 25),
                                          Text(
                                            '(${(double.tryParse(_currentReduction ?? '0')! * 3.28084).toStringAsFixed(1)}${AppStrings.ft})',
                                            style: const TextStyle(
                                              color: AppColors.textColor3Dark,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],

                                      ],
                                    ),
                                  ],

                                  const SizedBox(height: 8), 
                                  Text(
                                    AppStrings.refOnly,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                      color: AppColors.activeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                      //Aircraft Configuration header
                      Card(
                        color: AppColors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.aircraftConfig,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white),
                            ),
                          ),
                        ),
                      ),

                      //Flaps
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.flap,
                                style: TextStyle(
                                  color: AppColors.white, 
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.15),
                              if(selectedLanding == 'Normal') ...[
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true, 
                                    initialValue: selectedFlaps,
                                    hint: Text(
                                      '$selectedFlaps',
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
                                    items: normalFlaps.map((String value) {
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
                                        selectedFlaps = newValue;
                                        listaComments = Loadcomments(aircraftRef: selectedAircraft, landingRef: selectedLanding,configurationRef: selectedConfiguration, flapRef: selectedFlaps)();
                                        autoBrakeOptions = Loadautobrakes(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration, flapRef: selectedFlaps, conditionRef: selectedCondition)();
                                      });
                                    },
                                  ),
                                ),
                              ] else ... [
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      isExpanded: true,
                                      initialValue: selectedFlaps,
                                      hint: Text(
                                        '$selectedFlaps',
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
                                      items:[nonFlap].where((val) => val != null).map((value) {
                                        final String safeValue = value!; 
                                        return DropdownMenuItem<String>(
                                          value: safeValue,
                                          child: Text(
                                            safeValue,
                                            style: TextStyle(color: AppColors.placeholderDark),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedFlaps = newValue;
                                        });
                                      },
                                    ),
                                  ),
                              ],
                            ],
                          ),
                        ),
                      ),

                      //Autobrake
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.autobrake,
                                style: TextStyle(
                                  color: AppColors.white, 
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.15),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true, 
                                  initialValue: selectedAutoBrake,
                                  hint: Text(
                                    '$selectedAutoBrake',
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
                                  items: autoBrakeOptions!.map((String value) {
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
                                      selectedAutoBrake = newValue;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Reversers
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.reversers,
                                style: TextStyle(
                                  color: AppColors.white, 
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.20),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true, 
                                  initialValue: selectedReversers,
                                  hint: Text(
                                    reversersList![0],
                                    style: TextStyle(
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
                                  items: reversersList!.map((String value) {
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
                                      selectedReversers = newValue;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //SpeedBrakes, cambia dependiendo del tipo de aircraft (normal o non-normal) a N/A 
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.speedbrakes,
                                style: TextStyle(
                                  color: AppColors.white, 
                                ),
                              ),
                              SizedBox(width: screenSize.width * 0.20),
                              if (selectedLanding != 'Non-Normal')
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    initialValue: selectedSpeedBrakeType,
                                    hint: Text(
                                      'AUTOMATIC',
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
                                    items: speedBrakesTypes.map((String value) {
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
                                        selectedSpeedBrakeType = newValue;
                                      }); 
                                    },
                                  ),
                                )
                              else
                                Expanded (child: Text(
                                    AppStrings.na,
                                    style: TextStyle(
                                      color: AppColors.textColor3Dark,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      //Vref add, cambia dependiendo del tipo de aircraft (Normal o Non-Normal) a N/A y el texto VREF cambia
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              if (selectedLanding != 'Non-Normal') ...[
                                Expanded(
                                  child: Text(
                                    AppStrings.vrefAdd,
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                  '$vRef ${AppStrings.kt}',
                                    style: TextStyle(color: AppColors.placeholderDark),
                                  ),
                                ),
                                const SizedBox(width: 10.0),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          vRef = Calculatevrefincredecre(vReference: vRef, minReference: vMin, maxReference: vMax, operation: 'decrement')();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.placeholder, 
                                        foregroundColor: AppColors.iconDark, 
                                        minimumSize: const Size(50, 50),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: AppColors.iconDark, 
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),                                 
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          vRef = Calculatevrefincredecre(vReference: vRef, minReference: vMin, maxReference: vMax, operation: 'increment')();
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.placeholder, 
                                        foregroundColor: AppColors.iconDark, 
                                        minimumSize: const Size(50, 50),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.iconDark, 
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ]  else ...[
                                    if(selectedConfiguration?.contains('Airspeed Unreliable') == true) ...[
                                      Expanded(
                                        child: Text(
                                          AppStrings.vrefPlus,
                                          style: TextStyle(color: AppColors.white),
                                        ),
                                      ),
                                      const SizedBox(width: 100.0),
                                      Expanded(
                                        child: Text(
                                        AppStrings.na,
                                          style: TextStyle(color: AppColors.textColor3Dark),
                                        ),
                                      ),  
                                    ] else ...[
                                        Expanded(
                                          child: Text(
                                            AppStrings.vrefAdd,
                                            style: TextStyle(color: AppColors.white),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                        Expanded(
                                          child: Text(
                                          '$vRef ${AppStrings.kt}',
                                            style: TextStyle(color: AppColors.placeholderDark),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),

                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                          
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  vRef = Calculatevrefincredecre(vReference: vRef, minReference: vMin, maxReference: vMax, operation: 'decrement')();
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.placeholder, 
                                                foregroundColor: AppColors.iconDark, 
                                                minimumSize: const Size(50, 50),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.remove,
                                                color: AppColors.iconDark, 
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),                                 
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  vRef = Calculatevrefincredecre(vReference: vRef, minReference: vMin, maxReference: vMax, operation: 'increment')();
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppColors.placeholder, 
                                                foregroundColor: AppColors.iconDark, 
                                                minimumSize: const Size(50, 50),
                                                padding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(8.0),
                                                  side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                                ),
                                              ),
                                              child: Icon(
                                                Icons.add,
                                                color: AppColors.iconDark, 
                                                size: 20,
                                              ),
                                            ),
                                          ], 
                                        ),
                                    ],
                                ],
                            ],
                          ),
                        ),
                      ),

                      //Landing Weight
                      Card(
                            color: AppColors.cardDark,
                            shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: AppColors.placeholder, 
                              width: 2.0,         
                            ),
                            borderRadius: BorderRadius.circular(12.0), 
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(AppStrings.landWeight, style: const TextStyle(color: AppColors.white)),
                                          const SizedBox(height: 5.0),
                                          Text(
                                            '${(_currentLadWeight as num).toInt().toString()} ${AppStrings.lb}',
                                            style: const TextStyle(color: AppColors.textColor2Dark),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            _currentLadWeight = Calculateweightincredecre(weightReference: _currentLadWeight, minReference: weightMIN, maxReference: weightMAX, operation: 'decrement')();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.placeholder, 
                                          foregroundColor: AppColors.iconDark, 
                                          minimumSize: const Size(50, 50),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: AppColors.iconDark, 
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),                                 
                                      ElevatedButton(
                                        onPressed:  () {
                                          setState(() {
                                            _currentLadWeight = Calculateweightincredecre(weightReference: _currentLadWeight, minReference: weightMIN, maxReference: weightMAX, operation: 'increment')();
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.placeholder, 
                                          foregroundColor: AppColors.iconDark, 
                                          minimumSize: const Size(50, 50),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.iconDark, 
                                          size: 20,
                                        ),
                                      ),

                                    ],
                                  ),
                                  Slider(
                                    activeColor: AppColors.iconDark,
                                    thumbColor: AppColors.iconDark,
                                    value: _currentLadWeight,
                                    min: weightMIN,
                                    max: weightMAX,
                                    onChanged: (double val) {
                                      setState(() {
                                        _currentLadWeight = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Columna Derecha (Weather y Landing Performance)
                Expanded(
                  child: Column(
                    children: [
                      // Weather Condition Header
                      Card(
                        color: AppColors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.weatherCond,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.white),
                            ),
                          ),
                        ),
                      ),

                      // QNH
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  AppStrings.qnh,
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                              const SizedBox(width: 5.0),

                              Expanded(
                                child: Column (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min, 
                                  children: [ 
                                    Text(
                                      '$selectedAirportQNH',
                                      style: TextStyle(color: AppColors.placeholderDark, fontSize: 15,),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (0.02953 * (double.tryParse(selectedAirportQNH ?? '') ?? 0)).toStringAsFixed(2),
                                      style: TextStyle(color: AppColors.placeholderDark, fontSize: 15,),
                                    ),
                                ]
                                ),
                              ),

                              const SizedBox(width: 5.0),
                              Expanded(
                                child: Column (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min, 
                                  children: [ 
                                    Text(
                                      AppStrings.hpa,
                                      style: TextStyle(color: AppColors.placeholderDark, fontSize: 15,),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppStrings.inhg,
                                      style: TextStyle(color: AppColors.placeholderDark, fontSize: 15,),
                                    ),
                                ]
                                ),
                              ),

                              if(selectedAirport != 'XXX') ...[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  
                                    ElevatedButton(
                                      onPressed:  () {
                                          setState(() {
                                            selectedAirportQNH = Calculateqnhincredecre(qnhRef: selectedAirportQNH, operation: 'decrement')();
                                            altitud = Calculatealtitud(elevationRef: selectedAirportElevation, qnhRef: selectedAirportQNH)();
                                          });},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.placeholder, 
                                        foregroundColor: AppColors.iconDark, 
                                        minimumSize: const Size(50, 50),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: AppColors.iconDark, 
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),                                 
                                    ElevatedButton(
                                      onPressed: () {
                                          setState(() {
                                            selectedAirportQNH = Calculateqnhincredecre(qnhRef: selectedAirportQNH, operation: 'increment')();
                                            altitud = Calculatealtitud(elevationRef: selectedAirportElevation, qnhRef: selectedAirportQNH)();
                                          });},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.placeholder, 
                                        foregroundColor: AppColors.iconDark, 
                                        minimumSize: const Size(50, 50),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.iconDark, 
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                  Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
//Buscar solucion cuando se presiona el boton de suma y resta que cambia la variable de altitud en QNH, de momento se paraliza.       
                                    ElevatedButton(
                                      onPressed:  () {
                                          setState(() {
                                            selectedAirportQNH = Calculateqnhincredecre(qnhRef: selectedAirportQNH, operation: 'decrement')();
                                            altitud = Calculatealtitud(elevationRef: _currentElevation.toString(), qnhRef: selectedAirportQNH)();
                                          });},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.placeholder, 
                                        foregroundColor: AppColors.iconDark, 
                                        minimumSize: const Size(50, 50),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: AppColors.iconDark, 
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),                                 
                                    ElevatedButton(
                                      onPressed: () {
                                          setState(() {
                                            selectedAirportQNH = Calculateqnhincredecre(qnhRef: selectedAirportQNH, operation: 'increment')();
                                            altitud = Calculatealtitud(elevationRef: _currentElevation.toString(), qnhRef: selectedAirportQNH)();
                                          });},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.placeholder, 
                                        foregroundColor: AppColors.iconDark, 
                                        minimumSize: const Size(50, 50),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.iconDark, 
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),

                              ]

                            ],
                          ),
                        ),
                      ),

                    // Altitude
                    Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text(AppStrings.altitude, style: TextStyle(color: AppColors.white))),
                              const SizedBox(width: 120.0),
                              if (selectedAirport != 'XXX') ...[
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    '$altitud ${AppStrings.palt}',
                                    style: TextStyle(color: AppColors.textColor3Dark, fontSize: 15,),
                                  ),
                                ),
                              ] else ...[
                                Expanded(
                                  flex: 7,
                                  child: Text(
                                    '$_currentElevation ${AppStrings.palt}',
                                    style: TextStyle(color: AppColors.textColor3Dark, fontSize: 15,),
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      ),

                      // QAT
                      Card(
                        color: AppColors.cardDark,
                        shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  AppStrings.oat,
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Column (
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min, 
                                  children: [ 
                                    Text(
                                      '${double.tryParse(selectedAirportTemperature ?? '')?.round() ?? 0} ${AppStrings.celcius}',
                                      style: TextStyle(color: AppColors.okPriButBrDark, fontSize: 15,),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${AppStrings.isa} $isa',
                                      style: TextStyle(color: AppColors.placeholderDark, fontSize: 15,),
                                    ),
                                ]
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              if(selectedAirport != 'XXX') ...[
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                  
                                    ElevatedButton(
                                      onPressed: () {
                                          setState(() {
                                            selectedAirportTemperature = Calculatetemperatureincredecre(temperatureRef: selectedAirportTemperature, isaRef: isa, minRef: isaMin, maxRef: isaMax, operation: 'decrement')();
                                            isa = Calculateisa(elevationRef: selectedAirportElevation, temperatureRef: selectedAirportTemperature)();
                                          });},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.placeholder, 
                                        foregroundColor: AppColors.iconDark, 
                                        minimumSize: const Size(50, 50),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.remove,
                                        color: AppColors.iconDark, 
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),                                 
                                    ElevatedButton(
                                      onPressed:  () {
                                          setState(() {
                                            selectedAirportTemperature = Calculatetemperatureincredecre(temperatureRef: selectedAirportTemperature, isaRef: isa, minRef: isaMin, maxRef: isaMax, operation: 'increment')();
                                            isa = Calculateisa(elevationRef: selectedAirportElevation, temperatureRef: selectedAirportTemperature)();
                                          });},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.placeholder, 
                                        foregroundColor: AppColors.iconDark, 
                                        minimumSize: const Size(50, 50),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: AppColors.iconDark, 
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else ...[
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                    
                                      ElevatedButton(
                                        onPressed: () {
                                            setState(() {
                                              selectedAirportTemperature = Calculatetemperatureincredecre(temperatureRef: selectedAirportTemperature, operation: 'decrement')();
                                              isa = Calculateisa(elevationRef: _currentElevation.toString(), temperatureRef: selectedAirportTemperature)();
                                            });},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.placeholder, 
                                          foregroundColor: AppColors.iconDark, 
                                          minimumSize: const Size(50, 50),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: AppColors.iconDark, 
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),                                 
                                      ElevatedButton(
                                        onPressed:  () {
                                            setState(() {
                                              selectedAirportTemperature = Calculatetemperatureincredecre(temperatureRef: selectedAirportTemperature, operation: 'increment')();
                                              isa = Calculateisa(elevationRef: _currentElevation.toString(), temperatureRef: selectedAirportTemperature)();
                                            });},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.placeholder, 
                                          foregroundColor: AppColors.iconDark, 
                                          minimumSize: const Size(50, 50),
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                            side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: AppColors.iconDark, 
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                              ]
                            ],
                          ),
                        ),
                      ),

                    // WIND
                    Card(
                      color: AppColors.cardDark,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: AppColors.placeholder, 
                          width: 2.0,         
                        ),
                        borderRadius: BorderRadius.circular(12.0), 
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppStrings.wind,
                                    style: TextStyle(color: AppColors.white),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                    Row(
                                      children: [
                                        PopupMenuButton<String>(
                                          initialValue: selectedWind, 
                                          onSelected: (String newValue) {
                                            setState(() {
                                              selectedWind = newValue; 
                                            });
                                          },
                                          itemBuilder: (BuildContext context) {            
                                            return windDirection.map((String opcion) {
                                              return PopupMenuItem<String>(
                                                value: opcion,
                                                child: Text(opcion),
                                              );
                                            }).toList();
                                          },
                                          child: Container(
                                            width: 150,
                                            height: 50,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: AppColors.placeholder,
                                              borderRadius: BorderRadius.circular(8.0),
                                              border: Border.all(color: AppColors.placeholder, width: 1.0),
                                            ),
                                            child: Text(
                                              selectedWind ?? '000', 
                                              style: TextStyle(
                                                color: AppColors.iconDark,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                      const SizedBox(width: 25.0),
                                      Text(
                                        '/', 
                                        style: TextStyle(color: AppColors.cancelPriButBrDark),
                                      ),
                                      const SizedBox(width: 25.0),
                                      Text(
                                        (_counter as num).toInt().toString() + AppStrings.kt,
                                        style: TextStyle(color: AppColors.placeholderDark),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Row(
                                    children: [
                                      const SizedBox(width: 25.0),
                                      Text(
                                        (_counter as num).toInt().toString() + AppStrings.kthwc,
                                        style: TextStyle(color: AppColors.textColor3Dark),
                                      ),
                                      const SizedBox(width: 25.0),
                                      Text(
                                        '/', 
                                        style: TextStyle(color: AppColors.cancelPriButBrDark),
                                      ),
                                      const SizedBox(width: 25.0),
                                      Text(
                                        (_counter as num).toInt().toString() + AppStrings.ktCwc,
                                        style: TextStyle(color: AppColors.textColor3Dark),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(width: 10.0),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: _decrement,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.placeholder, 
                                    foregroundColor: AppColors.iconDark, 
                                    minimumSize: const Size(50, 50),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.remove,
                                    color: AppColors.iconDark, 
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 8.0),                        
                                ElevatedButton(
                                  onPressed: _increment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.placeholder, 
                                    foregroundColor: AppColors.iconDark, 
                                    minimumSize: const Size(50, 50),
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      side: const BorderSide(color: AppColors.placeholder, width: 1.0), 
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.iconDark, 
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                      
                    //Performance Results header, si es XXX, solo se muestra el resultado del OpLD 
                      Card(
                        color: AppColors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [ 
                              if(selectedLanding != 'Non-Normal') ...[
                                Text(
                                  AppStrings.landingTittle,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white),
                                ),
                               ] else ...[
                                  Text(
                                    '$selectedConfiguration',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.white),
                                  ),
                               ],

                              const SizedBox(height: 12),

                                  //NET LDA results, no se muestra si el aeropuerto es XXX
                                    if(selectedAirport != 'XXX')
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: AppColors.white.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppStrings.netLda,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              '$netLDA ${AppStrings.ft}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor3Dark,
                                                fontSize: 15,
                                              ),
                                            ),
                                            
                                            Text(
                                              '(${(double.tryParse(netLDA ?? '0')! * 0.3048).round()}${AppStrings.m})',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor3Dark,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                          ],
                                        ),
                                      ),

                                    const SizedBox(height: 12), 

                                    //OpLD results
                                    Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: AppColors.white.withValues(alpha: 0.3),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              AppStrings.opld,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 15),
                                            Text(
                                              '$opldResult ${AppStrings.ft}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor2Dark,
                                                fontSize: 15,
                                              ),
                                            ),
                                          
                                            Text(
                                              '(${(double.tryParse(opldResult ?? '0')! * 0.3048).round()}${AppStrings.m})',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor2Dark,
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                          ],
                                        ),
                                    ),
                            ],
                          ),
                        ),
                      ),

                      //Colocar Divider(color: AppColors.cancelPriButBrDark,) en este punto, para ser el Divisor de la union del contenido de ambas Card().

                      //OpLD Results Notes, no se muestra el Remaining si el aeropuerto es XXX
                      Card(
                        color: AppColors.black,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: AppColors.white),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0), 
                          child: SizedBox(
                            height: 380,
                            width: 1500, 
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [       
                                SizedBox(
                                  width: double.infinity, 
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (selectedAirport != 'XXX') ...[
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [  
                                            Text(
                                              AppStrings.remaining, 
                                              textAlign: TextAlign.left, 
                                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.white),
                                            ),
                                            SizedBox(width: screenSize.width * 0.15),
                                            Text(
                                              '5608${AppStrings.ft}', 
                                              textAlign: TextAlign.right, 
                                              style: TextStyle(color: AppColors.textColor2Dark, fontSize: 15,),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              '(1709${AppStrings.m})', 
                                              textAlign: TextAlign.right, 
                                              style: TextStyle(color: AppColors.textColor2Dark, fontSize: 15,),
                                            ),
                                          ],
                                        )

                                      ],
                                      const SizedBox(height: 12),
                                      Text('$selectedFlaps', textAlign: TextAlign.left, style: TextStyle(color: AppColors.placeholder)),
                                      const SizedBox(height: 12),
                                      Text('$selectedAutoBrake', textAlign: TextAlign.left, style: TextStyle(color: AppColors.placeholder)),
                                      const SizedBox(height: 50),
                                     
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: 
                                          Text('$selectedCondition rwy Condition:', textAlign: TextAlign.left, style: TextStyle(color: AppColors.placeholder)),
                                          ),
                                          SizedBox(width: screenSize.width * 0.10),
                                          Text('(''$rwyRcc'')', textAlign: TextAlign.right, style: TextStyle(color: AppColors.placeholder)),
                                        ]
                                      ),
                                      const SizedBox(height: 20),
                                      ...rwyNote!.map((nota) => Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                                child: Text(
                                                  nota,
                                                  style: const TextStyle(color: AppColors.placeholder),
                                                  textAlign: TextAlign.start,
                                                ),
                                              )),
                                    ],
                                  ),
                                ),

                                //Importent notes boton de dialogo message
                               ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.black,
                                  foregroundColor: AppColors.placeholderDark,
                                  side: const BorderSide(
                                    color: AppColors.placeholderDark,
                                    width: 2.5,
                                  ),
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: AppColors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.0),
                                          side: const BorderSide(
                                            color: AppColors.placeholderDark,
                                            width: 1.5,
                                          ),
                                        ),
                                        content: SizedBox(
                                          width: 650.0,
                                          height: 700.0,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                              child: const Text(
                                                  AppStrings.notesTitle,
                                                  style: TextStyle(
                                                    color: AppColors.textColor2Dark,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 10),
                                              
                                              ...listaComments!.expand((comentario) => [
                                              Divider(color: AppColors.cancelPriButBrDark,),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                child: Text(
                                                  comentario,
                                                  style: const TextStyle(color: AppColors.white),
                                                  textAlign: TextAlign.start,
                                                ),  
                                              ),
                                              Divider(color: AppColors.cancelPriButBrDark,)
                                              ]),

                                              const Spacer(),
                                              //Boton de Return del Importent Notes
                                              Center(
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: AppColors.black,
                                                    foregroundColor: AppColors.iconDark,
                                                    fixedSize: const Size(120, 120),
                                                    shape: BeveledRectangleBorder(
                                                      borderRadius: BorderRadius.circular(200),
                                                      side: BorderSide(color: AppColors.iconDark, width: 1),
                                                    ),
                                                    elevation: 4,
                                                  ),
                                                  child: const Text(
                                                    AppStrings.returnback,
                                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  AppStrings.importNotes,
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ),
                              ],
                            ),
                          ),
                        ),
                      )
                                
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}