import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key, this.isRunning, this.time});
  final bool? isRunning;
  final int? time;

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  int time = 0;
  Timer? timer;
  String toShow = '00:00:00';
  SharedPreferences? prefs;
  bool isRunning = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPrefs();
    initialize();
  }

  initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  initialize() async {
    // if (widget.isRunning ?? false) {
    //   time = widget.time ?? 0;
    //   init();
    // }
    prefs ??= await SharedPreferences.getInstance();
    if (prefs?.getBool("isStopWatchRunning") ?? false) {
      time = prefs?.getInt("stopWatchTime") ?? 0;
      init();
    }
  }

  init() {
    if (timer != null) {
      if (timer!.isActive) return;
    }
    isRunning = true;
    setState(() {});

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      time++;

      // if (Duration(seconds: time) < const Duration(seconds: 60)) {
      //   toShow =
      //       Duration(seconds: time).toString().split(":").last.substring(0, 5);
      // } else if (Duration(seconds: time) > const Duration(seconds: 60) &&
      //     Duration(seconds: time) < const Duration(minutes: 60)) {
      //   toShow = Duration(seconds: time).toString().substring(2, 10);
      // } else {
      //   toShow = Duration(seconds: time).toString().substring(0, 10);
      // }
      toShow = Duration(seconds: time).toString().split(".").first;
      isRunning = true;
      setState(() {});
      await prefs?.setInt("stopWatchTime", time);
      await prefs?.setBool("isStopWatchRunning", true);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    double textSize = isPortrait ? size.height * 0.1 : size.width * 0.08;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stop Watch"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              toShow,
              style: TextStyle(fontSize: textSize),
            ),
            SizedBox(
              height: size.height * 0.15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                button(context, size, () async {
                  if (!isRunning) {
                    init();
                  } else {
                    if (timer != null) {
                      timer?.cancel();
                    }
                    isRunning = false;
                    await prefs?.setBool("isStopWatchRunning", false);
                  }
                  setState(() {});
                }, isRunning ? "pause" : "play"),
                // button(context, size, () async {
                //   if (timer != null) {
                //     timer?.cancel();
                //   }
                //   await prefs?.setBool("isStopWatchRunning", false);
                // }, "pause")
                button(context, size, () async {
                  time = 0;
                  toShow = '00:00:00';
                  isRunning = false;
                  if (timer != null) {
                    timer?.cancel();
                  }
                  await prefs?.setBool("isStopWatchRunning", false);
                  setState(() {});
                }, "reset")
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget button(BuildContext ctx, Size size, VoidCallback ontap, String text) {
    return InkWell(
      onTap: ontap,
      child: SvgPicture.asset(
        "assets/$text.svg",
        color: Colors.white,
        height: MediaQuery.of(context).orientation == Orientation.portrait
            ? size.height * 0.1
            : size.width * 0.1,
      ),
    );

    // ElevatedButton(
    //   onPressed: ontap,
    //   child: Text(text),
    // );
  }
}
