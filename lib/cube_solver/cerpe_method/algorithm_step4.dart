import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

enum MiddleSide { up, right, down, left }

class FaceAndMiddleSide {
  Face face;
  MiddleSide middleSide;

  FaceAndMiddleSide(this.face, this.middleSide);

  static Map<MiddleSide, Coords> mapMiddleSideToCoords = <MiddleSide, Coords>{
    MiddleSide.left: (row: 1, column: 0),
    MiddleSide.up: (row: 0, column: 1),
    MiddleSide.right: (row: 1, column: 2),
    MiddleSide.down: (row: 2, column: 1),
  };
}

class AlgorithmStep4 implements AlgorithmStep {
  @override
  AlgorithmStepResult runStep() {
    var step = AlgorithmStepResult(false, []);

    List<FaceAndMiddleSide> rejectedMiddlePieceList = <FaceAndMiddleSide>[];

    // while not all four middle pieces are correctly placed
    while (!allMiddlePiecesAreCorrectlyPlaced()) {
      // find a middle piece
      FaceAndMiddleSide? faceAndMiddleSide = findMiddlePieceWithoutTopFaceColorAndBottomFaceColor(
        rejectedMiddlePieceList,
      );
      if (faceAndMiddleSide == null) {
        // Error
        return AlgorithmStepResult(false, []);
      }

      // if it is at the correct place, go back and find another middle piece
      if (middleIsAtCorrectPlace(faceAndMiddleSide)) {
        rejectedMiddlePieceList.add(faceAndMiddleSide);
        continue;
      }

      // if it is at some incorrect place and not on top, make moves to put the piece
      //   to a middle position on the top
      if (!middlePieceIsOnTop(faceAndMiddleSide)) {
        Coords coords1 = FaceAndMiddleSide.mapMiddleSideToCoords[faceAndMiddleSide.middleSide]!;
        ColorName color1 = RubikCube.getColorName(faceAndMiddleSide.face, coords1.row, coords1.column);
        var connected = getConnectedPieceFaceAndMiddleSide(faceAndMiddleSide);
        var coords2 = FaceAndMiddleSide.mapMiddleSideToCoords[connected.middleSide]!;
        ColorName color2 = RubikCube.getColorName(connected.face, coords2.row, coords2.column);

        makeMovesToPutMiddlePieceOnTop(faceAndMiddleSide, step.logList);
        faceAndMiddleSide = findMiddleNewPlace(color1, color2);
        if (faceAndMiddleSide == null) {
          // Error
          return AlgorithmStepResult(false, []);
        }
      }

      // if it is at some incorrect place on top, apply the movements to place it
      //   to the correct position
      if (middlePieceIsOnTop(faceAndMiddleSide)) {
        faceAndMiddleSide = rotateTopUntilMiddlePieceColorIsAboveFaceCenterWithSameColor(
          faceAndMiddleSide,
          step.logList,
        );
        ColorName colorName = colorOfTopNeighbourOfMiddlePiece(faceAndMiddleSide);
        if (colorName ==
            RubikCube.mapFaceToColorName[RubikCube.getNeighbourFace(faceAndMiddleSide.face, FaceDirection.right)]) {
          // rotate to the right
          rotateToTheRight(faceAndMiddleSide, step.logList);
        } else if (colorName ==
            RubikCube.mapFaceToColorName[RubikCube.getNeighbourFace(faceAndMiddleSide.face, FaceDirection.left)]) {
          // rotate to the left
          rotateToTheLeft(faceAndMiddleSide, step.logList);
        }
      }
    }

    return AlgorithmStepResult(true, step.logList);
  }

  FaceAndMiddleSide? findMiddleNewPlace(ColorName color1, ColorName color2) {
    for (var face in <Face>[Face.front, Face.right, Face.back, Face.left]) {
      for (var middleSide in <MiddleSide>[MiddleSide.up, MiddleSide.left, MiddleSide.right]) {
        Coords coords = FaceAndMiddleSide.mapMiddleSideToCoords[middleSide]!;
        var pieceColor = RubikCube.getColorName(face, coords.row, coords.column);

        FaceAndMiddleSide connected = getConnectedPieceFaceAndMiddleSide(FaceAndMiddleSide(face, middleSide));
        Coords connectedCoords = FaceAndMiddleSide.mapMiddleSideToCoords[connected.middleSide]!;

        var connectedPieceColor = RubikCube.getColorName(connected.face, connectedCoords.row, connectedCoords.column);

        if ((pieceColor == color1 && connectedPieceColor == color2) ||
            (pieceColor == color2 && connectedPieceColor == color1)) {
          return FaceAndMiddleSide(face, middleSide);
        }
      }
    }
    return null;
  }

  void rotateToTheRight(FaceAndMiddleSide faceAndMiddleSide, List<FaceMovementLog> step) {
    step.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U);
    step.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.R]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.R);
    step.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U_]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U_);
    step.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.R_]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.R_);
    step.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U_]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U_);
    step.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.F_]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.F_);
    step.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U);
    step.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.F]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.F);
  }

  void rotateToTheLeft(FaceAndMiddleSide faceAndMiddleSide, List<FaceMovementLog> stepList) {
    stepList.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U_]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U_);
    stepList.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.L_]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.L_);
    stepList.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U);
    stepList.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.L]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.L);
    stepList.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U);
    stepList.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.F]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.F);
    stepList.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U_]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U_);
    stepList.add(
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.F_]!),
    );
    RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.F_);
  }

  /// This method check the middle pieces on the right and left sides of the vertical faces.
  /// If any of them are not at the faces with the same middle colors, return false. Otherwise, return true.
  bool allMiddlePiecesAreCorrectlyPlaced() {
    for (var verticalFace in <Face>[Face.front, Face.right, Face.back, Face.left]) {
      for (var middleSide in <MiddleSide>[MiddleSide.left, MiddleSide.right /*, MiddleSide.up*/]) {
        if (!middleIsAtCorrectPlace(FaceAndMiddleSide(verticalFace, middleSide))) {
          return false;
        }
      }
    }
    return true;
  }

  FaceAndMiddleSide? findMiddlePieceWithoutTopFaceColorAndBottomFaceColor(
    List<FaceAndMiddleSide> rejectedMiddlePieceList,
  ) {
    for (var verticalFace in <Face>[Face.front, Face.right, Face.back, Face.left]) {
      for (var middleSide in <MiddleSide>[MiddleSide.left, MiddleSide.right, MiddleSide.up]) {
        Coords coords = FaceAndMiddleSide.mapMiddleSideToCoords[middleSide]!;
        FaceAndMiddleSide faceAndMiddleSide = FaceAndMiddleSide(verticalFace, middleSide);
        var connectedPiece = getConnectedPieceFaceAndMiddleSide(faceAndMiddleSide);
        var connectedPieceCoords = FaceAndMiddleSide.mapMiddleSideToCoords[connectedPiece.middleSide]!;
        if (!rejectedMiddlePieceList.contains(faceAndMiddleSide) &&
            !middleIsAtCorrectPlace(faceAndMiddleSide) &&
            RubikCube.getColorName(verticalFace, coords.row, coords.column) != RubikCube.mapFaceToColorName[Face.top] &&
            RubikCube.getColorName(verticalFace, coords.row, coords.column) !=
                RubikCube.mapFaceToColorName[Face.bottom] &&
            RubikCube.getColorName(connectedPiece.face, connectedPieceCoords.row, connectedPieceCoords.column) !=
                RubikCube.mapFaceToColorName[Face.top] &&
            RubikCube.getColorName(connectedPiece.face, connectedPieceCoords.row, connectedPieceCoords.column) !=
                RubikCube.mapFaceToColorName[Face.bottom]) {
          return faceAndMiddleSide;
        }
      }
    }
    return null;
  }

  bool middleIsAtCorrectPlace(FaceAndMiddleSide faceAndMiddleSide) {
    var coords = FaceAndMiddleSide.mapMiddleSideToCoords[faceAndMiddleSide.middleSide]!;
    if (RubikCube.mapFaceToColorName[faceAndMiddleSide.face] !=
        RubikCube.getColorName(faceAndMiddleSide.face, coords.row, coords.column)) {
      return false;
    } else {
      FaceAndMiddleSide connectedPiece = getConnectedPieceFaceAndMiddleSide(faceAndMiddleSide);
      coords = FaceAndMiddleSide.mapMiddleSideToCoords[connectedPiece.middleSide]!;
      if (RubikCube.mapFaceToColorName[connectedPiece.face] !=
          RubikCube.getColorName(connectedPiece.face, coords.row, coords.column)) {
        return false;
      }
    }
    return true;
  }

  static FaceAndMiddleSide getConnectedPieceFaceAndMiddleSide(FaceAndMiddleSide refPiece) {
    return switch (refPiece.face) {
      Face.front => switch (refPiece.middleSide) {
        MiddleSide.up => FaceAndMiddleSide(Face.top, MiddleSide.down),
        MiddleSide.right => FaceAndMiddleSide(Face.right, MiddleSide.left),
        MiddleSide.down => FaceAndMiddleSide(Face.bottom, MiddleSide.up),
        MiddleSide.left => FaceAndMiddleSide(Face.left, MiddleSide.right),
      },
      Face.top => switch (refPiece.middleSide) {
        MiddleSide.up => FaceAndMiddleSide(Face.back, MiddleSide.up),
        MiddleSide.right => FaceAndMiddleSide(Face.right, MiddleSide.up),
        MiddleSide.down => FaceAndMiddleSide(Face.front, MiddleSide.up),
        MiddleSide.left => FaceAndMiddleSide(Face.left, MiddleSide.up),
      },
      Face.right => switch (refPiece.middleSide) {
        MiddleSide.up => FaceAndMiddleSide(Face.top, MiddleSide.right),
        MiddleSide.right => FaceAndMiddleSide(Face.back, MiddleSide.left),
        MiddleSide.down => FaceAndMiddleSide(Face.bottom, MiddleSide.right),
        MiddleSide.left => FaceAndMiddleSide(Face.front, MiddleSide.right),
      },
      Face.back => switch (refPiece.middleSide) {
        MiddleSide.up => FaceAndMiddleSide(Face.top, MiddleSide.up),
        MiddleSide.right => FaceAndMiddleSide(Face.left, MiddleSide.left),
        MiddleSide.down => FaceAndMiddleSide(Face.bottom, MiddleSide.down),
        MiddleSide.left => FaceAndMiddleSide(Face.right, MiddleSide.right),
      },
      Face.bottom => switch (refPiece.middleSide) {
        MiddleSide.up => FaceAndMiddleSide(Face.front, MiddleSide.down),
        MiddleSide.right => FaceAndMiddleSide(Face.right, MiddleSide.down),
        MiddleSide.down => FaceAndMiddleSide(Face.back, MiddleSide.down),
        MiddleSide.left => FaceAndMiddleSide(Face.left, MiddleSide.down),
      },
      Face.left => switch (refPiece.middleSide) {
        MiddleSide.up => FaceAndMiddleSide(Face.top, MiddleSide.left),
        MiddleSide.right => FaceAndMiddleSide(Face.front, MiddleSide.left),
        MiddleSide.down => FaceAndMiddleSide(Face.bottom, MiddleSide.left),
        MiddleSide.left => FaceAndMiddleSide(Face.back, MiddleSide.right),
      },
    }; // vermelho e verde
  }

  bool middlePieceIsOnTop(FaceAndMiddleSide faceAndMiddleSide) {
    var connectedPiece = getConnectedPieceFaceAndMiddleSide(faceAndMiddleSide);
    if (faceAndMiddleSide.face == Face.top || connectedPiece.face == Face.top) {
      return true;
    }
    return false;
  }

  void makeMovesToPutMiddlePieceOnTop(FaceAndMiddleSide faceAndMiddleSide, List<FaceMovementLog> stepList) {
    if (faceAndMiddleSide.middleSide == MiddleSide.right) {
      faceAndMiddleSide = getConnectedPieceFaceAndMiddleSide(faceAndMiddleSide);
    }
    rotateToTheLeft(faceAndMiddleSide, stepList);
  }

  FaceAndMiddleSide rotateTopUntilMiddlePieceColorIsAboveFaceCenterWithSameColor(
    FaceAndMiddleSide faceAndMiddleSide,
    List<FaceMovementLog> stepList,
  ) {
    var middleCoords = FaceAndMiddleSide.mapMiddleSideToCoords[faceAndMiddleSide.middleSide]!;
    var middleColor = RubikCube.getColorName(faceAndMiddleSide.face, middleCoords.row, middleCoords.column);
    while (middleColor != RubikCube.mapFaceToColorName[faceAndMiddleSide.face]) {
      stepList.add(
        FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[faceAndMiddleSide.face]![Movement.U]!),
      );
      RubikSolverMovement.doMovement(faceAndMiddleSide.face, Movement.U);

      faceAndMiddleSide.face = RubikCube.getNeighbourFace(faceAndMiddleSide.face, FaceDirection.left);
    }
    return faceAndMiddleSide;
  }

  ColorName colorOfTopNeighbourOfMiddlePiece(FaceAndMiddleSide argFaceAndMiddleSide) {
    var connectedPiece = getConnectedPieceFaceAndMiddleSide(argFaceAndMiddleSide);
    var connectedPieceCoords = FaceAndMiddleSide.mapMiddleSideToCoords[connectedPiece.middleSide]!;
    if (connectedPiece.face == Face.top) {
      return RubikCube.getColorName(connectedPiece.face, connectedPieceCoords.row, connectedPieceCoords.column);
    }
    return ColorName.none;
  }
}
