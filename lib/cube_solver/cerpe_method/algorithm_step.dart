import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';

interface class AlgorithmStep {
  AlgorithmStepResult runStep() {
    return AlgorithmStepResult(false, <FaceMovementLog>[]);
  }
}
