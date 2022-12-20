import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {

  final CameraDescription camera;

  const CameraScreen({
    required this.camera,
    Key? key,
  }) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {

  late CameraController _controller;


  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}
