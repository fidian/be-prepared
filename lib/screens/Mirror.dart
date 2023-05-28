import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class Mirror extends StatefulWidget {
  const Mirror({super.key});

  @override
  State<Mirror> createState() => _MirrorState();
}

class _MirrorState extends State<Mirror> {
  PermissionStatus? permissionStatus;
  late List<CameraDescription> _cameras;
  late CameraController controller;
  double zoom = 1.0;
  double scale = 1.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initialize();
  }

  initialize() async {
    permissionStatus = await Permission.camera.request();
    _cameras = await availableCameras();
    controller = CameraController(_cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) async {
      if (!mounted) {
        return;
      }

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
          //log("scale start: $details");
          //log("-------------------------------------------------------------");
          zoom = scale;
          //log("start: $zoom");
        },
        onScaleUpdate: (details) async {
          if (details.pointerCount != 2) return;
          if (details.scale == 1.0) {
            log("in if scale: ${details.scale}");
            return;
          } else {
            //scale += details.scale.clamp(1, 10);
          }
          //log("scale update: $details");
          // zoom = zoom * details.scale;
          // if (zoom * details.scale < 1 || zoom * details.scale > 8) {
          //   log("value: ${zoom * details.scale}");
          //   return;
          // }
          //zoom *= details.scale;
          // await controller.setZoomLevel(zoom * details.scale);
          //log("clamp: ${details.scale.clamp(1.0, 10.0)}");
          //scale = details.scale.clamp(1, 10);
          //log("update: $scale");
          if (zoom * details.scale > await controller.getMaxZoomLevel() ||
              zoom * details.scale < await controller.getMinZoomLevel()) {
            log("if check ${zoom * details.scale}");
            return;
          }
          await controller.setZoomLevel(zoom * details.scale);
          scale = zoom * details.scale;
        },
        onScaleEnd: (details) {
          //zoom *= scale;
        },
        child: permissionStatus == null
            ? const Center(
                child: Text("Checking Camera"),
              )
            : permissionStatus == PermissionStatus.granted
                ? camera(context)
                : const Center(
                    child: Text("Camera Permission is denied"),
                  ),
      ),
    );
  }

  bool isPaused = false;

  Widget camera(BuildContext ctx) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // Transform(
        //   alignment: Alignment.center,
        //   transform: Matrix4.rotationY(math.pi),
        //   child: CameraPreview(controller),
        // ),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: CameraPreview(controller),
        ),
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
        )
      ],
    );
  }
}
