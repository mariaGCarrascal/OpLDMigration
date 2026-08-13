import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/colors/app_colors.dart';
import 'package:flutter_application_5/constants/strings/app_strings.dart';
import 'package:flutter/services.dart';

class CalculatorPage extends StatefulWidget {
  final List<String>? comentariosNon;
  const CalculatorPage({super.key, this.comentariosNon});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  int _counter = 0;
  double _currentElevation = 2000;
  double _currentLadWeight = 130000;
  String? selectedWind;
  List<String>? listaComments = [];
  String? selectedAircraftType;
  String? selectedCongfiguration;
  final List<String> aircraftTypes = ['Normal', 'Non-Normal', 'XXX'];
  final List<String> windValues = ['000', '010', '020', '030', '040', '050'];
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    print("Paso 8: cometarios  recibidos de home page: ${widget.comentariosNon}");
    listaComments = widget.comentariosNon;
    print("paso 9: cometarios  recibidos de la variable: $listaComments");
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

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Center(
          child: Text(
            AppStrings.appHeaderHome, 
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
                        color: AppColors.bottomSheetDark,
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
                                'XXX', // TextForSelectedAirport
                                style: TextStyle(color: AppColors.iconDark),
                              ),
                            ],
                          ),
                        ),
                      ),

                      //Rwy ID, si es XXX, se muestra el texto RWY MAG HDG y los valores pasan a ser numerico como Wind. En aumento de +1 hasta 360
                      Card(
                        color: AppColors.bottomSheetDark,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [     
                              if (selectedAircraftType != 'XXX') ...[
                                Text(
                                  AppStrings.rwyId,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 20.0),
                                Text(
                                  '(45°)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textColor3Dark,
                                  ),
                                ),
                                const SizedBox(width: 500.0),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    initialValue: selectedAircraftType,
                                    hint: Text(
                                      'No options yet',
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
                              ] else ...[
                                Text(
                                  AppStrings.rwyMag, 
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                  ),
                                ),
                                const SizedBox(width: 8.0),
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
                        color: AppColors.bottomSheetDark,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.rwyCond,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white, 
                                ),
                              ),
                              const SizedBox(width: 500.0),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true, 
                                  initialValue: selectedAircraftType,
                                  hint: Text(
                                    'No options yet',
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

                      //Rwy slope, en vista XXX se muestra un valor en porcentaje (color verde), y botones de suma y resta
                      Card(
                        color: AppColors.bottomSheetDark,
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
                              if (selectedAircraftType != 'XXX')
                                Expanded(
                                  child: Text(
                                    '0.07%',
                                    style: TextStyle(color: AppColors.textColor3Dark),
                                  ),
                                )
                              else ...[
                                Expanded(
                                  child: Text(
                                    '0.07%',
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

                      //Elevation, la vista cambie si es el aeropuerto es XXX
                      Card(
                            color: AppColors.bottomSheetDark,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(AppStrings.elevation, style: const TextStyle(color: AppColors.white)),
                                      const SizedBox(width: 750.0),
                                      if (selectedAircraftType == 'XXX') ...[
                                            Text(
                                              '${(_currentElevation as num).toInt()}${AppStrings.ft}',
                                              style: const TextStyle(color: AppColors.textColor3Dark),
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
                                            Text(
                                              (_counter as num).toInt().toString() + AppStrings.ft,
                                              style: TextStyle(color: AppColors.textColor3Dark),
                                            ),
                                          ]
                                    ],
                                  ),
                                  if (selectedAircraftType == 'XXX') 
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

                      //LDA y boton de ajustes
                      Card(
                            color: AppColors.bottomSheetDark,
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
                                          color: AppColors.activeColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '14763' + AppStrings.ft,
                                        style: TextStyle(
                                          color: AppColors.textColor3Dark,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '(' + '4500' + AppStrings.m + ')',
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
                                          backgroundColor: AppColors.bottomSheetDark,
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
                                            controller: TextEditingController(text: selectedWind)
                                              ..selection = TextSelection.fromPosition(
                                                TextPosition(offset: (selectedWind ?? '').length),
                                              ),
                                            keyboardType: TextInputType.number, 
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter.digitsOnly,
                                            ],
                                            onChanged: (String newValue) {
                                              setState(() {
                                                selectedWind = newValue; 
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
                        color: AppColors.bottomSheetDark,
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
                        color: AppColors.bottomSheetDark,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.flap,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white, 
                                ),
                              ),
                              const SizedBox(width: 400.0),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true, 
                                  initialValue: selectedAircraftType,
                                  hint: Text(
                                    'No options yet',
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
                        color: AppColors.bottomSheetDark,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.autobrake,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white, 
                                ),
                              ),
                              const SizedBox(width: 500.0),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true, 
                                  initialValue: selectedAircraftType,
                                  hint: Text(
                                    'No options yet',
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


                      //Reversers
                      Card(
                        color: AppColors.bottomSheetDark,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.reversers,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white, 
                                ),
                              ),
                              const SizedBox(width: 500.0),
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  isExpanded: true, 
                                  initialValue: selectedAircraftType,
                                  hint: Text(
                                    'No options yet',
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
                        color: AppColors.bottomSheetDark,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [       
                              Text(
                                AppStrings.speedbrakes,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white, 
                                ),
                              ),
                              const SizedBox(width: 500.0),
                              if (selectedAircraftType != 'Non-Normal')
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    initialValue: selectedAircraftType,
                                    hint: Text(
                                      'No options yet',
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
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textColor3Dark,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      //Vref add, cambia dependiendo del tipo de aircraft a N/A y el texto cambie a VREF15 +
                      Card(
                        color: AppColors.bottomSheetDark,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              
                              if (selectedAircraftType != 'Non-Normal') ...[
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
                            color: AppColors.bottomSheetDark,
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
                        color: AppColors.bottomSheetDark,
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
                        color: AppColors.bottomSheetDark,
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
                                      (_counter as num).toInt().toString(),
                                      style: TextStyle(color: AppColors.placeholderDark),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (_counter as num).toInt().toString(),
                                      style: TextStyle(color: AppColors.placeholderDark),
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
                                      style: TextStyle(color: AppColors.placeholderDark),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppStrings.inhg,
                                      style: TextStyle(color: AppColors.placeholderDark),
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
                        color: AppColors.bottomSheetDark,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(flex: 3, child: Text(AppStrings.altitude, style: TextStyle(color: AppColors.white))),
                              const SizedBox(width: 120.0),
                              Expanded(
                                flex: 7,
                                child: Text(
                                  '213' + AppStrings.palt,
                                  style: TextStyle(color: AppColors.textColor3Dark ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // QAT
                      Card(
                        color: AppColors.bottomSheetDark,
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
                                      (_counter as num).toInt().toString()  + AppStrings.celcius,
                                      style: TextStyle(color: AppColors.okPriButBrDark),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppStrings.isa + (_counter as num).toInt().toString(),
                                      style: TextStyle(color: AppColors.placeholderDark),
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
                      color: AppColors.bottomSheetDark,
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
                        color: AppColors.bottomSheetDark,
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
                                    if(selectedAircraftType != 'XXX')
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                        decoration: BoxDecoration(
                                          color: AppColors.white.withValues(alpha: 0.1), 
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
                                        ),
                                        child: Text(
                                          AppStrings.netLda,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 12), 

                                    //OpLD results
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                      decoration: BoxDecoration(
                                        color: AppColors.white.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
                                      ),
                                      child: Text(
                                        AppStrings.opld, 
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),

                      //OpLD Results Notes, no se muestra el Remaining si el aeropuerto es XXX
                      Card(
                        color: AppColors.bottomSheetDark,
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
                                      if (selectedAircraftType != 'XXX') ...[
                                        const SizedBox(height: 12),
                                        Text(
                                          AppStrings.remaining, 
                                          textAlign: TextAlign.left, 
                                          style: TextStyle(color: AppColors.white),
                                        ),
                                      ],
                                      const SizedBox(height: 12),
                                      Text(AppStrings.flap, textAlign: TextAlign.left, style: TextStyle(color: AppColors.white)),
                                      const SizedBox(height: 12),
                                      Text(AppStrings.autobrake, textAlign: TextAlign.left, style: TextStyle(color: AppColors.white)),
                                      const SizedBox(height: 12),
                                      Text('DRY rwy Condition:', textAlign: TextAlign.left, style: TextStyle(color: AppColors.white)),
                                      const SizedBox(height: 25),
                                      Text('Comentarios segun el rwy condition.', textAlign: TextAlign.left, style: TextStyle(color: AppColors.white)),
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