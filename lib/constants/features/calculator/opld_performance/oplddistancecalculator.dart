class Oplddistancecalculator{

  final String? aircraftPicker;
  final String? landingPicker;
  final String? configurationPicker;
  final String? factor;
  final String? additive;
  final String? flapPicker;
  final String? rwyConditionPicker;
  final String? autobrakePicker;
  final String? revsrinopPicker;
  final String? speedbrakesPicker;
  final String? weightRef;
  final String? altitudeRef;
  final String? isaRef;
  final String? slopeRef;
  final String? windRef;
  final String? vrefRef;  

    Oplddistancecalculator({ 
      this.aircraftPicker, this.landingPicker, this.configurationPicker,
      this.factor, this.additive, this.flapPicker, this.rwyConditionPicker, 
      this.autobrakePicker, this.revsrinopPicker, this.speedbrakesPicker, 
      this.weightRef, this.altitudeRef, this.isaRef, this.slopeRef, this.windRef, this.vrefRef
    });

    String call() {

    try {

      return "0"; 
      
    } catch (e) {
      return "0"; 
    }
  }

}
