import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/calculateAltitud.dart';
import 'package:flutter_application_5/constants/features/calculator/fuctions/customDigitFormatter.dart';
import 'package:flutter_application_5/constants/features/home/data/airportdata.dart';
import 'package:flutter_application_5/constants/strings/app_strings.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  final List<String>? comentariosNon;
  final String? aircraft;
  final String? normalNon;
  final String? configuration;
  final String? airport;
  final String? airportEl;
  final String? airportQNH;
  final String? airportTemp;
  final Map<String, List<String>>? airportRunway;
  const CalculatorPage({
    super.key, 
    this.comentariosNon, this.aircraft, this.normalNon, this.configuration, 
    this.airport, this.airportEl, this.airportQNH, this.airportTemp, this.airportRunway
  });

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  //Variables para las selecciones 
  int _counter = 0;
  //Nota la reduccion solo permite 5 digitos si son 0, pero si tiene valor que no sea 0 al inicio solo permite 4 digitos
  String? _currentReduction;
  double _currentLadWeight = 130000;
  double _currentElevation = 2000;
  String? selectedRunway;
  String? selectedWind;
  String? selectedAircraftType;
  String? selectedAircraft;
  String? selectedLanding;
  String? selectedAirport;
  String? selectedConfiguration;
  String? selectedAirportElevation;
  String? selectedAirportQNH;
  String? selectedAirportTemperature;
  String? selectedCondition = 'DRY';
  String? rwyRcc;
  String? rwyId;
  String? rwySlope;
  String? rwyLda;
  String? altitud;
  bool _isExpanded = false;
  //Variables de listas de los DropDownlists
  List<String>? listaComments = [];
  Map<String, List<String>>? selectedAirportRunway;
  List<String>? selectedSlopeValues = [];
  final List<String> aircraftTypes = ['Opcion A', 'Opcion B'];
  final List<String> rwyConditions = ['DRY', 'GOOD', 'GOOD TO MEDIUM', 'MEDIUM', 'MEDIUM TO POOR', 'POOR'];
  final List<String> windValues = ['000', '010', '020', '030', '040', '050', '060', '070', '080', '090', '100'];
  Map<String, List<String>> conditionNotes = Airportdata.rcaTable;
  List<String>? rwyNote = [];

  @override
  void initState() {
    super.initState();
    updateRwyCondition('DRY');
    //print("Paso 8: cometarios  recibidos de home page: ${widget.comentariosNon}");
    listaComments = widget.comentariosNon;
    selectedAircraft = widget.aircraft;
    selectedLanding = widget.normalNon;
    selectedConfiguration = widget.configuration;
    selectedAirport = widget.airport;
    selectedAirportQNH = widget.airportQNH;
    if(selectedAirport != 'XXX') {
      selectedAirportElevation = widget.airportEl;
      selectedAirportTemperature = widget.airportTemp;
      selectedAirportRunway = widget.airportRunway;
      selectedRunway = selectedAirportRunway?.keys.first;
      selectedSlopeValues = selectedAirportRunway?[selectedRunway];
      rwyId = selectedSlopeValues?[0]; 
      rwyLda = selectedSlopeValues?[1]; 
      rwySlope = selectedSlopeValues?[2];
      altitud = Calculatealtitud(elevationRef: selectedAirportElevation, qnhRef: selectedAirportQNH)();
    } else {
      selectedAirportTemperature = '26.0';
      rwyId = '0000'; 
      rwyLda = '0000'; 
      rwySlope = '0';
    } 
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
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
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
                                  initialValue: selectedWind,
                                  onSelected: (String newValue) {
                                    setState(() {
                                      selectedWind = newValue;
                                    });
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return windValues.map((String opcion) {
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


                            ],
                          ),
                        ),
                      ),

                      //Rwy condition
                      Card(
                        color: AppColors.cardDark,
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
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, 
                                      vertical: 2,
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
                                    '$rwySlope%',
                                    style: TextStyle(color: AppColors.textColor3Dark, fontSize: 15,),
                                  ),
                                )
                              else ...[
                                Expanded(
                                  child: Text(
                                    '$rwySlope%',
                                    style: TextStyle(color: AppColors.textColor2Dark),
                                  ),
                                ),
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
                            ],
                          ),
                        ),
                      ),

                      //Elevation, la vista cambia si es el aeropuerto es XXX
                      Card(
                            color: AppColors.cardDark,
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
                                      value: _currentElevation,
                                      min: -2000,
                                      max: 14200,
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

                      //LDA y boton de ajustes de reduccion
                      if (selectedAirport != 'XXX') 
                       Card(
                            color: AppColors.cardDark,
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
                                        '$rwyLda${AppStrings.ft}',
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
                                            '($_currentReduction${AppStrings.ft})',
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
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true, 
                                  initialValue: selectedAircraftType,
                                  hint: Text(
                                    'Opcion A',
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
                                      horizontal: 8, 
                                      vertical: 2,
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
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Autobrake
                      Card(
                        color: AppColors.cardDark,
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
                                  initialValue: selectedAircraftType,
                                  hint: Text(
                                    'Opcion A',
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
                                      vertical: 2,
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
                              ),
                            ],
                          ),
                        ),
                      ),


                      //Reversers
                      Card(
                        color: AppColors.cardDark,
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
                                  initialValue: selectedAircraftType,
                                  hint: Text(
                                    'Opcion A',
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
                                      horizontal: 8, 
                                      vertical: 2,
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
                              ),
                            ],
                          ),
                        ),
                      ),


                      //SpeedBrakes, cambia dependiendo del tipo de aircraft (normal o non-normal) a N/A 
                      Card(
                        color: AppColors.cardDark,
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
                                    initialValue: selectedAircraftType,
                                    hint: Text(
                                      'Opcion A',
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
                                        horizontal: 8,
                                        vertical: 2,
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

                      //Vref add, cambia dependiendo del tipo de aircraft (Normal o Non-Normal) a N/A y el texto cambia a VREF15 +
                      Card(
                        color: AppColors.cardDark,
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
                                  (_counter as num).toInt().toString() + AppStrings.kt,
                                    style: TextStyle(color: AppColors.placeholderDark),
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
                              ]  else ...[
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
                                ],
                            ],
                          ),
                        ),
                      ),

                      //Landing Weight
                      Card(
                            color: AppColors.cardDark,
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
                                            (_currentLadWeight as num).toInt().toString() + AppStrings.lb,
                                            style: const TextStyle(color: AppColors.textColor2Dark),
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
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
                                  Slider(
                                    activeColor: AppColors.iconDark,
                                    thumbColor: AppColors.iconDark,
                                    value: _currentLadWeight,
                                    min: 96000,
                                    max: 174200,
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
                                      '${(0.02953 * (double.tryParse(selectedAirportQNH ?? '') ?? 0)).toStringAsFixed(2)}',
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

                    // Altitude
                    Card(
                        color: AppColors.cardDark,
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
                                      '${AppStrings.isa} ${(_counter as num).toInt().toString()}',
                                      style: TextStyle(color: AppColors.placeholderDark, fontSize: 15,),
                                    ),
                                ]
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

                    // WIND
                    Card(
                      color: AppColors.cardDark,
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
                                            return windValues.map((String opcion) {
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
                      
                    //Performance Results header, si es XXX, solo se muestra el OpLD 
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
                              Text(
                                AppStrings.landingTittle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white),
                              ),

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
                                              '$rwyLda${AppStrings.ft}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor3Dark,
                                                fontSize: 15,
                                              ),
                                            ),
                                            
                                            Text(
                                              '(${(double.tryParse(rwyLda ?? '0')! * 0.3048).round()}${AppStrings.m})',
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
                                              '9155${AppStrings.ft}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.textColor2Dark,
                                                fontSize: 15,
                                              ),
                                            ),
                                          
                                            Text(
                                              '(2790${AppStrings.m})',
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
                            height: 450,
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
                                      Text(AppStrings.flap, textAlign: TextAlign.left, style: TextStyle(color: AppColors.placeholder)),
                                      const SizedBox(height: 12),
                                      Text(AppStrings.autobrake, textAlign: TextAlign.left, style: TextStyle(color: AppColors.placeholder)),
                                      const SizedBox(height: 50),

                                      Row(
                                        children: [
                                          Text('$selectedCondition rwy Condition:', textAlign: TextAlign.left, style: TextStyle(color: AppColors.placeholder)),
                                          SizedBox(width: screenSize.width * 0.15),
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
                                          height: 600.0,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Center(
                                              child: const Text(
                                                  AppStrings.notesTitle,
                                                  style: TextStyle(
                                                    color: AppColors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              
                                              ...listaComments!.map((comentario) => Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                                child: Text(
                                                  comentario,
                                                  style: const TextStyle(color: AppColors.white),
                                                  textAlign: TextAlign.start,
                                                ),  
                                              )),

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