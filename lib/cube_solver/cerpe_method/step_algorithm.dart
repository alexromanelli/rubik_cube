import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';

interface class StepAlgorithm {
  AlgorithmStepResult runStep() {
    return AlgorithmStepResult(false, <FaceMovementLog>[]);
  }
}
