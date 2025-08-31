import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step.dart';
import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step1.dart';
import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step2.dart';
import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step3.dart';
import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step4.dart';
import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step5.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

class CerpeSolverAlgorithm implements SolverAlgorithm {
  @override
  CubeSolverSolution? solveCubeInstance() {
    AlgorithmStepResult stepResult = runAlgorithmStepOne();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runAlgorithmStepTwo();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runAlgorithmStepThree();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runAlgorithmStepFour();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runAlgorithmStepFive();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runAlgorithmStepSix();
    if (!stepResult.success) {
      return null;
    }
    currentSolution.movementSequence.addAll(stepResult.logList);
    stepResult = runAlgorithmStepSeven();
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

  AlgorithmStepResult runAlgorithmStepOne() {
    AlgorithmStep step1 = AlgorithmStep1() as AlgorithmStep;
    AlgorithmStepResult result = step1.runStep();
    return result;
  }

  AlgorithmStepResult runAlgorithmStepTwo() {
    AlgorithmStep step2 = AlgorithmStep2();
    return step2.runStep();
  }

  AlgorithmStepResult runAlgorithmStepThree() {
    AlgorithmStep step3 = AlgorithmStep3();
    return step3.runStep();
  }

  AlgorithmStepResult runAlgorithmStepFour() {
    AlgorithmStep step4 = AlgorithmStep4();
    return step4.runStep();
  }

  AlgorithmStepResult runAlgorithmStepFive() {
    AlgorithmStep step5 = AlgorithmStep5();
    return step5.runStep();
  }

  AlgorithmStepResult runAlgorithmStepSix() {
    return AlgorithmStepResult(true, <FaceMovementLog>[]);
  }

  AlgorithmStepResult runAlgorithmStepSeven() {
    return AlgorithmStepResult(true, <FaceMovementLog>[]);
  }

  @override
  void returnToInitialState() {
    RubikCube.resetCubeToState(currentSolution.initialState);
  }
}
