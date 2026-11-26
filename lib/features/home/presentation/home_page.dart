import 'package:flutter/material.dart';
import 'package:opld/constants/colors/app_colors.dart';
import 'package:opld/features/home/loaders/loadConfig.dart';
import 'package:opld/features/calculator/presentation/calculatorpage.dart';
import 'package:opld/features/home/loaders/searchflaps.dart';
import 'package:opld/constants/strings/app_strings.dart';
import 'package:xml/xml.dart';
import 'package:opld/service_data/airportdata.dart';
import 'package:opld/design/text/app_text.dart';
import 'package:opld/service_data/opldservice.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

 
class HomePage extends StatefulWidget {
  const HomePage({super.key});
 
  @override
  State<HomePage> createState() => _HomePageState();
}
 
class _HomePageState extends State<HomePage> { 
  // Variables clave de listas
  List<String> aircraftList = [];
  final List<String> landingList = ['Normal', 'Non-Normal'];
  List<String> configurationList = [];
  List<String> _flapsNonList = [];
  final airportList = Airportdata.airportNames;
  Map<String, String> elevationList = Airportdata.airportElevation;
  Map<String, String> qnhList = Airportdata.airportRefQNH;
  Map<String, String> temperatureList = Airportdata.airportAverageRefTemp;
  Map<String, List<String>> runwayList = {};
  //Variables clave
  String? elevation;
  String? qnh;
  String? temperature;
  bool _isReady = false;
  String? selectedAircraft = '737-800W/CFM56-7B26';
  String? selectedLanding = 'Normal';
  String? selectedAirport = 'PTY';
  String? selectedConfiguration;
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
      aircraftList = aircraftElements
          .map((element) => element.getAttribute('label') ?? '')
          .where((label) => label.isNotEmpty)
          .toList();
 
      _isReady = true;
    });
  }
 
  void _onGoPressed() async {
    if (!_isReady) {
      return;
    }
 
    elevation = elevationList[selectedAirport] ?? "0".trim();
    qnh = qnhList[selectedAirport] ?? "0".trim();
    temperature = temperatureList[selectedAirport] ?? "0".trim();
    runwayList = Airportdata.airportRunwayData(selectedAirport);
    if (selectedLanding == 'Non-Normal' && _flapsNonList.isNotEmpty) {
      selectedConfigurationFlap = _flapsNonList.first;
    }
 
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => CalculatorPage(
          aircraft: selectedAircraft,
          normalNon: selectedLanding,
          configuration: selectedConfiguration,
          airport: selectedAirport,
          airportEl: elevation,
          airportQNH: qnh,
          airportTemp: temperature,
          airportRunway: runwayList,
          nonflaps: selectedConfigurationFlap,
        ),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leadingWidth: 65,
        leading: Padding(
          padding: const EdgeInsets.all(8.0), 
          child: Image.asset(
            'assets/icons/logo-copaairlines.png',
            fit: BoxFit.contain,
          ),
        ),
        title: const Text(
          AppStrings.appHeaderHome,
          style: TextStyle(color: AppColors.white, fontSize: 30),
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
                    color: AppColors.borderDropdowns,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    //Label Aircraft Selection
                    Text(
                      AppStrings.aircraftSection,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                        fontSize: orientation ? 30 : 26,
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    //Campo Aircraft Picker
                    DropdownButtonFormField2<String>(
                      //isExpanded: true,
                      value: selectedAircraft,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.placeholder,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.placeholder,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.placeholder,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),

                      hint: Text(
                        'Select Aircraft Type',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor2,
                          fontSize: orientation ? 20 : 26,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      iconStyleData: const IconStyleData(
                        icon: SizedBox.shrink(),
                      ),

                      buttonStyleData: ButtonStyleData(
                      height: orientation ? 40 : 35,
                      ),

                      dropdownStyleData: DropdownStyleData(
                        offset: const Offset(0, -5),
                        scrollbarTheme: ScrollbarThemeData(
                          thickness: WidgetStateProperty.all(0),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.8),
                            width: 1.5,
                          ),
                        ),
                      ),

                      items: aircraftList.map((String value) {
                          final bool isSelected = value == selectedAircraft;
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.white.withOpacity(0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: AppColors.textColor2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),

                      selectedItemBuilder: (BuildContext context) {
                        return aircraftList.map((String value) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.bold,
                                fontSize:  orientation ? 26 : 27,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: false,
                              )
                            ),
                          );
                        }).toList();
                      },
                      
                      onChanged: (newValue) {
                        setState(() {
                          selectedAircraft = newValue;
                          selectedConfiguration = '';
                          selectedConfigurationFlap = '';
                          _flapsNonList.clear();
                        });

                        if (selectedLanding == 'Non-Normal') {
                          configurationList = Loadconfig(aircraftRef: selectedAircraft)();

                          if (configurationList.isNotEmpty) {
                            selectedConfiguration = configurationList.first;
                            _flapsNonList =  Searchflaps(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration)();
                          } else {
                            selectedConfiguration = '';
                            _flapsNonList.clear();
                          }
                        }
                      },
                    ),

                    //Label Landing Selection
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        AppStrings.normalNonnormalSection,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: orientation ? 30 : 26,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    //Campo Landing picker
                    DropdownButtonFormField2<String>(
                      //isExpanded: true,
                      value: selectedLanding,

                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.placeholder,

                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.placeholder,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.placeholder,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),

                        contentPadding: EdgeInsets.zero,
                      ),

                      hint: Text(
                        'Select Type of Landing',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),

                      iconStyleData: const IconStyleData(
                        icon: SizedBox.shrink(),
                      ),

                      buttonStyleData: ButtonStyleData(
                      height: orientation ? 40 : 35,
                      ),

                      dropdownStyleData: DropdownStyleData(
                        offset: const Offset(0, -5),
                        scrollbarTheme: ScrollbarThemeData(
                          thickness: WidgetStateProperty.all(0),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.white.withOpacity(0.8),
                            width: 1.5,
                          ),
                        ),
                      ),

                      items: landingList.map((String value) {
                        final bool isSelected = value == selectedLanding;
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.white.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              value,
                              style: TextStyle(
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        );
                      }).toList(),

                      selectedItemBuilder: (BuildContext context) {
                        return landingList.map((String value) {
                          return Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: AppColors.textColor2,
                                fontWeight: FontWeight.bold,
                                fontSize: orientation ? 26 : 27,
                              ),
                              overflow: TextOverflow.ellipsis,
                              textHeightBehavior: TextHeightBehavior(
                                applyHeightToFirstAscent: false,
                                applyHeightToLastDescent: false,
                              )
                            ),
                          );
                        }).toList();
                      },

                      onChanged: (newValue) {
                        setState(() {
                          selectedLanding = newValue;
                          selectedConfiguration = null;
                          selectedConfigurationFlap = null;
                          _flapsNonList.clear();

                          if (newValue != 'Non-Normal') {
                            configurationList.clear();
                          }
                        });

                        if (newValue == 'Non-Normal') {
                          configurationList = Loadconfig(aircraftRef: selectedAircraft)();
                          if (configurationList.isNotEmpty) {
                            selectedConfiguration = configurationList.first;
                            _flapsNonList =  Searchflaps(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration)();
                          } else {
                            selectedConfiguration = null;
                            _flapsNonList.clear();
                          }
                        }
                      },
                    ),

                    //Label Configuration Type Selection
                    if (selectedLanding == 'Non-Normal') ...[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          AppStrings.configSection,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                            fontSize: orientation ? 30 : 26,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8.0),

                      //Campo Configuration Picker
                      DropdownButtonFormField2<String>(
                        isExpanded: true,
                        value: configurationList.contains(
                          selectedConfiguration,
                        )
                            ? selectedConfiguration
                            : null,

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.placeholder,

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.placeholder,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.placeholder,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),

                          contentPadding:  EdgeInsets.zero,
                        ),

                        hint: Text(
                          'Select Configuration Type',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),

                        iconStyleData: const IconStyleData(
                          icon: SizedBox.shrink(),
                        ),

                         buttonStyleData: ButtonStyleData(
                           height: orientation ? 40 : 35,
                      ),

                        dropdownStyleData: DropdownStyleData(
                          offset: const Offset(0, -5),
                          maxHeight: 400,
                          scrollbarTheme: ScrollbarThemeData(
                            thickness: WidgetStateProperty.all(0),
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: AppColors.white.withOpacity(0.8),
                              width: 1.5,
                            ),
                          ),
                        ),

                        items: configurationList.map((String value) {
                          final bool isSelected = value == selectedConfiguration;
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.white.withOpacity(0.15)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: AppColors.textColor2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        }).toList(),

                        selectedItemBuilder: (BuildContext context) {
                          return configurationList.map((String value) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                value,
                                style: TextStyle(
                                  color: AppColors.textColor2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: orientation ? 26 : 27,
                                ),
                                overflow: TextOverflow.ellipsis,
                                textHeightBehavior: TextHeightBehavior(
                                  applyHeightToFirstAscent: false,
                                  applyHeightToLastDescent: false,
                              )
                              ),
                            );
                          }).toList();
                        },

                        onChanged: (newValue) {
                          setState(() {
                            selectedConfiguration = newValue;
                            _flapsNonList =  Searchflaps(aircraftRef: selectedAircraft, landingRef: selectedLanding, configurationRef: selectedConfiguration)();
                          });
                        },
                      ),                                                         
                    ],
 
                    //Label Airport Selection
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Text(
                        AppStrings.airportSection,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                          fontSize: orientation ? 30 : 26,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8.0),

                    // Campo Airport Picker
                    DropdownSearch<String>(
                      items: (filter, loadProps) => airportList,
                      selectedItem: selectedAirport,
                      suffixProps: DropdownSuffixProps(
                        dropdownButtonProps: DropdownButtonProps(
                          isVisible: false,
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.placeholder,

                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.placeholder,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.placeholder,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(5.0),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),

                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                        ),
                      ),

                      compareFn: (item1, item2) => item1 == item2,

                      popupProps: PopupProps.menu(
                        showSearchBox: true,

                          menuProps: MenuProps(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            margin: const EdgeInsets.only(top: 5),
                          ),

                        containerBuilder: (context, popupWidget) {
                          return Container(
                             decoration: BoxDecoration(
                              color: AppColors.black.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: AppColors.white.withOpacity(0.8),
                                width: 1.5,
                              ),
                            ),
                            child: popupWidget,                           
                          );
                        },

                        searchFieldProps: TextFieldProps(
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.black.withOpacity(0.9),
                            hintText: 'Search Airport',
                            hintStyle: TextStyle(
                              color: AppColors.grey,
                              fontSize: 20,
                            ),
                            prefixIcon: const Icon(Icons.search, color: AppColors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppColors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),

                        emptyBuilder: (context, searchEntry) {
                          return Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  color: AppColors.white,
                                  size: 30,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'No Airport Found for "$searchEntry"',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                        itemBuilder: (context, item, isDisabled, isSelected) {
                          final bool isCurrentItem = item == selectedAirport;
                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isCurrentItem
                                  ? AppColors.white.withOpacity(0.15)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              item,
                              style: TextStyle(
                                color: AppColors.textColor2,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                      ),

                      dropdownBuilder: (context, selectedItem) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 5), 
                          child: Text(
                            selectedItem ?? 'PTY',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textColor2,
                              fontSize: orientation ? 26 : 27,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                              applyHeightToLastDescent: false,
                            ),
                          ),
                        );
                      },

                      onSelected: (newValue) {
                        setState(() {
                          selectedAirport = newValue;
                        });
                      },
                    ),                                  
                  ],
                ),
              ),

               SizedBox(height: orientation ? MediaQuery.of(context).size.height * 0.15 : selectedLanding != 'Non-Normal' ? 30 : 20),

              //Boton GO para ir a la pantalla de CalculatorPage
              Center(
                child: ElevatedButton(
                  onPressed: _isReady ? _onGoPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.icon,
                    fixedSize: const Size(150, 150),
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(200),
                      side: BorderSide(color: AppColors.icon, width: 1),
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

          // Texto Version de app
          Positioned(
            bottom: 8,
            child: SafeArea(
              top: false,
              child: OpLDAppText.regular(
                AppStrings.appVersionNumber,
                color: AppColors.grey,
              ),
            ),
          ),

        ],
      ),
    );
  }
}