import 'package:rubik_cube/cube_solver/cerpe-method/step-algorithm.dart';
import 'package:rubik_cube/cube_solver/cerpe-method/step1-algorithm.dart';
import 'package:rubik_cube/cube_solver/cerpe-method/step2-algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

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

    return currentSolution;
  }

  CubeSolverSolution currentSolution = CubeSolverSolution();

  CerpeSolverAlgorithm() {
    currentSolution.clear();
  }

  List<FaceMovementLog> runStepOneAlgorithm() {
    StepAlgorithm step1 = Step1Algorithm();
    return step1.runStep();
  }

  List<FaceMovementLog> runStepTwoAlgorithm() {
    StepAlgorithm step2 = Step2Algorithm();
    return step2.runStep();
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

  @override
  void returnToInitialState() {
    RubikCube.resetCubeToState(currentSolution.initialState);
  }
}
