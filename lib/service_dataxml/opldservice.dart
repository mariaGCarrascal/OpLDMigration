import 'package:flutter/services.dart';
import 'package:xml/xml.dart';

class OpLdService {
  OpLdService._();

  static final OpLdService instance = OpLdService._();

  late final XmlDocument document;

  Future<void> initialize() async {
    final xmlString = await rootBundle.loadString(
      'assets/data/tables/OpLDinfoFromTables.xml',
    );

    document = XmlDocument.parse(xmlString);
  }
}