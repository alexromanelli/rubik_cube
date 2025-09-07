import 'package:rubik_cube/rubik_cube.dart';

/// Movement is an enumeration of all movements that can be done in a Rubik's Cube
enum Movement {
  /// 90° clockwise rotation of the Right Side (right is relative to the blue side, considered the front)
  r("R"),

  /// 90° counterclockwise rotation of the Right Side (right is relative to the blue side, considered the front)
  r_("R'"),

  /// 180° clockwise rotation (if it was counterclockwise, the result is the same) of the Right Side
  /// (right is relative to the blue side, considered the front)
  r2("R2"),

  /// 90° clockwise rotation of the Left Side (left is relative to the blue side, considered the front)
  l("L"),

  /// 90° counterclockwise rotation of the Left Side (left is relative to the blue side, considered the front)
  l_("L'"),

  /// 180° clockwise rotation of the Left Side (if it was counterclockwise, the result is the same)
  /// (left is relative to the blue side, considered the front)
  l2("L2"),

  /// 90° clockwise rotation of the Up Side (up is relative to the blue side, considered the front)
  u("U"),

  /// 90° counterclockwise rotation of the Up Side (up is relative to the blue side, considered the front)
  u_("U'"),

  /// 180° clockwise rotation of the Up Side (if it was counterclockwise, the result is the same)
  /// (up is relative to the blue side, considered the front)
  u2("U2"),

  /// 90° clockwise rotation of the Down Side (left is relative to the blue side, considered the front)
  d("D"),

  /// 90° counterclockwise rotation of the Down Side (left is relative to the blue side, considered the front)
  d_("D'"),

  /// 180° clockwise rotation of the Down Side (if it was counterclockwise, the result is the same)
  /// (down is relative to the blue side, considered the front)
  d2("D2"),

  /// 90° clockwise rotation of the Front Side (front is relative to the blue side, considered the front)
  f("F"),

  /// 90° counterclockwise rotation of the Front Side (front is relative to the blue side, considered the front)
  f_("F'"),

  /// 180° clockwise rotation of the Front Side (if it was counterclockwise, the result is the same)
  /// (front is relative to the blue side, considered the front)
  f2("F2"),

  /// 90° clockwise rotation of the Back Side (back is relative to the blue side, considered the front)
  b("B"),

  /// 90° counterclockwise rotation of the Back Side (back is relative to the blue side, considered the front)
  b_("B'"),

  /// 180° clockwise rotation of the Back Side (if it was counterclockwise, the result is the same)
  /// (back is relative to the blue side, considered the front)
  b2("B2");

  final String name;
  const Movement(this.name);
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

enum RotationSense { clockwise, counterclockwise }

class RubikSolverMovement {
  static const internalJumpSize = 2;
  static const externalJumpSize = 3;

  static String movementToString(Movement mov) {
    return switch (mov) {
      Movement.r => "R",
      Movement.r_ => "R'",
      Movement.r2 => "R2",
      Movement.l => "L",
      Movement.l_ => "L'",
      Movement.l2 => "L2",
      Movement.u => "U",
      Movement.u_ => "U'",
      Movement.u2 => "U2",
      Movement.d => "D",
      Movement.d_ => "D'",
      Movement.d2 => "D2",
      Movement.f => "F",
      Movement.f_ => "F'",
      Movement.f2 => "F2",
      Movement.b => "B",
      Movement.b_ => "B'",
      Movement.b2 => "B2",
    };
  }

  static final List<PiecePosition> internalPieceSequence = <PiecePosition>[
    PiecePosition(null, 0, 0),
    PiecePosition(null, 0, 1),
    PiecePosition(null, 0, 2),
    PiecePosition(null, 1, 2),
    PiecePosition(null, 2, 2),
    PiecePosition(null, 2, 1),
    PiecePosition(null, 2, 0),
    PiecePosition(null, 1, 0),
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
      PiecePosition(Face.bottom, 2, 0),
      PiecePosition(Face.bottom, 2, 1),
      PiecePosition(Face.bottom, 2, 2),
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
      PiecePosition(Face.back, 2, 2),
      PiecePosition(Face.back, 1, 2),
      PiecePosition(Face.back, 0, 2),
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
    doMovement(Face.front, Movement.b);
    // // rotateFace90(Face.front, RotationSense.counterclockwise);
    // var face = Face.bottom;
    // for (int i = 0; i < internalJumpSize; ++i) {
    //   rotateOne(internalPieceSequence, face, RotationSense.clockwise);
    // }
    // for (int i = 0; i < externalJumpSize; ++i) {
    //   rotateOne(mapFaceToExternalPieceSequence[face]!, face, RotationSense.clockwise);
    // }
  }

  static void doMovement(Face referenceFace, Movement movement) {
    switch (movement) {
      case Movement.r:
        doGeneralMovement(referenceFace, Face.right, RotationSense.clockwise, false);
      case Movement.r_:
        doGeneralMovement(referenceFace, Face.right, RotationSense.counterclockwise, false);
      case Movement.r2:
        doGeneralMovement(referenceFace, Face.right, RotationSense.clockwise, true);
      case Movement.l:
        doGeneralMovement(referenceFace, Face.left, RotationSense.clockwise, false);
      case Movement.l_:
        doGeneralMovement(referenceFace, Face.left, RotationSense.counterclockwise, false);
      case Movement.l2:
        doGeneralMovement(referenceFace, Face.left, RotationSense.clockwise, true);
      case Movement.u:
        doGeneralMovement(referenceFace, Face.top, RotationSense.clockwise, false);
      case Movement.u_:
        doGeneralMovement(referenceFace, Face.top, RotationSense.counterclockwise, false);
      case Movement.u2:
        doGeneralMovement(referenceFace, Face.top, RotationSense.clockwise, true);
      case Movement.d:
        doGeneralMovement(referenceFace, Face.bottom, RotationSense.clockwise, false);
      case Movement.d_:
        doGeneralMovement(referenceFace, Face.bottom, RotationSense.counterclockwise, false);
      case Movement.d2:
        doGeneralMovement(referenceFace, Face.bottom, RotationSense.clockwise, true);
      case Movement.f:
        doGeneralMovement(referenceFace, Face.front, RotationSense.clockwise, false);
      case Movement.f_:
        doGeneralMovement(referenceFace, Face.front, RotationSense.counterclockwise, false);
      case Movement.f2:
        doGeneralMovement(referenceFace, Face.front, RotationSense.clockwise, true);
      case Movement.b:
        doGeneralMovement(referenceFace, Face.back, RotationSense.clockwise, false);
      case Movement.b_:
        doGeneralMovement(referenceFace, Face.back, RotationSense.counterclockwise, false);
      case Movement.b2:
        doGeneralMovement(referenceFace, Face.back, RotationSense.clockwise, true);
    }
  }

  static void doGeneralMovement(Face referenceFace, Face relativeFace, RotationSense sense, bool twoMoves) {
    Face faceToMove = RubikCube.mapFaceAndRelativeFaceToFace[(referenceFace, relativeFace)]!;
    rotateFace90(faceToMove, sense);
    if (twoMoves) {
      rotateFace90(faceToMove, sense);
    }
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

  static void rotateOne(List<PiecePosition> pieceSequence, Face face, RotationSense sense) {
    setPieceSequenceFace(internalPieceSequence, face);
    var backupColor = RubikCube.getColorName(
      pieceSequence.elementAt(0).face!,
      pieceSequence.elementAt(0).row,
      pieceSequence.elementAt(0).column,
    );
    for (
      int i = switch (sense) {
        RotationSense.clockwise => pieceSequence.length - 1,
        RotationSense.counterclockwise => 1,
      };
      switch (sense) {
        RotationSense.clockwise => i > 0,
        RotationSense.counterclockwise => i < pieceSequence.length,
      };
      i = switch (sense) {
        RotationSense.clockwise => i - 1,
        RotationSense.counterclockwise => i + 1,
      }
    ) {
      var face = pieceSequence.elementAt(i).face!;
      var row = pieceSequence.elementAt(i).row;
      var column = pieceSequence.elementAt(i).column;
      var color = RubikCube.getColorName(face, row, column);
      var pos = switch (sense) {
        RotationSense.clockwise => (i + 1) % pieceSequence.length,
        RotationSense.counterclockwise => i - 1,
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
      backupColor,
    );
  }

  static void setPieceSequenceFace(List<PiecePosition> pieceSequence, Face currentFace) {
    for (var element in pieceSequence) {
      element.face = currentFace;
    }
  }
}
