import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import 'package:vlalmir_workana_screens/screens/dashboard/tabs/contratos/controller/contratos_controller.dart';

class AssinaturaTab extends StatefulWidget {
  final ContratosController contratosController;
  final Orientation orientation;
  const AssinaturaTab({Key? key, required this.contratosController, required this.orientation})
      : super(key: key);
  @override
  _AssinaturaTabState createState() => _AssinaturaTabState();
}

class _AssinaturaTabState extends State<AssinaturaTab> {
  var _signatureController = SignatureController();

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isPOrtrait = widget.orientation == Orientation.portrait;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 60,
              height: 380,
              child: Signature(
                controller: _signatureController,
                backgroundColor: Colors.white,
                height: 380,
                width: MediaQuery.of(context).size.width - 60,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: isPOrtrait ? 320 : 750,
              child: Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 15,
                spacing: 20,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      onPressed: () {
                        _signatureController.clear();
                      },
                      child: Text('Limpar Assinatura')),
                  ElevatedButton(onPressed: _saveImage, child: Text('Confirmar'))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _saveImage() async {
    var imageByte = await _signatureController.toPngBytes();
    if (imageByte != null) {
      widget.contratosController.saveSignature(imageByte);
    }
  }
}
