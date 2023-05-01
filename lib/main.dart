import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:be_prepared/screens/Flash.dart';
import 'package:be_preapred/screens/screenBright.dart';
import 'package:torch_light/torch_light.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Be Prepared',
      theme: ThemeData.dark(),
      home: const MyHomePage(title: 'Be Prepared'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFlashAvailable = false;
  double currBrightness = 0.0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInits();
  }

  loadInits() async {
    isFlashAvailable = await TorchLight.isTorchAvailable();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Be Prepared"),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 20,
          ),
          children: [
            if (isFlashAvailable)
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const FLashLight(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  "assets/flashlight.svg",
                  color: Colors.white,
                ),
              ),
            InkWell(
              onTap: () async {
                currBrightness = await ScreenBrightness().current;
                log("Current brightnes: $currBrightness");
                Navigator.of(context)
                    .push(
                  MaterialPageRoute(
                    builder: (ctx) => const ScreenBright(),
                  ),
                )
                    .then((value) async {
                  await ScreenBrightness().setScreenBrightness(currBrightness);
                });
              },
              child: SvgPicture.asset(
                "assets/lightbulb.svg",
                color: Colors.white,
              ),
            ),
            InkWell(
              onTap: () {
                showAboutDialog(
                  context: context,
                  children: [
                    const Text("Icons used from Stockio.com & Flaticon.com"),
                  ],
                );
              },
              child: SvgPicture.asset(
                "assets/info.svg",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
