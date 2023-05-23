import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

class Magnify extends StatefulWidget {
  const Magnify({super.key});

  @override
  State<Magnify> createState() => _MagnifyState();
}

class _MagnifyState extends State<Magnify> {
  PermissionStatus? permissionStatus;
  late List<CameraDescription> _cameras;
  late CameraController controller;
  double zoom = 1.0;
  double scale = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  initialize() async {
    permissionStatus = await Permission.camera.request();
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) async {
      if (!mounted) {
        return;
      }
      zoom = await controller.getMaxZoomLevel();
      log("Max zoom level: $zoom");
      await controller.setZoomLevel(zoom);
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onScaleStart: (details) {
          log("scale start: $details");
        },
        onScaleUpdate: (details) async {
          log("scale update: $details");
          // zoom = zoom * details.scale;
          await controller.setZoomLevel(zoom * details.scale);
          //scale = details.scale;
        },
        onScaleEnd: (details) {
          //zoom *= scale;
        },
        child: Container(
          child: permissionStatus == null
              ? const Center(
                  child: Text("Checking Camera Permission"),
                )
              : permissionStatus == PermissionStatus.denied
                  ? const Center(
                      child: Text("You have Denied Permission to use Camera"),
                    )
                  : permissionStatus == PermissionStatus.granted
                      ? camera(context)
                      : const Center(
                          child: Text("Error Occured, Please Try again"),
                        ),
        ),
      ),
    );
  }

  bool isPaused = false;
  bool isFlashOn = false;

  Widget camera(BuildContext ctx) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        CameraPreview(controller),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () async {
              if (isPaused) {
                await controller.resumePreview();
              } else {
                await controller.pausePreview();
              }
              setState(() {
                isPaused = !isPaused;
              });
            },
            child: SizedBox(
              height: 50,
              width: 50,
              child: SvgPicture.asset(
                isPaused ? "assets/play.svg" : "assets/pause.svg",
                color: Colors.white,
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () async {
                isFlashOn = !isFlashOn;
                if (isFlashOn) {
                  controller.setFlashMode(FlashMode.torch);
                } else {
                  controller.setFlashMode(FlashMode.off);
                }

                setState(() {});
              },
              child: SizedBox(
                height: 50,
                width: 50,
                child: SvgPicture.asset(
                  "assets/flashlight.svg",
                  color: isFlashOn ? Colors.green : Colors.white,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
