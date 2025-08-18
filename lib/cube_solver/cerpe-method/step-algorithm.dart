import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';

interface class StepAlgorithm {
  List<FaceMovementLog> runStep() {
    return <FaceMovementLog>[];
  }
}
