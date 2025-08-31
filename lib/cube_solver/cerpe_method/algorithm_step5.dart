import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

enum Step5Cases { point, l, row, completeCross, none }

class AlgorithmStep5 implements AlgorithmStep {
  @override
  AlgorithmStepResult runStep() {
    AlgorithmStepResult result = AlgorithmStepResult(true, <FaceMovementLog>[]);

    Step5Cases caseIdentity = Step5Cases.none;
    // while case is not complete crux
    while (caseIdentity != Step5Cases.completeCross) {
      // identify current case
      caseIdentity = identifyCaseWithUpSideRotation(result.logList);
      // apply algorithm for current case
      switch (caseIdentity) {
        case Step5Cases.point || Step5Cases.l || Step5Cases.row:
          addMovementsForCasePointOrLOrRow(result.logList);
          break;
        case Step5Cases.completeCross:
          // nothing to do because the goal is reached
          break;
        case Step5Cases.none:
      }
    }

    return result;
  }

  Step5Cases identifyCaseWithUpSideRotation(List<FaceMovementLog> logList) {
    Step5Cases caseIdentity = Step5Cases.none;
    while (caseIdentity == Step5Cases.none) {
      // check cases
      if (checkCasePoint()) {
        caseIdentity = Step5Cases.point;
      } else if (checkCaseL()) {
        caseIdentity = Step5Cases.l;
      } else if (checkCaseRow()) {
        caseIdentity = Step5Cases.row;
      } else if (checkCaseCompleteCross()) {
        caseIdentity = Step5Cases.completeCross;
      } else {
        // rotate up side
        RubikSolverMovement.doMovement(Face.front, Movement.U);
        logList.add(FaceMovementLog(Face.front, Movement.U));
      }
    }
    return caseIdentity;
  }

  void addMovementsForCasePointOrLOrRow(List<FaceMovementLog> logList) {
    List<Movement> movementList = <Movement>[Movement.F, Movement.R, Movement.U, Movement.R_, Movement.U_, Movement.F_];
    for (var movement in movementList) {
      logList.add(FaceMovementLog(Face.front, movement));
      RubikSolverMovement.doMovement(Face.front, movement);
    }
  }

  bool checkCasePoint() {
    bool condition1 = RubikCube.getColorName(Face.front, 0, 1) == ColorName.yellow;
    bool condition2 = RubikCube.getColorName(Face.right, 0, 1) == ColorName.yellow;
    if (condition1 && condition2) {
      return true;
    }
    return false;
  }

  bool checkCaseL() {
    bool condition1 = RubikCube.getColorName(Face.front, 0, 1) == ColorName.yellow;
    bool condition2 = RubikCube.getColorName(Face.right, 0, 1) == ColorName.yellow;
    bool condition3 = RubikCube.getColorName(Face.top, 0, 1) == ColorName.yellow;
    bool condition4 = RubikCube.getColorName(Face.top, 1, 0) == ColorName.yellow;
    bool condition5 = RubikCube.getColorName(Face.top, 1, 1) == ColorName.yellow;
    if (condition1 && condition2 && condition3 && condition4 && condition5) {
      return true;
    }
    return false;
  }

  bool checkCaseRow() {
    bool condition1 = RubikCube.getColorName(Face.front, 0, 1) == ColorName.yellow;
    bool condition2 = RubikCube.getColorName(Face.top, 1, 0) == ColorName.yellow;
    bool condition3 = RubikCube.getColorName(Face.top, 1, 1) == ColorName.yellow;
    bool condition4 = RubikCube.getColorName(Face.top, 1, 2) == ColorName.yellow;
    if (condition1 && condition2 && condition3 && condition4) {
      return true;
    }
    return false;
  }

  bool checkCaseCompleteCross() {
    bool condition1 = RubikCube.getColorName(Face.top, 0, 1) == ColorName.yellow;
    bool condition2 = RubikCube.getColorName(Face.top, 1, 0) == ColorName.yellow;
    bool condition3 = RubikCube.getColorName(Face.top, 1, 1) == ColorName.yellow;
    bool condition4 = RubikCube.getColorName(Face.top, 1, 2) == ColorName.yellow;
    bool condition5 = RubikCube.getColorName(Face.top, 2, 1) == ColorName.yellow;
    if (condition1 && condition2 && condition3 && condition4 && condition5) {
      return true;
    }
    return false;
  }
}
