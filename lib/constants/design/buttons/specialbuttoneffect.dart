import 'package:flutter/material.dart';

class SpecialButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;

  const SpecialButton({
    super.key,
    required this.child,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: child,
    );
  }
}



//class SpecialButtonEffect {
 // const SpecialButtonEffect();

  //static const String effectId = 'ButtonEffect.SpecialButtonEffect';
//}

//SpecialButton(
  //onPressed: () {
    //print('Botón presionado');
  //},
  //child: const Text('Aceptar'),
//)   