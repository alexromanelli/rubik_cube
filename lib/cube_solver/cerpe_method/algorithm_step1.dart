import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

class AlgorithmStep1 implements AlgorithmStep {
  final List<Coords> middlePlaces = <Coords>[
    (row: 0, column: 1),
    (row: 1, column: 0),
    (row: 1, column: 2),
    (row: 2, column: 1),
  ];
  final List<Coords> easyPlaces = <Coords>[(row: 1, column: 0), (row: 1, column: 2)];
  final List<Coords> lessEasyPlaces = <Coords>[(row: 0, column: 1), (row: 2, column: 1)];

  var faceMovementLogList = <FaceMovementLog>[];

  List<MiddlePiece> findAllWhiteMiddlePieces() {
    var pieces = <MiddlePiece>[];
    for (var face in Face.values) {
      if (face == Face.none) { continue; }
      for (var place in middlePlaces) {
        Coords coord = (row: place.row, column: place.column);
        MiddlePiece piece = (face: face, coords: coord);
        if (RubikCube.getColorName(face, place.row, place.column) == ColorName.white) {
          pieces.add(piece);
        }
      }
    }
    return pieces;
  }

  @override
  AlgorithmStepResult runStep() {
    faceMovementLogList.clear();

    var numberOfNonWhiteMiddlePiecesOnYellowFace = countNotWhiteMiddlePiecesOnYellowFace();

    while (numberOfNonWhiteMiddlePiecesOnYellowFace > 0) {
      // front side
      if (RubikCube.getColorName(Face.front, 0, 1) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.down);
        doMovement(Face.front, Movement.f);
        putNonWhiteMiddlePieceInSide(FaceDirection.right);
        doMovement(Face.front, Movement.r);
      } else if (RubikCube.getColorName(Face.front, 1, 0) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.left);
        doMovement(Face.front, Movement.l_);
      } else if (RubikCube.getColorName(Face.front, 2, 1) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.down);
        doMovement(Face.front, Movement.f);
        putNonWhiteMiddlePieceInSide(FaceDirection.left);
        doMovement(Face.front, Movement.l_);
      } else if (RubikCube.getColorName(Face.front, 1, 2) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.right);
        doMovement(Face.front, Movement.r);
      }

      // right side
      if (RubikCube.getColorName(Face.right, 0, 1) == ColorName.white) {
        doMovement(Face.front, Movement.r);
        putNonWhiteMiddlePieceInSide(FaceDirection.up);
        doMovement(Face.front, Movement.b);
      } else if (RubikCube.getColorName(Face.right, 1, 0) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.down);
        doMovement(Face.front, Movement.f_);
      } else if (RubikCube.getColorName(Face.right, 2, 1) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.right);
        doMovement(Face.front, Movement.r);
        putNonWhiteMiddlePieceInSide(FaceDirection.down);
        doMovement(Face.front, Movement.f_);
      } else if (RubikCube.getColorName(Face.right, 1, 2) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.up);
        doMovement(Face.front, Movement.b);
      }

      // left side
      if (RubikCube.getColorName(Face.left, 0, 1) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.left);
        doMovement(Face.front, Movement.l);
        putNonWhiteMiddlePieceInSide(FaceDirection.down);
        doMovement(Face.front, Movement.f);
      } else if (RubikCube.getColorName(Face.left, 1, 0) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.up);
        doMovement(Face.front, Movement.b_);
      } else if (RubikCube.getColorName(Face.left, 2, 1) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.left);
        doMovement(Face.front, Movement.l_);
        putNonWhiteMiddlePieceInSide(FaceDirection.down);
        doMovement(Face.front, Movement.f);
      } else if (RubikCube.getColorName(Face.left, 1, 2) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.down);
        doMovement(Face.front, Movement.f);
      }

      // back side
      if (RubikCube.getColorName(Face.back, 0, 1) == ColorName.white) {
        doMovement(Face.front, Movement.b);
        putNonWhiteMiddlePieceInSide(FaceDirection.left);
        doMovement(Face.front, Movement.l);
      } else if (RubikCube.getColorName(Face.back, 1, 0) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.right);
        doMovement(Face.front, Movement.r_);
      } else if (RubikCube.getColorName(Face.back, 2, 1) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.up);
        doMovement(Face.front, Movement.b);
        putNonWhiteMiddlePieceInSide(FaceDirection.right);
        doMovement(Face.front, Movement.r_);
      } else if (RubikCube.getColorName(Face.back, 1, 2) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.left);
        doMovement(Face.front, Movement.l);
      }

      // bottom side
      if (RubikCube.getColorName(Face.bottom, 0, 1) == ColorName.white) {
        doMovement(Face.front, Movement.d);
        putNonWhiteMiddlePieceInSide(FaceDirection.right);
        doMovement(Face.front, Movement.r2);
      } else if (RubikCube.getColorName(Face.bottom, 1, 0) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.left);
        doMovement(Face.front, Movement.l2);
      } else if (RubikCube.getColorName(Face.bottom, 2, 1) == ColorName.white) {
        doMovement(Face.front, Movement.d);
        putNonWhiteMiddlePieceInSide(FaceDirection.left);
        doMovement(Face.front, Movement.l2);
      } else if (RubikCube.getColorName(Face.bottom, 1, 2) == ColorName.white) {
        putNonWhiteMiddlePieceInSide(FaceDirection.right);
        doMovement(Face.front, Movement.r2);
      }

      numberOfNonWhiteMiddlePiecesOnYellowFace = countNotWhiteMiddlePiecesOnYellowFace();
    }
    return AlgorithmStepResult(true, FaceMovementLog.copyOf(faceMovementLogList));
  }

  void putNonWhiteMiddlePieceInSide(FaceDirection faceSide) {
    switch (faceSide) {
      case FaceDirection.up:
        if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![0][1] !=
            ColorName.white) {
          // it does not need rotation
          return;
        } else {
          if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![1][0] !=
              ColorName.white) {
            // rotate yellow face 90° clockwise
            doMovement(Face.front, Movement.u);
          } else if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![1][2] !=
              ColorName.white) {
            // rotate yellow face 90° counterclockwise
            doMovement(Face.front, Movement.u_);
          } else {
            // [2][1] != white
            // rotate yellow face 180° clockwise (or counterclockwise, it does not matter for 180° rotation)
            doMovement(Face.front, Movement.u2);
          }
        }

      case FaceDirection.right:
        if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![1][2] !=
            ColorName.white) {
          // it does not need rotation
          return;
        } else {
          if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![0][1] !=
              ColorName.white) {
            // rotate yellow face 90° clockwise
            doMovement(Face.front, Movement.u);
          } else if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![2][1] !=
              ColorName.white) {
            // rotate yellow face 90° counterclockwise
            doMovement(Face.front, Movement.u_);
          } else {
            // [1][0] != white
            // rotate yellow face 180° clockwise (or counterclockwise, it does not matter for 180° rotation)
            doMovement(Face.front, Movement.u2);
          }
        }

      case FaceDirection.down:
        if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![2][1] !=
            ColorName.white) {
          // it does not need rotation
          return;
        } else {
          if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![1][2] !=
              ColorName.white) {
            // rotate yellow face 90° clockwise
            doMovement(Face.front, Movement.u);
          } else if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![1][0] !=
              ColorName.white) {
            // rotate yellow face 90° counterclockwise
            doMovement(Face.front, Movement.u_);
          } else {
            // [0][1] != white
            // rotate yellow face 180° clockwise (or counterclockwise, it does not matter for 180° rotation)
            doMovement(Face.front, Movement.u2);
          }
        }

      case FaceDirection.left:
        if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![1][0] !=
            ColorName.white) {
          // it does not need rotation
          return;
        } else {
          if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![2][1] !=
              ColorName.white) {
            // rotate yellow face 90° clockwise
            doMovement(Face.front, Movement.u);
          } else if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![0][1] !=
              ColorName.white) {
            // rotate yellow face 90° counterclockwise
            doMovement(Face.front, Movement.u_);
          } else {
            // [1][2] != white
            // rotate yellow face 180° clockwise (or counterclockwise, it does not matter for 180° rotation)
            doMovement(Face.front, Movement.u2);
          }
        }
    }
  }

  void doMovement(Face referenceFace, Movement movement) {
    RubikSolverMovement.doMovement(referenceFace, movement);
    faceMovementLogList.add(FaceMovementLog(referenceFace, movement));
  }

  int countNotWhiteMiddlePiecesOnYellowFace() {
    int notWhite = 0;
    for (Coords coords in middlePlaces) {
      if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![coords.row][coords
              .column] !=
          ColorName.white) {
        notWhite += 1;
      }
    }
    return notWhite;
  }

  Coords? findWhiteMiddlePieceInFace(Face face) {
    for (var place in easyPlaces) {
      if (RubikCube.mapFaceToColorNameMatrix[face]![place.row][place.column] == ColorName.white) {
        return place;
      }
    }
    return null;
  }
}
