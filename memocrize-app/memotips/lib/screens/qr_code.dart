import 'package:flutter/material.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:gap/gap.dart';
import 'package:glossy/glossy.dart';
import 'package:memotips/screens/Collections/collections.dart';
import 'package:memotips/screens/home.dart';

class QrCode extends StatefulWidget {
  const QrCode({super.key});

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ReaderWidget(
          actionButtonsAlignment: Alignment(-10, -10),
          onScan: (result) async {
            // Do something with the result
            print(result.text);
            // verified once then shift it to the app home
            Navigator.pushReplacement(context, PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return Collections();
              },
            ));
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Scan the QR",
                style: TextStyle(
                    fontSize: 48,
                    height: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Text(
                "Memotips",
                style: TextStyle(
                  fontSize: 64,
                  height: 1,
                  fontWeight: FontWeight.bold,
                  color: Color(0xffFF8484),
                ),
              ),
              Gap(60),
            ],
          ),
        ),
      ],
    );
  }
}
