import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class ScreenBright extends StatefulWidget {
  const ScreenBright({super.key});

  @override
  State<ScreenBright> createState() => _ScreenBrightState();
}

class _ScreenBrightState extends State<ScreenBright> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    increaseBrightness();
  }

  increaseBrightness() async {
    await ScreenBrightness().setScreenBrightness(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
