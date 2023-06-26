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
  double zoom = 8.0;
  double scale = 8.0;
  double zooming = 0.0;
  double zoomDeccrement = 0.0;
  double maxZoom = 0.0;
  double minZoom = 0.0;

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
      zooming = zoom;
      maxZoom = zoom;
      minZoom = await controller.getMinZoomLevel();
      log("Max zoom level: $zoom");
      log("Min zoom level: ${await controller.getMinZoomLevel()}");
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
          //log("scale start: $details");
          //log("-------------------------------------------------------------");
          zoom = scale;
          //log("start: $zoom");
        },
        onScaleUpdate: (details) async {
          if (details.pointerCount != 2) return;
          if (details.scale == 1.0) {
            //log("in if scale: ${details.scale}");
            return;
          } else {
            //scale += details.scale.clamp(1, 10);
          }
          //log("scale update: ${details.scale}");
          // zoom = zoom * details.scale;
          // if (zoom * details.scale < 1 || zoom * details.scale > 8) {
          //   log("value: ${zoom * details.scale}");
          //   return;
          // }
          //zoom *= details.scale;
          //await controller.setZoomLevel(zoom * details.scale);
          //log("clamp: ${details.scale.clamp(1.0, 10.0)}");
          //scale = details.scale.clamp(1, 10);
          //log("update: $scale");

          if (zoom * details.scale > maxZoom) {
            log("greater than max ${zoom * details.scale}");
            await controller.setZoomLevel(maxZoom);
            return;
          } else if (zoom * details.scale < minZoom) {
            log("greater than max ${zoom * details.scale}");
            await controller.setZoomLevel(minZoom);
            return;
          } else {
            await controller.setZoomLevel(zoom * details.scale);
          }
          scale = zoom * details.scale;
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
    //Size size = MediaQuery.of(context).size;
    var camera = controller.value;
    // fetch screen size
    final size = MediaQuery.of(context).size;

    // calculate scale depending on screen and camera ratios
    // this is actually size.aspectRatio / (1 / camera.aspectRatio)
    // because camera preview size is received as landscape
    // but we're calculating for portrait orientation
    var scale = size.aspectRatio * camera.aspectRatio;

    // to prevent scaling down, invert the value
    if (scale < 1) scale = 1 / scale;
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        // SizedBox(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   child: CameraPreview(
        //     controller,
        //   ),
        // ),

        // SizedBox(
        //   height: MediaQuery.of(context).size.height,
        //   width: MediaQuery.of(context).size.width,
        //   child: AspectRatio(
        //     aspectRatio: controller.value.aspectRatio,
        //     child: CameraPreview(controller),
        //   ),
        // ),

        Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(controller),
          ),
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
