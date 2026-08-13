class AppStrings {

  static const String appVersionNumber = "Version: 9.5.31";

  static const String appHeaderHome = "Operational Landing Distance";

  static const String aircraftSection = "Aircraft Selection:";
  static const String normalNonnormalSection = "Normal or Non-Normal selection:";
  static const String configSection = "Configuration Type:";
  static const String airportSection = "Airport Selection:";
  static const String goButton = "GO";

  static const String airportInfo = "AIRPORT INFORMATION";
  static const String weatherCond = "WEATHER CONDITION";
  static const String aircraftConfig = "AIRCRAFT CONFIGURATION";
  static const String landingTittle = "NORMAL LANDING PERFORMANCE";

  static const String rwyId = "RWY ID";
  static const String rwyMag = "RWY MAG HDG";
  static const String rwyCond = "RWY CONDITION";
  static const String rwySlop = "RWY SLOPE";
  static const String elevation = "Elevation";
  static const String lda = "LDA*";
  static const String ldaAdjust = "ADJUSTMENT";
  static const String reduction = "REDUCTION";
  static const String reductionLow = "reduction";
  static const String refOnly = "FOR REFERENCE ONLY;IT MIGHT NOT BE KEPT UP TO DATE.";
  static const String flap = "FLAP";
  static const String autobrake = "AUTOBRAKE";
  static const String reversers = "REVERSERS";
  static const String speedbrakes = "SPEEDBRAKES";
  static const String vrefAdd = "VREF ADD";
  static const String vrefPlus = "VREF15 +";
  static const String landWeight = "LANDING WEIGHT";
  static const String na = "N/A";
  
  static const String ft = "ft";
  static const String lb = "Lb";
  static const String m = "m";
  static const String kt = "KT";
  static const String celcius = "°C";

  static const String qnh = "QNH";
  static const String hpa = "HPa";
  static const String inhg = "inHg";
  static const String palt = "Palt ft";
  static const String altitude = "ALTITUDE";
  static const String oat = "OAT";
  static const String isa = "ISA +";
  static const String wind = "WIND";
  static const String kthwc = "KT HWC";
  static const String ktCwc = "KT CWC";

  static const String netLda = "NET LDA:";
  static const String opld = "OpLD:";
  static const String remaining = "REMAINING:";


  static const String importNotes = "Important Notes";
  static const String notesTitle = "IMPORTANT NOTES";
  static const List<String> notes = [
    "Reference distance is based on sea level, standard day, no wind or slope, and maximum available reverse thrust.",
    "MAX MANUAL assumes maximum achievable manual braking.",
    "Reference Distance includes an air distance allowance of 1500 ft from threshold to touchdown.",
    "Actual (unfactored) distances are shown.",
    "Verify that the current crosswind component (CWC) is within the maximum recommended values according to the selected RWY CONDITION.",
  ];
  static const String returnback = "RETURN";

}
