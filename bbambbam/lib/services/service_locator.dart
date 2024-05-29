import 'package:get_it/get_it.dart';

import './face_mesh_service.dart';
import 'model_inference_service.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton<FaceMesh>(FaceMesh());


  locator.registerLazySingleton<ModelInferenceService>(
      () => ModelInferenceService());
}