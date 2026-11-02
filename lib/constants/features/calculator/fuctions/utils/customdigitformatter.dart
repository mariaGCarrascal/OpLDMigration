import 'package:flutter/services.dart';

class Customdigitformatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    //Permitir borrar completamente el campo.
    if (text.isEmpty) {
      return newValue;
    }

    //Si todos los caracteres son dígitos.
    if (!RegExp(r'^\d+$').hasMatch(text)) {
      return oldValue;
    }

    //Si solamente contiene ceros, permitir hasta 5 dígitos.
    if (RegExp(r'^0+$').hasMatch(text)) {
      if (text.length <= 5) {
        return newValue;
      }

      return oldValue;
    }

    //Si contiene algún dígito diferente de 0, máximo 4 dígitos permitidos.
    if (text.length <= 4) {
      return newValue;
    }

    return oldValue;
  }
}