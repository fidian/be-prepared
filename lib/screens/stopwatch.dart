import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StopWatch extends StatefulWidget {
  const StopWatch({super.key});

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {
  int time = 0;
  Timer? timer;
  String toShow = '0.00';
  SharedPreferences? prefs;
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
    prefs ??= await SharedPreferences.getInstance();
    if (prefs?.getBool("isRunning") ?? false) {
      time = prefs?.getInt("time") ?? 0;
      init();
    }
  }

  init() {
    if (timer != null) {
      if (timer!.isActive) return;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      time++;

      if (Duration(seconds: time) < const Duration(seconds: 60)) {
        toShow =
            Duration(seconds: time).toString().split(":").last.substring(0, 5);
      } else if (Duration(seconds: time) > const Duration(seconds: 60) &&
          Duration(seconds: time) < const Duration(minutes: 60)) {
        toShow = Duration(seconds: time).toString().substring(2, 10);
      } else {
        toShow = Duration(seconds: time).toString().substring(0, 10);
      }
      setState(() {});
      await prefs?.setInt("time", time);
      await prefs?.setBool("isRunning", true);
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
              style: const TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: size.height * 0.15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                button(context, size, () => init(), "Start"),
                button(context, size, () async {
                  if (timer != null) {
                    timer?.cancel();
                  }
                  await prefs?.setBool("isRunning", false);
                }, "pause")
              ],
            ),
            button(context, size, () async {
              time = 0;
              toShow = '0.00';
              if (timer != null) {
                timer?.cancel();
              }
              await prefs?.setBool("isRunning", false);
              setState(() {});
            }, "Reset")
          ],
        ),
      ),
    );
  }

  Widget button(BuildContext ctx, Size size, VoidCallback ontap, String text) {
    return ElevatedButton(
      onPressed: ontap,
      child: Text(text),
    );
  }
}
