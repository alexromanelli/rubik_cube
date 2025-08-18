import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

typedef Coords = ({int row, int column});

class Step1Algorithm {
  static final List<Coords> middlePlaces = <Coords>[
    (row: 0, column: 1),
    (row: 1, column: 0),
    (row: 1, column: 2),
    (row: 2, column: 1),
  ];
  static final List<Coords> easyPlaces = <Coords>[(row: 1, column: 0), (row: 1, column: 2)];
  static final List<Coords> lessEasyPlaces = <Coords>[(row: 0, column: 1), (row: 2, column: 1)];

  static var faceMovementLogList = <FaceMovementLog>[];

  static List<FaceMovementLog> runStep1Algorithm() {
    faceMovementLogList.clear();

    // count not white middle pieces on yellow face
    var numberOfNonWhiteMiddlePiecesOnYellowFace = countNotWhiteMiddlePiecesOnYellowFace();
    while (numberOfNonWhiteMiddlePiecesOnYellowFace > 0) {
      // check face for easy positions of white middle
      for (Face face in Face.values) {
        if (face == RubikCube.mapColorNameToFace[ColorName.yellow]) {
          continue;
        }
        // TODO: implementar verificação exaustiva de middle pieces e tomar ações específicas para cada caso
        Coords? whiteMiddleCoord = findWhiteMiddlePieceInFace(face);
        if (whiteMiddleCoord != null) {
          // take action to put this white middle in yellow face (top)
          if (RubikCube.isFaceOppositeToOtherFace(RubikCube.mapColorNameToFace[ColorName.yellow]!, face)) {
            FaceDirection faceSide = whiteMiddleCoord.column == 0 ? FaceDirection.right : FaceDirection.left;
            putNonWhiteMiddlePieceInSide(faceSide);

            /// Face TODO: implementar ação para face == Face.front
            switch (face) {
              case Face.front:
                switch (faceSide) {
                  case FaceDirection.up:
                  case FaceDirection.left:
                  case FaceDirection.down:
                  case FaceDirection.right:
                }
              case Face.top:
                // TODO: Handle this case.
                throw UnimplementedError();
              case Face.right:
                // TODO: Handle this case.
                throw UnimplementedError();
              case Face.back:
                // TODO: Handle this case.
                throw UnimplementedError();
              case Face.bottom:
                // TODO: Handle this case.
                throw UnimplementedError();
              case Face.left:
                // TODO: Handle this case.
                throw UnimplementedError();
            }
            Face faceToRotate = switch (face) {
              Face.front => switch (faceSide) {
                FaceDirection.up => RubikCube.mapColorNameToFace[FaceDirection.up]!,
                FaceDirection.left => throw UnimplementedError(),
                FaceDirection.down => throw UnimplementedError(),
                FaceDirection.right => throw UnimplementedError(),
              },
              // TODO: Handle this case.
              Face.top => throw UnimplementedError(),
              // TODO: Handle this case.
              Face.right => throw UnimplementedError(),
              // TODO: Handle this case.
              Face.back => throw UnimplementedError(),
              // TODO: Handle this case.
              Face.bottom => throw UnimplementedError(),
              // TODO: Handle this case.
              Face.left => throw UnimplementedError(),
            };
          }
        }
      }

      // update non white middle pieces count on yellow face
      numberOfNonWhiteMiddlePiecesOnYellowFace = countNotWhiteMiddlePiecesOnYellowFace();
    }

    return faceMovementLogList;
  }

  static void putNonWhiteMiddlePieceInSide(FaceDirection faceSide) {
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
            doMovement(Face.front, Movement.U);
          } else if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![1][2] !=
              ColorName.white) {
            // rotate yellow face 90° counterclockwise
            doMovement(Face.front, Movement.U_);
          } else {
            // [2][1] != white
            // rotate yellow face 180° clockwise (or counterclockwise, it does not matter for 180° rotation)
            doMovement(Face.front, Movement.U2);
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
            doMovement(Face.front, Movement.U);
          } else if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![2][1] !=
              ColorName.white) {
            // rotate yellow face 90° counterclockwise
            doMovement(Face.front, Movement.U_);
          } else {
            // [1][0] != white
            // rotate yellow face 180° clockwise (or counterclockwise, it does not matter for 180° rotation)
            doMovement(Face.front, Movement.U2);
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
            doMovement(Face.front, Movement.U);
          } else if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![1][0] !=
              ColorName.white) {
            // rotate yellow face 90° counterclockwise
            doMovement(Face.front, Movement.U_);
          } else {
            // [0][1] != white
            // rotate yellow face 180° clockwise (or counterclockwise, it does not matter for 180° rotation)
            doMovement(Face.front, Movement.U2);
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
            doMovement(Face.front, Movement.U);
          } else if (RubikCube.mapFaceToColorNameMatrix[RubikCube.mapColorNameToFace[ColorName.yellow]]![0][1] !=
              ColorName.white) {
            // rotate yellow face 90° counterclockwise
            doMovement(Face.front, Movement.U_);
          } else {
            // [1][2] != white
            // rotate yellow face 180° clockwise (or counterclockwise, it does not matter for 180° rotation)
            doMovement(Face.front, Movement.U2);
          }
        }
    }
  }

  static void doMovement(Face referenceFace, Movement movement) {
    RubikSolverMovement.doMovement(referenceFace, movement);
    faceMovementLogList.add(FaceMovementLog(referenceFace, movement));
  }

  static int countNotWhiteMiddlePiecesOnYellowFace() {
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

  static Coords? findWhiteMiddlePieceInFace(Face face) {
    for (var place in easyPlaces) {
      if (RubikCube.mapFaceToColorNameMatrix[face]![place.row][place.column] == ColorName.white) {
        return place;
      }
    }
    return null;
  }
}
