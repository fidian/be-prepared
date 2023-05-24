import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class Mirror extends StatefulWidget {
  const Mirror({super.key});

  @override
  State<Mirror> createState() => _MirrorState();
}

class _MirrorState extends State<Mirror> {
  PermissionStatus? permissionStatus;
  late List<CameraDescription> _cameras;
  late CameraController controller;

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
      body: permissionStatus == null
          ? const Center(
              child: Text("Checking Camera"),
            )
          : permissionStatus == PermissionStatus.granted
              ? camera(context)
              : const Center(
                  child: Text("Camera Permission is denied"),
                ),
    );
  }

  bool isPaused = false;

  Widget camera(BuildContext ctx) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
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
