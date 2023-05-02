import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:tools_app/screens/screenBright.dart';
import 'package:torch_controller/torch_controller.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  TorchController().initialize();
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
  bool isTorchOn = false;
  final torchController = TorchController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadInits();
    checkTorch();
  }

  loadInits() async {
    isFlashAvailable = await torchController.hasTorch ?? false;
    setState(() {});
  }

  checkTorch() async {
    if (isFlashAvailable) {
      isTorchOn = await torchController.isTorchActive ?? false;
      setState(() {});
    }
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
                onTap: () async {
                  if (isTorchOn) {
                    await torchController.toggle();
                  } else {
                    await torchController.toggle();
                  }
                  isTorchOn = !isTorchOn;
                  setState(() {});
                },
                child: SvgPicture.asset(
                  "assets/flashlight.svg",
                  color: isTorchOn ? Colors.green : Colors.white,
                ),
              ),
            InkWell(
              onTap: () async {
                currBrightness = await ScreenBrightness().current;
                log("Current brightnes: $currBrightness");
                if (!mounted) return;
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
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                            "https://www.flaticon.com/free-icons/flashlight");
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: const Text(
                        "Flashlight icons created by Aranagraphics - Flaticon",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                            "https://www.flaticon.com/free-icons/flashlight");
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: const Text(
                        "Idea icons created by Good Ware - Flaticon",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () async {
                        final url = Uri.parse(
                            "https://www.flaticon.com/free-icons/flashlight");
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: const Text(
                        "Info icon by Stockio.com",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
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
