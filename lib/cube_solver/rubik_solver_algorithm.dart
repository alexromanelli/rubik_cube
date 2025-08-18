import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';

interface class SolverAlgorithm {
  CubeSolverSolution? solveCubeInstance() {
    return null;
  }

  void returnToInitialState() {}
}
