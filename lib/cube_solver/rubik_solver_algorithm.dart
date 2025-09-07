import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

class AlgorithmStepResult {
  bool success;
  List<FaceMovementLog> logList;

  AlgorithmStepResult(this.success, this.logList);

  static Map<Movement, Movement> mapMovementToOpposite = <Movement, Movement>{
    Movement.f: Movement.f_,
    Movement.f_: Movement.f,
    Movement.r: Movement.r_,
    Movement.r_: Movement.r,
    Movement.b: Movement.b_,
    Movement.b_: Movement.b,
    Movement.l: Movement.l_,
    Movement.l_: Movement.l,
    Movement.u: Movement.u_,
    Movement.u_: Movement.u,
    Movement.d: Movement.d_,
    Movement.d_: Movement.d,
  };

  static Map<Movement, Movement> mapMovementToDoubleMove = <Movement, Movement>{
    Movement.f: Movement.f2,
    Movement.r: Movement.r2,
    Movement.b: Movement.b2,
    Movement.l: Movement.l2,
    Movement.u: Movement.u2,
    Movement.d: Movement.d2,
    Movement.f_: Movement.f2,
    Movement.r_: Movement.r2,
    Movement.b_: Movement.b2,
    Movement.l_: Movement.l2,
    Movement.u_: Movement.u2,
    Movement.d_: Movement.d2,
  };

  static Map<Movement, Movement> mapDoubleMovementToSingleOne = <Movement, Movement>{
    Movement.f2: Movement.f,
    Movement.r2: Movement.r,
    Movement.b2: Movement.b,
    Movement.l2: Movement.l,
    Movement.u2: Movement.u,
    Movement.d2: Movement.f,
  };

  static bool moveIsDoubleMove(Movement mov) {
    return mov == Movement.f2 || mov == Movement.r2 || mov == Movement.b2 || mov == Movement.l2 || mov == Movement.u2 || mov == Movement.d2;
  }

  static bool movementsOnTheSameFace(Movement m1, Movement m2) {
    if (m1 == m2 || mapMovementToOpposite[m1] == m2 || mapMovementToDoubleMove[m1] == m2 || m1 == mapMovementToDoubleMove[m2]) {
      return true;
    }
    return false;
  }

  /*
  static void printMovementList(List<FaceMovementLog> list) {
    StringBuffer textMoveList = StringBuffer();
    textMoveList.write("Lista de Movimentos: ");
    for (var faceMovementLog in list) {
      textMoveList.write("${faceMovementLog.movement.name} ");
    }
    print(textMoveList.toString());
  }
   */

  /// This is a really naïve approach.
  static int logListAbbreviation(List<FaceMovementLog> logList) {
    int totalNumberOfRemovedMoves = 0;
    int numberOfRemovedMoves = 0;

    var newLogList = <FaceMovementLog>[];

    do {
      numberOfRemovedMoves = 0;
      var index = 0;
      while (index < logList.length) {
        if (index == logList.length - 1) {
          newLogList.add(FaceMovementLog(Face.front, logList.elementAt(index).movement));
          ++index;
          continue;
        }
        List<FaceMovementLog> sublist = logList.sublist(index, index + 2);
        var mov1 = sublist.elementAt(0).movement;
        var mov2 = sublist.elementAt(1).movement;
        var match = false;
        if (movementsOnTheSameFace(mov1, mov2)) {
          // (M e M) ou (M' e M') => M2
          if (mov1 == mov2 && !moveIsDoubleMove(mov1)) {
            newLogList.add(FaceMovementLog(Face.front, mapMovementToDoubleMove[mov1]!));
            ++numberOfRemovedMoves;
            match = true;
          } else if (mov1 == mov2 && moveIsDoubleMove(mov1)) {
            numberOfRemovedMoves += 2;
            match = true;
          } else if (!moveIsDoubleMove(mov1) && !moveIsDoubleMove(mov2) && mov1 == mapMovementToOpposite[mov2]) {
            numberOfRemovedMoves += 2;
            match = true;
          } else if (moveIsDoubleMove(mov1) && (mapDoubleMovementToSingleOne[mov1] == mov2 || mapDoubleMovementToSingleOne[mov1] == mapMovementToOpposite[mov2])) {
            newLogList.add(FaceMovementLog(Face.front, mapMovementToOpposite[mov2]!));
            ++numberOfRemovedMoves;
            match = true;
          } else if (moveIsDoubleMove(mov2) && (mapDoubleMovementToSingleOne[mov2] == mov1 || mapDoubleMovementToSingleOne[mov2] == mapMovementToOpposite[mov1])) {
            newLogList.add(FaceMovementLog(Face.front, mapMovementToOpposite[mov1]!));
            ++numberOfRemovedMoves;
            match = true;
          } else if (moveIsDoubleMove(mov1) && mapDoubleMovementToSingleOne[mov1] == mapMovementToOpposite[mov2]) {
            newLogList.add(FaceMovementLog(Face.front, mapMovementToOpposite[mov2]!));
            ++numberOfRemovedMoves;
            match = true;
          }
        } else {
          newLogList.add(logList.elementAt(index));
        }
        index += match ? 2 : 1;
      }
      totalNumberOfRemovedMoves += numberOfRemovedMoves;
      if (newLogList.isNotEmpty) {
        logList.clear();
        logList.addAll(newLogList);
        newLogList.clear();
      }
    } while (numberOfRemovedMoves > 0);

    return totalNumberOfRemovedMoves;
  }
}

interface class SolverAlgorithm {
  CubeSolverSolution? solveCubeInstance() {
    return null;
  }

  void returnToInitialState() {}
}
