import 'package:flutter/material.dart';
import 'package:flutter_application_5/constants/design/text/app_text.dart';
import 'package:flutter_application_5/constants/strings/app_strings.dart';

class Normalnonlabel extends StatelessWidget {
  const Normalnonlabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
                  padding: EdgeInsets.only(top: 20.0),
                    child: OpLDAppText.bold(
                      AppStrings.normalNonnormalSection,
                      color: Colors.white,
                    ),
                  );
  }
}
