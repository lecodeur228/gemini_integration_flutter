import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:text_scan_ia/constants.dart';
import 'package:text_scan_ia/models/question.dart';

class GeminieService {
  final model = GenerativeModel(model: "gemini-pro", apiKey: apiKey);

Future<Question?> showResponse(String prompt, [String? image]) async {
  // Vérifier si une image est fournie
  if (image == null) {
    throw ArgumentError("Image path cannot be null");
  }

  final imgRead = await File(image).readAsBytes();
  final imgPart = DataPart("image/jpeg", imgRead);

  final content = Content.multi([TextPart(prompt), imgPart]);

  final response = await model.generateContent([content]);

  return Question("GEMINI", response.text);
}

}
