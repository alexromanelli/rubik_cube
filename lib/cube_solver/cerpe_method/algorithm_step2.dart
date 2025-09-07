import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

class AlgorithmStep2 implements AlgorithmStep {
  final List<Coords> middlePlaces = <Coords>[
    (row: 0, column: 1),
    (row: 1, column: 0),
    (row: 1, column: 2),
    (row: 2, column: 1),
  ];

  List<FaceMovementLog> faceMovementLogList = <FaceMovementLog>[];

  @override
  AlgorithmStepResult runStep() {
    faceMovementLogList.clear();
    int countPlacements = 0;
    while (countPlacements < 4) {
      for (var coord in middlePlaces) {
        // get connected piece in neighbour face
        if (coord == (row: 0, column: 1)) {
          if (RubikCube.getColorName(Face.top, coord.row, coord.column) != ColorName.white) {
            continue;
          } else {
            ++countPlacements;
          }
          var neighbourFace = Face.back;
          Coords connectedPieceCoord = (row: 0, column: 1);
          var colorName = RubikCube.getColorName(neighbourFace, connectedPieceCoord.row, connectedPieceCoord.column);
          switch (colorName) {
            case ColorName.blue:
              doMovement(Face.front, Movement.u2);
              doMovement(Face.front, Movement.f2);
            case ColorName.red:
              doMovement(Face.front, Movement.u);
              doMovement(Face.front, Movement.r2);
            case ColorName.orange:
              doMovement(Face.front, Movement.u_);
              doMovement(Face.front, Movement.l2);
            case ColorName.green:
              doMovement(Face.front, Movement.b2);
            case ColorName.yellow || ColorName.white || ColorName.none:
              break; // do nothing
          }
        } else if (coord == (row: 1, column: 0)) {
          if (RubikCube.getColorName(Face.top, coord.row, coord.column) != ColorName.white) {
            continue;
          } else {
            ++countPlacements;
          }
          var neighbourFace = Face.left;
          Coords connectedPieceCoord = (row: 0, column: 1);
          var colorName = RubikCube.getColorName(neighbourFace, connectedPieceCoord.row, connectedPieceCoord.column);
          switch (colorName) {
            case ColorName.blue:
              doMovement(Face.front, Movement.u_);
              doMovement(Face.front, Movement.f2);
            case ColorName.red:
              doMovement(Face.front, Movement.u2);
              doMovement(Face.front, Movement.r2);
            case ColorName.green:
              doMovement(Face.front, Movement.u);
              doMovement(Face.front, Movement.b2);
            case ColorName.orange:
              doMovement(Face.front, Movement.l2);
            case ColorName.yellow || ColorName.white || ColorName.none:
              break; // do nothing
          }
        } else if (coord == (row: 1, column: 2)) {
          if (RubikCube.getColorName(Face.top, coord.row, coord.column) != ColorName.white) {
            continue;
          } else {
            ++countPlacements;
          }
          var neighbourFace = Face.right;
          Coords connectedPieceCoord = (row: 0, column: 1);
          var colorName = RubikCube.getColorName(neighbourFace, connectedPieceCoord.row, connectedPieceCoord.column);
          switch (colorName) {
            case ColorName.blue:
              doMovement(Face.front, Movement.u);
              doMovement(Face.front, Movement.f2);
            case ColorName.red:
              doMovement(Face.front, Movement.r2);
            case ColorName.green:
              doMovement(Face.front, Movement.u_);
              doMovement(Face.front, Movement.b2);
            case ColorName.orange:
              doMovement(Face.front, Movement.u2);
              doMovement(Face.front, Movement.l2);
            case ColorName.yellow || ColorName.white || ColorName.red || ColorName.none: // do nothing
          }
        } else if (coord == (row: 2, column: 1)) {
          if (RubikCube.getColorName(Face.top, coord.row, coord.column) != ColorName.white) {
            continue;
          } else {
            ++countPlacements;
          }
          var neighbourFace = Face.front;
          Coords connectedPieceCoord = (row: 0, column: 1);
          var colorName = RubikCube.getColorName(neighbourFace, connectedPieceCoord.row, connectedPieceCoord.column);
          switch (colorName) {
            case ColorName.blue:
              doMovement(Face.front, Movement.f2);
            case ColorName.red:
              doMovement(Face.front, Movement.u_);
              doMovement(Face.front, Movement.r2);
            case ColorName.green:
              doMovement(Face.front, Movement.u2);
              doMovement(Face.front, Movement.b2);
            case ColorName.orange:
              doMovement(Face.front, Movement.u);
              doMovement(Face.front, Movement.l2);
            case ColorName.yellow || ColorName.white || ColorName.blue || ColorName.none: // do nothing
          }
        }
      }
    }

    // print("Primeira etapa:");
    // for (var faceMovementLog in faceMovementLogList) {
    //   print("${faceMovementLog.referenceFace} Move: ${faceMovementLog.movement}");
    // }

    return AlgorithmStepResult(true, faceMovementLogList);
  }

  void doMovement(Face referenceFace, Movement movement) {
    RubikSolverMovement.doMovement(referenceFace, movement);
    faceMovementLogList.add(FaceMovementLog(referenceFace, movement));
  }
}
