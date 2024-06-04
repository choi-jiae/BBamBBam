import 'package:bbambbam/pages/driving/widget/face_mesh_painter.dart';
import 'package:bbambbam/services/model_inference_service.dart';
import 'package:bbambbam/services/service_locator.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ModelCameraPreview extends StatelessWidget {
  ModelCameraPreview({
    required this.cameraController,
    required this.draw,
    Key? key,
  }) : super(key: key);

  final CameraController? cameraController;
  final bool draw;

  late final double _ratio;
  final Map<String, dynamic>? inferenceResults =
      locator<ModelInferenceService>().inferenceResults;

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    _ratio = screenSize.width / cameraController!.value.previewSize!.height;

    return Stack(
      children: [
        CameraPreview(cameraController!),
        Visibility(visible: draw, child: _drawLandmarks
            // IndexedStack(
            //   index: index,
            //   children: [
            //     _drawBoundingBox,
            //     ,
            //     _drawHands,
            //     _drawPose,
            //   ],
            // ),
            ),
      ],
    );
  }

  // Widget get _drawBoundingBox {
  //   final bbox = inferenceResults?['bbox'];
  //   return _ModelPainter(
  //     customPainter: FaceDetectionPainter(
  //       bbox: bbox ?? Rect.zero,
  //       ratio: _ratio,
  //     ),
  //   );
  // }

  Widget get _drawLandmarks => _ModelPainter(
        customPainter: FaceMeshPainter(
          points: inferenceResults?['point'] ?? [],
          ratio: _ratio,
        ),
      );

  // Widget get _drawHands => _ModelPainter(
  //       customPainter: HandsPainter(
  //         points: inferenceResults?['point'] ?? [],
  //         ratio: _ratio,
  //       ),
  //     );

  // Widget get _drawPose => _ModelPainter(
  //       customPainter: PosePainter(
  //         points: inferenceResults?['point'] ?? [],
  //         ratio: _ratio,
  //       ),
  //     );
}

class _ModelPainter extends StatelessWidget {
  const _ModelPainter({
    required this.customPainter,
    Key? key,
  }) : super(key: key);

  final CustomPainter customPainter;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: customPainter,
    );
  }
}
