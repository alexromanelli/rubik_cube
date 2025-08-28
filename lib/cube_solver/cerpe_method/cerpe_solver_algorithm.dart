import 'package:rubik_cube/cube_solver/cerpe_method/step1_algorithm.dart';
import 'package:rubik_cube/cube_solver/cerpe_method/step2_algorithm.dart';
import 'package:rubik_cube/cube_solver/cerpe_method/step3_algorithm_v2.dart';
import 'package:rubik_cube/cube_solver/cerpe_method/step_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

class CerpeSolverAlgorithm implements SolverAlgorithm {
  @override
  CubeSolverSolution? solveCubeInstance() {
    AlgorithmStepResult stepResult = runStepOneAlgorithm();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runStepTwoAlgorithm();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runStepThreeAlgorithm();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runStepFourAlgorithm();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runStepFiveAlgorithm();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runStepSixAlgorithm();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runStepSevenAlgorithm();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);

    return currentSolution;
  }

  CubeSolverSolution currentSolution = CubeSolverSolution();

  CerpeSolverAlgorithm() {
    currentSolution.clear();
  }

  AlgorithmStepResult runStepOneAlgorithm() {
    StepAlgorithm step1 = Step1Algorithm() as StepAlgorithm;
    AlgorithmStepResult result = step1.runStep();
    return result;
  }

  AlgorithmStepResult runStepTwoAlgorithm() {
    StepAlgorithm step2 = Step2Algorithm();
    return step2.runStep();
  }

  AlgorithmStepResult runStepThreeAlgorithm() {
    StepAlgorithm step3 = Step3AlgorithmV2();
    return step3.runStep();
  }

  AlgorithmStepResult runStepFourAlgorithm() {
    return AlgorithmStepResult(true, <FaceMovementLog>[]);
  }

  AlgorithmStepResult runStepFiveAlgorithm() {
    return AlgorithmStepResult(true, <FaceMovementLog>[]);
  }

  AlgorithmStepResult runStepSixAlgorithm() {
    return AlgorithmStepResult(true, <FaceMovementLog>[]);
  }

  AlgorithmStepResult runStepSevenAlgorithm() {
    return AlgorithmStepResult(true, <FaceMovementLog>[]);
  }

  @override
  void returnToInitialState() {
    RubikCube.resetCubeToState(currentSolution.initialState);
  }
}
