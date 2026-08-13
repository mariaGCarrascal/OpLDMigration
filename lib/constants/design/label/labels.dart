import 'package:flutter/material.dart';
//import 'package:flutter_application_5/constants/design/text/app_text.dart';

class ComingSoonBadge extends StatelessWidget {
  const ComingSoonBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
                  padding: EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Configuration Type:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
  }
}
