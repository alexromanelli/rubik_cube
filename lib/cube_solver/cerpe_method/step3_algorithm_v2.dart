import 'package:rubik_cube/cube_solver/cerpe_method/step_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

enum CornerSide { upRight, upLeft, downRight, downLeft }

enum CornerRelativePosition { up, right, left, down }

class FaceDirectionAndCornerSide {
  FaceDirection faceDirection;
  CornerSide cornerSide;

  FaceDirectionAndCornerSide(this.faceDirection, this.cornerSide);
}

class Step3AlgorithmV2 implements StepAlgorithm {
  @override
  AlgorithmStepResult runStep() {
    var step = AlgorithmStepResult(false, []);
    FaceAndCornerSide? faceAndCornerSide;
    FaceAndCornerSide? old;
    FaceAndCornerSide? newValue;
    //  repeat until four white corners are positioned:
    // while (numOfPositionedCorners(RubikCube.mapColorNameToFace[ColorName.white]!) < 4) {
    while (!checkWhiteCornersInCorrectPlace()) {
      //    find a corner with a white side, and:
      old = newValue;
      // RubikCube.printCube();
      newValue = findFirstUnplacedWhiteCorner();
      if (newValue != null && newValue == old) {
        // print("Took the same corner...");
        return AlgorithmStepResult(false, []);
      }
      faceAndCornerSide = newValue;
      if (faceAndCornerSide == null) {
        // ERROR detected
        return AlgorithmStepResult(false, []);
      }
      // print("Face and corner side:\nFace: ${faceAndCornerSide.face}\nCorner side: ${faceAndCornerSide.cornerSide}");
      //      if its white side is on the cube's white face
      //        check if the corner's parts' current faces are the same around this corner
      //          if the corner's parts' current faces' colors match the corner's colors
      //            there is nothing to do
      //          else, put this corner out of the white base
      //      if it is with some other side on the cube's white face, do these movements: R, U, R'
      if (faceAndCornerSide.face == Face.bottom ||
          (faceAndCornerSide.face != Face.top && (faceAndCornerSide.cornerSide == CornerSide.downLeft ||
              faceAndCornerSide.cornerSide == CornerSide.downRight))) {
        // if (faceAndCornerSide.cornerSide == CornerSide.downLeft || faceAndCornerSide.cornerSide == CornerSide.downRight) {
        // var refFace =
        //     mapCornerWhiteFaceAndSideToRelativeFrontFaceAndSide[faceAndCornerSide.face]![faceAndCornerSide.cornerSide]!
        //         .face;
        // var movesToPutCornerOutOfBase = <FaceMovementLog>[
        //   FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R]!),
        //   FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.U]!),
        //   FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R_]!),
        // ];
        var refFace = faceAndCornerSide.face;
        if (refFace == Face.bottom) {
          refFace = switch (faceAndCornerSide.cornerSide) {
            CornerSide.upRight => Face.front,
            CornerSide.upLeft => Face.left,
            CornerSide.downRight => Face.right,
            CornerSide.downLeft => Face.back,
          };
        } else if (faceAndCornerSide.cornerSide == CornerSide.upLeft || faceAndCornerSide.cornerSide == CornerSide.downLeft) {
          refFace = RubikCube.getNeighbourFace(faceAndCornerSide.face, FaceDirection.left);
        }
        var movesToPutCornerOutOfBase = <FaceMovementLog>[
          FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R]!),
          FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.U]!),
          FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R_]!),
        ];
        // print("Put corner out of base:");
        // movesToPutCornerOutOfBase.forEach(printMovement);
        step.logList.addAll(movesToPutCornerOutOfBase);
        for (var faceMovementLog in movesToPutCornerOutOfBase) {
          // print("Ref. face: ${faceMovementLog.referenceFace}, Movement: ${faceMovementLog.movement}");
          RubikSolverMovement.doMovement(faceMovementLog.referenceFace, faceMovementLog.movement);
        }
        // RubikCube.printCube();
        continue;
      }
      //      if it is not touching the base:
      //        do the movement U until this corner is above the place it should be, i.e., where the corner is between the
      //          faces with the corner's colors
      Face currentFace = faceAndCornerSide.face;
      CornerSide currentCornerSide = faceAndCornerSide.cornerSide;
      while (!cornerIsAboveCorrectPlace(currentFace, currentCornerSide)) {
        step.logList.add(FaceMovementLog(Face.front, Movement.U));
        RubikSolverMovement.doMovement(Face.front, Movement.U);
        // print("Spinning Up side:"); printMovement(FaceMovementLog(Face.front, Movement.U));
        // RubikCube.printCube();
        if (currentFace != Face.top) {
          currentFace = RubikCube.getNeighbourFace(currentFace, FaceDirection.left);
        } else {
          currentCornerSide = switch (currentCornerSide) {
          // clockwise transitions
            CornerSide.upRight => CornerSide.downRight,
            CornerSide.downRight => CornerSide.downLeft,
            CornerSide.downLeft => CornerSide.upLeft,
            CornerSide.upLeft => CornerSide.upRight,
          };
        }
      }
      // faceAndCornerSide = (currentFace, currentCornerSide);
      //        act according the observed cases, which are described in the Renan Cerpe's book "O segredo do cubo mágico em 8 passos"
      var whiteCornerSide = getRelativePositionOfWhiteSideOfCorner(FaceAndCornerSide(currentFace, currentCornerSide));
      var list = <FaceMovementLog>[];
      switch (whiteCornerSide) {
        //          White corner to the left
        //            do the movements L', U' and L, relative to tha corner's left side (they should be translated to be relative to the blue side)
        //          White corner to the right, do the movements R, U, R'
        //          White corner to the top, do R, U2, R', R, U, R'
        case CornerRelativePosition.right:
          var refFace = RubikCube.getNeighbourFace(currentFace, FaceDirection.left);
          // print("current: ${currentFace}, ref: ${refFace}");
          list.addAll(<FaceMovementLog>[
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.U]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R_]!),
          ]);
          // print("Place corner:");
          // list.forEach(printMovement);
        case CornerRelativePosition.left:
          var refFace = RubikCube.getNeighbourFace(currentFace, FaceDirection.right);
          // print("current: ${currentFace}, ref: ${refFace}");
          list.addAll(<FaceMovementLog>[
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.L_]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.U_]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.L]!),
          ]);
          // print("Place corner:");
          // list.forEach(printMovement);
        case CornerRelativePosition.up:
          var faceDirection = switch (currentCornerSide) {
            CornerSide.upRight => FaceDirection.right,
            CornerSide.upLeft => FaceDirection.up,
            CornerSide.downRight => FaceDirection.down,
            CornerSide.downLeft => FaceDirection.left,
          };
          var refFace = RubikCube.getNeighbourFace(currentFace, faceDirection);
          // print("current: ${currentFace}, ref: ${refFace}");
          list.addAll(<FaceMovementLog>[
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.U2]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R_]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.U_]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.U]!),
            FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R_]!),
          ]);
          // print("Place corner:");
          // list.forEach(printMovement);
        case CornerRelativePosition.down:
        // unnecessary case
      }
      step.logList.addAll(list);
      for (var faceMovementLog in list) {
        RubikSolverMovement.doMovement(faceMovementLog.referenceFace, faceMovementLog.movement);
      }
      // RubikCube.printCube();
    }
    return AlgorithmStepResult(true, step.logList);
  }

  // void printMovement(FaceMovementLog log) {
  //   print("Movement ${log.movement}");
  // }

  CornerRelativePosition getRelativePositionOfWhiteSideOfCorner(FaceAndCornerSide faceAndCornerSide) {
    var color = RubikCube.mapFaceToColorName[faceAndCornerSide.face];
    if (color == ColorName.white) {
      return CornerRelativePosition.down;
    } else if (color == ColorName.yellow) {
      return CornerRelativePosition.up;
    } else {
      return switch (faceAndCornerSide.cornerSide) {
        CornerSide.upRight || CornerSide.downRight => CornerRelativePosition.left,
        CornerSide.upLeft || CornerSide.downLeft => CornerRelativePosition.right,
      };
    }
  }

  static Map<Face, Map<Movement, Movement>> mapFaceAndMovementToReferToFront = <Face, Map<Movement, Movement>>{
    Face.right: <Movement, Movement>{
      Movement.U: Movement.U,
      Movement.U_: Movement.U_,
      Movement.U2: Movement.U2,
      Movement.B: Movement.L,
      Movement.B_: Movement.L_,
      Movement.B2: Movement.L2,
      Movement.R: Movement.B,
      Movement.R_: Movement.B_,
      Movement.R2: Movement.B2,
      Movement.L: Movement.F,
      Movement.L_: Movement.F_,
      Movement.L2: Movement.F2,
      Movement.F: Movement.R,
      Movement.F_: Movement.R_,
      Movement.F2: Movement.R2,
    },
    Face.left: <Movement, Movement>{
      Movement.U: Movement.U,
      Movement.U_: Movement.U_,
      Movement.U2: Movement.U2,
      Movement.B: Movement.R,
      Movement.B_: Movement.R_,
      Movement.B2: Movement.R2,
      Movement.R: Movement.F,
      Movement.R_: Movement.F_,
      Movement.R2: Movement.F2,
      Movement.L: Movement.B,
      Movement.L_: Movement.B_,
      Movement.L2: Movement.B2,
      Movement.F: Movement.L,
      Movement.F_: Movement.L_,
      Movement.F2: Movement.L2,
    },
    Face.back: <Movement, Movement>{
      Movement.U: Movement.U,
      Movement.U_: Movement.U_,
      Movement.U2: Movement.U2,
      Movement.B: Movement.F,
      Movement.B_: Movement.F_,
      Movement.B2: Movement.F2,
      Movement.R: Movement.L,
      Movement.R_: Movement.L_,
      Movement.R2: Movement.L2,
      Movement.L: Movement.R,
      Movement.L_: Movement.R_,
      Movement.L2: Movement.R2,
      Movement.F: Movement.B,
      Movement.F_: Movement.B_,
      Movement.F2: Movement.B2,
    },
    Face.front: <Movement, Movement>{
      Movement.U: Movement.U,
      Movement.U_: Movement.U_,
      Movement.U2: Movement.U2,
      Movement.B: Movement.B,
      Movement.B_: Movement.B_,
      Movement.B2: Movement.B2,
      Movement.R: Movement.R,
      Movement.R_: Movement.R_,
      Movement.R2: Movement.R2,
      Movement.L: Movement.L,
      Movement.L_: Movement.L_,
      Movement.L2: Movement.L2,
      Movement.F: Movement.F,
      Movement.F_: Movement.F_,
      Movement.F2: Movement.F2,
    },
    Face.top: <Movement, Movement>{
      Movement.U: Movement.B,
      Movement.U_: Movement.B_,
      Movement.U2: Movement.B2,
      Movement.B: Movement.D,
      Movement.B_: Movement.D_,
      Movement.B2: Movement.D2,
      Movement.R: Movement.R,
      Movement.R_: Movement.R_,
      Movement.R2: Movement.R2,
      Movement.L: Movement.L,
      Movement.L_: Movement.L_,
      Movement.L2: Movement.L2,
      Movement.F: Movement.U,
      Movement.F_: Movement.U_,
      Movement.F2: Movement.U2,
    },
    Face.bottom: <Movement, Movement>{
      Movement.U: Movement.F,
      Movement.U_: Movement.F_,
      Movement.U2: Movement.F2,
      Movement.B: Movement.U,
      Movement.B_: Movement.U_,
      Movement.B2: Movement.U2,
      Movement.R: Movement.R,
      Movement.R_: Movement.R_,
      Movement.R2: Movement.R2,
      Movement.L: Movement.L,
      Movement.L_: Movement.L_,
      Movement.L2: Movement.L2,
      Movement.F: Movement.D,
      Movement.F_: Movement.D_,
      Movement.F2: Movement.D2,
    },
  };

  static Map<CornerSide, Coords> mapCornerSideToCoords = <CornerSide, Coords>{
    CornerSide.upLeft: (row: 0, column: 0),
    CornerSide.upRight: (row: 0, column: 2),
    CornerSide.downLeft: (row: 2, column: 0),
    CornerSide.downRight: (row: 2, column: 2),
  };

  static var mapCornerSideToFaceDirectionAndCornerSide =
      <CornerSide, List<FaceDirectionAndCornerSide>>{
        CornerSide.upLeft: <FaceDirectionAndCornerSide>[
          FaceDirectionAndCornerSide(FaceDirection.up, CornerSide.downLeft),
          FaceDirectionAndCornerSide(FaceDirection.left, CornerSide.upRight),
        ],
        CornerSide.upRight: <FaceDirectionAndCornerSide>[
          FaceDirectionAndCornerSide(FaceDirection.up, CornerSide.downRight),
          FaceDirectionAndCornerSide(FaceDirection.right, CornerSide.upLeft),
        ],
        CornerSide.downLeft: <FaceDirectionAndCornerSide>[
          FaceDirectionAndCornerSide(FaceDirection.down, CornerSide.upLeft),
          FaceDirectionAndCornerSide(FaceDirection.left, CornerSide.downRight),
        ],
        CornerSide.downRight: <FaceDirectionAndCornerSide>[
          FaceDirectionAndCornerSide(FaceDirection.down, CornerSide.upRight),
          FaceDirectionAndCornerSide(FaceDirection.right, CornerSide.downLeft),
        ],
      };

  static Map<CornerSide, List<FaceDirection>> mapCornerSideToFaceDirectionList = <CornerSide, List<FaceDirection>>{
    CornerSide.upLeft: <FaceDirection>[ FaceDirection.up, FaceDirection.left ],
    CornerSide.upRight: <FaceDirection>[ FaceDirection.up, FaceDirection.right ],
    CornerSide.downRight: <FaceDirection>[ FaceDirection.down, FaceDirection.right ],
    CornerSide.downLeft: <FaceDirection>[ FaceDirection.down, FaceDirection.left ],
  };

  static Map<Face, Map<CornerSide, Map<FaceDirection, FaceAndCornerSide>>> mapFaceAndCornerSideTpMapFaceDirectionToFaceAndCornerSide = <Face, Map<CornerSide, Map<FaceDirection, FaceAndCornerSide>>>{
    Face.front: <CornerSide, Map<FaceDirection, FaceAndCornerSide>>{
      CornerSide.upLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.top, CornerSide.downLeft),
        FaceDirection.left: FaceAndCornerSide(Face.left, CornerSide.upRight),
      },
      CornerSide.upRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.top, CornerSide.downRight),
        FaceDirection.right: FaceAndCornerSide(Face.right, CornerSide.upLeft),
      },
      CornerSide.downLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.bottom, CornerSide.upLeft),
        FaceDirection.left: FaceAndCornerSide(Face.left, CornerSide.downRight),
      },
      CornerSide.downRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.bottom, CornerSide.upRight),
        FaceDirection.right: FaceAndCornerSide(Face.right, CornerSide.downLeft),
      },
    },
    Face.right: <CornerSide, Map<FaceDirection, FaceAndCornerSide>>{
      CornerSide.upLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.top, CornerSide.downRight),
        FaceDirection.left: FaceAndCornerSide(Face.front, CornerSide.upRight),
      },
      CornerSide.upRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.top, CornerSide.upRight),
        FaceDirection.right: FaceAndCornerSide(Face.back, CornerSide.upLeft),
      },
      CornerSide.downLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.bottom, CornerSide.upRight),
        FaceDirection.left: FaceAndCornerSide(Face.front, CornerSide.downRight),
      },
      CornerSide.downRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.bottom, CornerSide.downRight),
        FaceDirection.right: FaceAndCornerSide(Face.back, CornerSide.downLeft),
      },
    },
    Face.back: <CornerSide, Map<FaceDirection, FaceAndCornerSide>>{
      CornerSide.upLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.top, CornerSide.upRight),
        FaceDirection.left: FaceAndCornerSide(Face.right, CornerSide.upRight),
      },
      CornerSide.upRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.top, CornerSide.upLeft),
        FaceDirection.right: FaceAndCornerSide(Face.left, CornerSide.upLeft),
      },
      CornerSide.downLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.bottom, CornerSide.downRight),
        FaceDirection.left: FaceAndCornerSide(Face.right, CornerSide.downRight),
      },
      CornerSide.downRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.bottom, CornerSide.downLeft),
        FaceDirection.right: FaceAndCornerSide(Face.left, CornerSide.downLeft),
      },
    },
    Face.left: <CornerSide, Map<FaceDirection, FaceAndCornerSide>>{
      CornerSide.upLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.top, CornerSide.upLeft),
        FaceDirection.left: FaceAndCornerSide(Face.back, CornerSide.upRight),
      },
      CornerSide.upRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.top, CornerSide.downLeft),
        FaceDirection.right: FaceAndCornerSide(Face.front, CornerSide.upLeft),
      },
      CornerSide.downLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.bottom, CornerSide.downLeft),
        FaceDirection.left: FaceAndCornerSide(Face.back, CornerSide.downRight),
      },
      CornerSide.downRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.bottom, CornerSide.upLeft),
        FaceDirection.right: FaceAndCornerSide(Face.front, CornerSide.downLeft),
      },
    },
    Face.top: <CornerSide, Map<FaceDirection, FaceAndCornerSide>>{
      CornerSide.upLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.back, CornerSide.upRight),
        FaceDirection.left: FaceAndCornerSide(Face.left, CornerSide.upLeft),
      },
      CornerSide.upRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.back, CornerSide.upLeft),
        FaceDirection.right: FaceAndCornerSide(Face.right, CornerSide.upRight),
      },
      CornerSide.downLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.front, CornerSide.upLeft),
        FaceDirection.left: FaceAndCornerSide(Face.left, CornerSide.upRight),
      },
      CornerSide.downRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.front, CornerSide.upRight),
        FaceDirection.right: FaceAndCornerSide(Face.right, CornerSide.upLeft),
      },
    },
    Face.bottom: <CornerSide, Map<FaceDirection, FaceAndCornerSide>>{
      CornerSide.upLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.front, CornerSide.downLeft),
        FaceDirection.left: FaceAndCornerSide(Face.left, CornerSide.downRight),
      },
      CornerSide.upRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.up: FaceAndCornerSide(Face.front, CornerSide.downRight),
        FaceDirection.right: FaceAndCornerSide(Face.right, CornerSide.downLeft),
      },
      CornerSide.downLeft: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.back, CornerSide.downRight),
        FaceDirection.left: FaceAndCornerSide(Face.left, CornerSide.downLeft),
      },
      CornerSide.downRight: <FaceDirection, FaceAndCornerSide>{
        FaceDirection.down: FaceAndCornerSide(Face.back, CornerSide.downLeft),
        FaceDirection.right: FaceAndCornerSide(Face.right, CornerSide.downRight),
      },
    },
  };

  static Map<Face, Map<CornerSide, FaceAndCornerSide>> mapWhiteCornerFaceAndSideToRelativeFrontFaceAndSide =
      <Face, Map<CornerSide, FaceAndCornerSide>>{
        Face.front: <CornerSide, FaceAndCornerSide>{
          // CornerSide.upLeft: FaceAndCornerSide(Face.left, CornerSide.upRight),
          // CornerSide.upRight: FaceAndCornerSide(Face.right, CornerSide.upLeft),
          // CornerSide.downLeft: FaceAndCornerSide(Face.left, CornerSide.downRight),
          // CornerSide.downRight: FaceAndCornerSide(Face.right, CornerSide.downLeft),
          CornerSide.upLeft: FaceAndCornerSide(Face.top, CornerSide.downLeft),
          CornerSide.upRight: FaceAndCornerSide(Face.top, CornerSide.downRight),
          CornerSide.downLeft: FaceAndCornerSide(Face.front, CornerSide.downLeft),
          CornerSide.downRight: FaceAndCornerSide(Face.front, CornerSide.downRight),
        },
        Face.right: <CornerSide, FaceAndCornerSide>{
          CornerSide.upLeft: FaceAndCornerSide(Face.front, CornerSide.upRight),
          CornerSide.upRight: FaceAndCornerSide(Face.back, CornerSide.upLeft),
          CornerSide.downLeft: FaceAndCornerSide(Face.front, CornerSide.downRight),
          CornerSide.downRight: FaceAndCornerSide(Face.back, CornerSide.downLeft),
        },
        Face.back: <CornerSide, FaceAndCornerSide>{
          CornerSide.upLeft: FaceAndCornerSide(Face.right, CornerSide.upRight),
          CornerSide.upRight: FaceAndCornerSide(Face.left, CornerSide.upLeft),
          CornerSide.downLeft: FaceAndCornerSide(Face.right, CornerSide.downRight),
          CornerSide.downRight: FaceAndCornerSide(Face.left, CornerSide.downLeft),
        },
        Face.left: <CornerSide, FaceAndCornerSide>{
          CornerSide.upLeft: FaceAndCornerSide(Face.back, CornerSide.upRight),
          CornerSide.upRight: FaceAndCornerSide(Face.front, CornerSide.upLeft),
          CornerSide.downLeft: FaceAndCornerSide(Face.back, CornerSide.downRight),
          CornerSide.downRight: FaceAndCornerSide(Face.front, CornerSide.downLeft),
        },
        Face.top: <CornerSide, FaceAndCornerSide>{
          CornerSide.upLeft: FaceAndCornerSide(Face.back, CornerSide.upRight),
          CornerSide.upRight: FaceAndCornerSide(Face.right, CornerSide.upRight),
          CornerSide.downLeft: FaceAndCornerSide(Face.left, CornerSide.upRight),
          CornerSide.downRight: FaceAndCornerSide(Face.front, CornerSide.upRight),
        },
      };

  List<FaceAndCornerSide> getCornerNeighgours(Face face, CornerSide cornerSide) {
    var list = <FaceAndCornerSide>[];
    list.add(FaceAndCornerSide(face, cornerSide));
    for (var faceDirection in mapCornerSideToFaceDirectionList[cornerSide]!) {
      var faceAndCornerSide = mapFaceAndCornerSideTpMapFaceDirectionToFaceAndCornerSide[face]![cornerSide]![faceDirection]!;
      list.add(faceAndCornerSide);
    }
    return list;
  }

  FaceAndCornerSide? findFirstUnplacedWhiteCorner() {
    for (var face in Face.values) {
      for (var cornerSide in CornerSide.values) {
        var coords = mapCornerSideToCoords[cornerSide]!;
        if (RubikCube.getColorName(face, coords.row, coords.column) == ColorName.white) {
          if (RubikCube.mapFaceToColorName[face] == ColorName.white) {
            List<FaceCornerSideAndColorName> faceAndCornerColorList = getFaceAndCornerColorList(face, cornerSide);
            // check if colors are already on the correct faces
            var correct = true;
            for (var item in faceAndCornerColorList) {
              if (item.colorName != RubikCube.mapFaceToColorName[item.face]) {
                correct = false;
              }
            }
            if (correct) {
              // this white corner is already placed correctly
              continue;
            }
          }
          return FaceAndCornerSide(face, cornerSide);
        }
      }
    }
    return null;
  }

  bool checkWhiteCornersInCorrectPlace() {
    var whiteCornerCount = 0;
    for (var cornerSide in CornerSide.values) {
      if (RubikCube.getColorName(Face.bottom, mapCornerSideToCoords[cornerSide]!.row, mapCornerSideToCoords[cornerSide]!.column) != ColorName.white) {
        continue;
      } else {
        ++whiteCornerCount;
      }
    }
    if (whiteCornerCount < 4) {
      return false;
    }
    var vertFacesCornerInCorrectPlace = 0;
    List<Face> vertFaceList = <Face>[Face.front, Face.right, Face.back, Face.left];
    List<CornerSide> downCornerSideList = <CornerSide>[CornerSide.downLeft, CornerSide.downRight];
    for (var face in vertFaceList) {
      for (var downCornerSide in downCornerSideList) {
        var coords = mapCornerSideToCoords[downCornerSide]!;
        var cornerColor = RubikCube.getColorName(face, coords.row, coords.column);
        if (RubikCube.mapFaceToColorName[face] == cornerColor) {
          ++vertFacesCornerInCorrectPlace;
        }
      }
    }
    return vertFacesCornerInCorrectPlace == 8;
  }

  int numOfPositionedCorners(Face face) {
    var color = RubikCube.mapFaceToColorName[face];
    int count = 0;
    for (int row = 0; row < 3; ++row) {
      if (row == 1) {
        continue;
      }
      for (int column = 0; column < 3; ++column) {
        if (column == 1) {
          continue;
        }
        if (RubikCube.getColorName(face, row, column) == color) {
          ++count;
        }
      }
    }
    return count;
  }

  ColorName getCornerColorName(FaceAndCornerSide neighbour) {
    Coords coords = mapCornerSideToCoords[neighbour.cornerSide]!;
    ColorName color = RubikCube.getColorName(neighbour.face, coords.row, coords.column);
    return color;
  }

  List<FaceCornerSideAndColorName> getFaceAndCornerColorList(Face face, CornerSide cornerSide) {
    List<FaceCornerSideAndColorName> list = <FaceCornerSideAndColorName>[];
    List<FaceAndCornerSide> neighbours = getCornerNeighgours(face, cornerSide);
    for (var neighbour in neighbours) {
      list.add(FaceCornerSideAndColorName(neighbour.face, neighbour.cornerSide, getCornerColorName(neighbour)));
    }
    return list;
  }

  bool cornerIsAboveCorrectPlace(Face face, CornerSide cornerSide) {
    var neighbourList = getFaceAndCornerColorList(face, cornerSide);
    var faceColorList = List<ColorName>.generate(neighbourList.length, (index) {
      return RubikCube.mapFaceToColorName[neighbourList[index].face]!;
    });
    var cornerColorList = List<ColorName>.generate(neighbourList.length, (index) {
      return neighbourList[index].colorName;
    });
    var countMatches = 0;
    for (var faceColor in faceColorList) {
      for (var cornerColor in cornerColorList) {
        if (faceColor == cornerColor) {
          ++countMatches;
        }
      }
    }
    return countMatches == 2;
  }
}

class FaceCornerSideAndColorName {
  Face face;
  CornerSide cornerSide;
  ColorName colorName;

  FaceCornerSideAndColorName(this.face, this.cornerSide, this.colorName);
}

class FaceAndCornerSide {
  Face face;
  CornerSide cornerSide;

  FaceAndCornerSide(this.face, this.cornerSide);
}
