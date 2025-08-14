
import 'dart:math';

import 'package:rubik_cube/cube_plotter/drawing_constants.dart';
import 'package:rubik_cube/rubik_cube.dart';

enum Movement {
  R, R_, R2, L, L_, L2, U, U_, U2, D, D_, D2, F, F_, F2, B, B_, B2
}

class PiecePosition {
  Face? face;
  int row;
  int column;

  PiecePosition(this.face, this.row, this.column);

  PiecePosition copy() {
    var neighbourCopy = PiecePosition(face, row, column);
    return neighbourCopy;
  }
}

enum RotationSense {
  clockwise, counterclockwise
}

class RubikSolverMovement {
  // Movement movement;

  static const internalJumpSize = 2;
  static const externalJumpSize = 3;

  static final List<PiecePosition> internalPieceSequence = <PiecePosition>[
    PiecePosition(null, 0, 0), PiecePosition(null, 0, 1), PiecePosition(null, 0, 2), PiecePosition(null, 1, 2),
    PiecePosition(null, 2, 2), PiecePosition(null, 2, 1), PiecePosition(null, 2, 0), PiecePosition(null, 1, 0),
  ];

  static final Map<Face, List<PiecePosition>> mapFaceToExternalPieceSequence = <Face, List<PiecePosition>>{
    Face.front: <PiecePosition>[
      PiecePosition(Face.top, 2, 0),
      PiecePosition(Face.top, 2, 1),
      PiecePosition(Face.top, 2, 2),
      PiecePosition(Face.right, 0, 0),
      PiecePosition(Face.right, 1, 0),
      PiecePosition(Face.right, 2, 0),
      PiecePosition(Face.bottom, 0, 2),
      PiecePosition(Face.bottom, 0, 1),
      PiecePosition(Face.bottom, 0, 0),
      PiecePosition(Face.left, 2, 2),
      PiecePosition(Face.left, 1, 2),
      PiecePosition(Face.left, 0, 2),
    ],
    Face.right: <PiecePosition>[
      PiecePosition(Face.top, 2, 2),
      PiecePosition(Face.top, 1, 2),
      PiecePosition(Face.top, 0, 2),
      PiecePosition(Face.back, 0, 0),
      PiecePosition(Face.back, 1, 0),
      PiecePosition(Face.back, 2, 0),
      PiecePosition(Face.bottom, 2, 2),
      PiecePosition(Face.bottom, 1, 2),
      PiecePosition(Face.bottom, 0, 2),
      PiecePosition(Face.front, 2, 2),
      PiecePosition(Face.front, 1, 2),
      PiecePosition(Face.front, 0, 2),
    ],
    Face.back: <PiecePosition>[
      PiecePosition(Face.top, 0, 2),
      PiecePosition(Face.top, 0, 1),
      PiecePosition(Face.top, 0, 0),
      PiecePosition(Face.left, 0, 0),
      PiecePosition(Face.left, 1, 0),
      PiecePosition(Face.left, 2, 0),
      PiecePosition(Face.bottom, 2, 2),
      PiecePosition(Face.bottom, 2, 1),
      PiecePosition(Face.bottom, 2, 0),
      PiecePosition(Face.right, 2, 2),
      PiecePosition(Face.right, 1, 2),
      PiecePosition(Face.right, 0, 2),
    ],
    Face.left: <PiecePosition>[
      PiecePosition(Face.top, 0, 0),
      PiecePosition(Face.top, 1, 0),
      PiecePosition(Face.top, 2, 0),
      PiecePosition(Face.front, 0, 0),
      PiecePosition(Face.front, 1, 0),
      PiecePosition(Face.front, 2, 0),
      PiecePosition(Face.bottom, 0, 0),
      PiecePosition(Face.bottom, 1, 0),
      PiecePosition(Face.bottom, 2, 0),
      PiecePosition(Face.right, 2, 2),
      PiecePosition(Face.right, 1, 2),
      PiecePosition(Face.right, 0, 2),
    ],
    Face.top: <PiecePosition>[
      PiecePosition(Face.back, 0, 2),
      PiecePosition(Face.back, 0, 1),
      PiecePosition(Face.back, 0, 0),
      PiecePosition(Face.right, 0, 2),
      PiecePosition(Face.right, 0, 1),
      PiecePosition(Face.right, 0, 0),
      PiecePosition(Face.front, 0, 2),
      PiecePosition(Face.front, 0, 1),
      PiecePosition(Face.front, 0, 0),
      PiecePosition(Face.left, 0, 2),
      PiecePosition(Face.left, 0, 1),
      PiecePosition(Face.left, 0, 0),
    ],
    Face.bottom: <PiecePosition>[
      PiecePosition(Face.front, 2, 0),
      PiecePosition(Face.front, 2, 1),
      PiecePosition(Face.front, 2, 2),
      PiecePosition(Face.right, 2, 0),
      PiecePosition(Face.right, 2, 1),
      PiecePosition(Face.right, 2, 2),
      PiecePosition(Face.back, 2, 0),
      PiecePosition(Face.back, 2, 1),
      PiecePosition(Face.back, 2, 2),
      PiecePosition(Face.left, 2, 0),
      PiecePosition(Face.left, 2, 1),
      PiecePosition(Face.left, 2, 2),
    ],
  };

  // RubikSolverMovement(this.movement);

  static void testaRotacao() {
    // rotateFace90(Face.front, RotationSense.counterclockwise);
    for (int i = 0; i < internalJumpSize; ++i) {
      rotateOne(
          internalPieceSequence, Face.right, RotationSense.counterclockwise);
    }
    for (int i = 0; i < externalJumpSize; ++i) {
      rotateOne(internalPieceSequence, Face.right, RotationSense.counterclockwise);
    }
  }

  void doMovement(Movement movement, Face relativeTo) {
    switch (movement) {
      case Movement.R:
        doMovementR(relativeTo);
      case Movement.R_:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.R2:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.L:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.L_:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.L2:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.U:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.U_:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.U2:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.D:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.D_:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.D2:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.F:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.F_:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.F2:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.B:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.B_:
        // TODO: Handle this case.
        throw UnimplementedError();
      case Movement.B2:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
  }

  void doMovementR(Face relativeTo) {

  }

  /// This procedure rotates by 90 degree the face indicated by first parameter, with rotation
  /// sense indicated by second parameter. It uses the list of pieces that belong
  /// to this face and must be rotated, and the list of pieces by the neighbourhood.
  static void rotateFace90(Face face, RotationSense sense) {
    setPieceSequenceFace(internalPieceSequence, face);
    var internalJumpSize = 2, externalJumpSize = 3;
    for (int i = 0; i < internalJumpSize; i++) {
      rotateOne(internalPieceSequence, face, sense);
    }
    for (int i = 0; i < externalJumpSize; i++) {
      rotateOne(mapFaceToExternalPieceSequence[face]!, face, sense);
    }
  }

  static List<ColorName> getPieceSubsequence(List<PiecePosition> pieceSequence, int subsequenceSize, RotationSense sense) {
    return List<ColorName>.generate(
      subsequenceSize,
      (index) {
        var pos = switch (sense) {
          RotationSense.clockwise => index,
          RotationSense.counterclockwise => pieceSequence.length - subsequenceSize + index,
        };
        return RubikCube.getColorName(
          pieceSequence.elementAt(pos).face!,
          pieceSequence.elementAt(pos).row,
          pieceSequence.elementAt(pos).column,
        );
      },
    );
  }

  static void rotateOne(List<PiecePosition> pieceSequence, Face face, RotationSense sense) {
    setPieceSequenceFace(internalPieceSequence, face);
    var backupColor = RubikCube.getColorName(
      pieceSequence.elementAt(0).face!,
      pieceSequence.elementAt(0).row,
      pieceSequence.elementAt(0).column,
    );
    for (int i = switch (sense) {
                   RotationSense.clockwise => pieceSequence.length - 1,
                   RotationSense.counterclockwise => 1
         };
         switch (sense) {
           RotationSense.clockwise => i > 0,
           RotationSense.counterclockwise => i < pieceSequence.length
         };
         i = switch (sense) {
           RotationSense.clockwise => i - 1,
           RotationSense.counterclockwise => i + 1
         }) {
      var face = pieceSequence.elementAt(i).face!;
      var row = pieceSequence.elementAt(i).row;
      var column = pieceSequence.elementAt(i).column;
      var color = RubikCube.getColorName(face, row, column);
      var pos = switch (sense) {
        RotationSense.clockwise => (i + 1) % pieceSequence.length,
        RotationSense.counterclockwise => i - 1
      };
      face = pieceSequence.elementAt(pos).face!;
      row = pieceSequence.elementAt(pos).row;
      column = pieceSequence.elementAt(pos).column;
      RubikCube.setColorName(face, row, column, color);
    }
    var indBackup = switch (sense) {
      RotationSense.clockwise => 1,
      RotationSense.counterclockwise => pieceSequence.length - 1,
    };
    RubikCube.setColorName(
        pieceSequence.elementAt(indBackup).face!,
        pieceSequence.elementAt(indBackup).row,
        pieceSequence.elementAt(indBackup).column,
        backupColor
    );
  }

  static int initialSequenceIndex(int sequenceLength, RotationSense sense) {
    return switch (sense) {
      RotationSense.clockwise => sequenceLength - 1,
      RotationSense.counterclockwise => 0,
    };
  }

  static void setPieceSequenceFace(List<PiecePosition> pieceSequence, Face currentFace) {
    for (var element in pieceSequence) {
      element.face = currentFace;
    }
  }

  static bool loopCondition(int currentIndex, int sequenceLength, int jump, RotationSense sense) {
    return switch (sense) {
      RotationSense.clockwise => currentIndex >= jump,
      RotationSense.counterclockwise => currentIndex < sequenceLength - jump,
    };
  }

  static int nextSequenceIndex(int currentIndex, int sequenceLength, RotationSense sense) {
    return switch (sense) {
      RotationSense.clockwise => currentIndex - 1,
      RotationSense.counterclockwise => currentIndex + 1,
    };
  }

  static int nextSequencePos(int currentIndex, int jumpLength, int sequenceLength, RotationSense sense) {
    return switch (sense) {
      RotationSense.clockwise => (currentIndex + jumpLength) % sequenceLength,
      RotationSense.counterclockwise => (
          currentIndex >= jumpLength
          ? currentIndex - jumpLength
          : sequenceLength - jumpLength + currentIndex
      ),
    };
  }
}

