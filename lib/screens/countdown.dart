import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class CountDownTimer extends StatefulWidget {
  const CountDownTimer({super.key});

  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer> {
  int h1 = 0, h2 = 0, m1 = 0, m2 = 0, s1 = 0, s2 = 0;
  Timer? timer;
  bool isActive = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
    //setupLocalNotifications();
  }

  initialize() async {
    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      ),
      onDidReceiveNotificationResponse: (details) {
        //noti = "normal: ${details.payload!}";
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  setupLocalNotifications(String title, String msg, Duration duratuion) async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      msg,
      tz.TZDateTime.now(tz.local).add(duratuion),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "0",
          "notification",
          channelDescription: "this is used to create notification",
          priority: Priority.high,
          importance: Importance.high,
          fullScreenIntent: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Count Down Timer"),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //hour
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (h1 == 2 || isActive) {
                            return;
                          }
                          setState(() {
                            h1++;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 50,
                        ),
                      ),
                      Text(
                        "$h1",
                        style: const TextStyle(fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          if (h1 == 0 || isActive) {
                            return;
                          }
                          setState(() {
                            h1--;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (h2 == 9 || isActive) return;
                          setState(() {
                            h2++;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 50,
                        ),
                      ),
                      Text(
                        "$h2",
                        style: const TextStyle(fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          if (h2 == 0 || isActive) return;
                          setState(() {
                            h2--;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                  const Text(":"),
                  //minute
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (m1 == 5 || isActive) return;
                          setState(() {
                            m1++;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 50,
                        ),
                      ),
                      Text(
                        "$m1",
                        style: const TextStyle(fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          if (m1 == 0 || isActive) return;
                          setState(() {
                            m1--;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (m2 == 9 || isActive) return;
                          setState(() {
                            m2++;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 50,
                        ),
                      ),
                      Text(
                        "$m2",
                        style: const TextStyle(fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          if (m2 == 0 || isActive) return;
                          setState(() {
                            m2--;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                  const Text(":"),
                  //second
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (s1 == 5 || isActive) return;
                          setState(() {
                            s1++;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 50,
                        ),
                      ),
                      Text(
                        "$s1",
                        style: const TextStyle(fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          if (s1 == 0 || isActive) return;
                          setState(() {
                            s1--;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      InkWell(
                        onTap: () {
                          if (s2 == 9 || isActive) return;
                          setState(() {
                            s2++;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 50,
                        ),
                      ),
                      Text(
                        "$s2",
                        style: const TextStyle(fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          if (s2 == 0 || isActive) return;
                          setState(() {
                            s2--;
                          });
                        },
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (h1 == 2 && h2 > 3) {
                      errorMessage();
                      return;
                    }
                    if (timer != null) {
                      if (timer!.isActive) return;
                    }
                    var time = Duration(
                      hours: int.parse("$h1$h2"),
                      minutes: int.parse("$m1$m2"),
                      seconds: int.parse("$s1$s2"),
                    );
                    setupLocalNotifications("Count Down",
                        "Your Count Down Timer has finished", time);
                    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
                      time -= const Duration(seconds: 1);
                      List<String> t = time.toString().split(":");
                      if (t[0].length == 2) {
                        h1 = int.parse(t[0][0]);
                        h2 = int.parse(t[0][1]);
                      } else {
                        h1 = 0;
                        h2 = int.parse(t[0][0]);
                      }
                      m1 = int.parse(t[1][0]);
                      m2 = int.parse(t[1][1]);
                      List<String> ts = t[2].split(".");
                      s1 = int.parse(ts[0][0]);
                      s2 = int.parse(ts[0][1]);
                      isActive = true;
                      setState(() {});
                      if (time == const Duration(seconds: 0)) {
                        timer.cancel();
                        isActive = false;
                      }
                      log(time.toString());
                    });
                  },
                  child: const Text("Set"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (timer != null) {
                      isActive = false;
                      timer?.cancel();
                    }
                  },
                  child: const Text("Cancel"),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                h1 = h2 = m1 = m2 = s1 = s2 = 0;

                if (timer != null) {
                  isActive = false;
                  timer?.cancel();
                }
                setState(() {});
              },
              child: const Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }

  errorMessage() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text("Maximum of 1 day (23:59:59) can be set"),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(ctx);
                },
                child: const Text("OK"),
              ),
            ],
          );
        });
  }
}
