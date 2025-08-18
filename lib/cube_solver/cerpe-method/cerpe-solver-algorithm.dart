import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';

class CerpeSolverAlgorithm implements SolverAlgorithm {
  @override
  CubeSolverSolution? solveCubeInstance() {
    List<FaceMovementLog> listMov = runStepOneAlgorithm();
    currentSolution.movementSequence.addAll(listMov);
    listMov = runStepTwoAlgorithm();
    currentSolution.movementSequence.addAll(listMov);
    listMov = runStepThreeAlgorithm();
    currentSolution.movementSequence.addAll(listMov);
    listMov = runStepFourAlgorithm();
    currentSolution.movementSequence.addAll(listMov);
    listMov = runStepFiveAlgorithm();
    currentSolution.movementSequence.addAll(listMov);
    listMov = runStepSixAlgorithm();
    currentSolution.movementSequence.addAll(listMov);
    listMov = runStepSevenAlgorithm();
    currentSolution.movementSequence.addAll(listMov);
  }

  late CubeSolverSolution currentSolution;

  FulanoSolverAlgorithm() {
    currentSolution = CubeSolverSolution();
    currentSolution.setInitialState();
  }

  List<FaceMovementLog> runStepOneAlgorithm() {
    return <FaceMovementLog>[];
  }

  List<FaceMovementLog> runStepTwoAlgorithm() {
    return <FaceMovementLog>[];
  }

  List<FaceMovementLog> runStepThreeAlgorithm() {
    return <FaceMovementLog>[];
  }

  List<FaceMovementLog> runStepFourAlgorithm() {
    return <FaceMovementLog>[];
  }

  List<FaceMovementLog> runStepFiveAlgorithm() {
    return <FaceMovementLog>[];
  }

  List<FaceMovementLog> runStepSixAlgorithm() {
    return <FaceMovementLog>[];
  }

  List<FaceMovementLog> runStepSevenAlgorithm() {
    return <FaceMovementLog>[];
  }
}
