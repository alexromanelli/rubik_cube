import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';

class AlgorithmStepResult {
  bool success;
  List<FaceMovementLog> logList;

  AlgorithmStepResult(this.success, this.logList);
}

interface class SolverAlgorithm {
  CubeSolverSolution? solveCubeInstance() {
    return null;
  }

  void returnToInitialState() {}
}
