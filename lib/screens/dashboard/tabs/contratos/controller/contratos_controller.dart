import 'dart:convert';
import 'dart:typed_data';

class ContratosController {
  Uint8List? image;

  saveSignature(Uint8List imagebyte) {
    this.image = imagebyte;
    print(_imageByteToString(imagebyte));
  }

  String _imageByteToString(Uint8List imageBytes) {
    return base64Encode(imageBytes);
  }
}
