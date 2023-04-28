import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';

class FLashLight extends StatefulWidget {
  const FLashLight({super.key});

  @override
  State<FLashLight> createState() => _FLashLightState();
}

class _FLashLightState extends State<FLashLight> {
  bool isTorchOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlashLight"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            if (isTorchOn) {
              await TorchLight.disableTorch();
            } else {
              await TorchLight.enableTorch();
            }
            isTorchOn = !isTorchOn;
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isTorchOn ? Colors.red : Colors.green,
                  width: 2,
                ),
              ),
              padding: const EdgeInsets.all(10)),
          child: Text(
            isTorchOn ? "Turn Off" : "Turn On",
            style: const TextStyle(fontSize: 32),
          ),
        ),
      ),
    );
  }
}
