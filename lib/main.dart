import 'dart:developer';

import 'package:be_prepared/screens/Mirror.dart';
import 'package:be_prepared/screens/countdown.dart';
import 'package:be_prepared/screens/magnify.dart';
import 'package:be_prepared/screens/stopwatch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:be_prepared/screens/screenBright.dart';
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
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
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
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
                    await ScreenBrightness()
                        .setScreenBrightness(currBrightness);
                  });
                },
                child: SvgPicture.asset(
                  "assets/lightbulb.svg",
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const Magnify(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  "assets/magnify.svg",
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const Mirror(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  "assets/mirror.svg",
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const StopWatch(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  "assets/stopwatch.svg",
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (!mounted) return;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const CountDownTimer(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  "assets/hourglass.svg",
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  dialog();
                },
                child: SvgPicture.asset(
                  "assets/info.svg",
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  dialog() {
    showAboutDialog(
      context: context,
      children: [
        InkWell(
          onTap: () async {
            final url =
                Uri.parse("https://www.flaticon.com/free-icons/flashlight");
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
            final url = Uri.parse("https://www.flaticon.com/free-icons/idea");
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
            final url = Uri.parse("https://www.stockio.com/free-icon/info");
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
        const Divider(),
        InkWell(
          onTap: () async {
            final url = Uri.parse(
                "https://www.flaticon.com/free-icons/magnifying-glass");
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
          child: const Text(
            "Magnifying glass icons created by Freepik - Flaticon",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () async {
            final url = Uri.parse("https://www.flaticon.com/free-icons/mirror");
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
          child: const Text(
            "Mirror icons created by catkuro - Flaticon",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () async {
            final url =
                Uri.parse("https://www.flaticon.com/free-icons/stopwatch");
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
          child: const Text(
            "Stopwatch icons created by Good Ware - Flaticon",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () async {
            final url = Uri.parse("https://www.flaticon.com/free-icons/timer");
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
          child: const Text(
            "Timer icons created by Freepik - Flaticon",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () async {
            final url = Uri.parse("https://www.flaticon.com/free-icons/pause");
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
          child: const Text(
            "Pause icons created by Freepik - Flaticon",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const Divider(),
        InkWell(
          onTap: () async {
            final url = Uri.parse("https://www.flaticon.com/free-icons/video");
            await launchUrl(
              url,
              mode: LaunchMode.externalApplication,
            );
          },
          child: const Text(
            "Video icons created by Bingge Liu - Flaticon",
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ],
    );
  }
}
