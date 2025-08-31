import 'dart:io';
import 'dart:math';

import 'cube_solver/rubik_solver_movement.dart';

enum FaceDirection { up, left, down, right }

enum PieceType { center, border, corner }

abstract class CubePiece {
  Face currentFace;
  int currentRow;
  int currentColumn;
  final ColorName colorName;
  final Map<FaceDirection, CubePiece> fixedConnection = <FaceDirection, CubePiece>{};

  CubePiece(this.currentFace, this.currentRow, this.currentColumn, this.colorName);

  void setFixedConnections() {}
}

typedef Coords = ({int row, int column});
typedef MiddlePiece = ({Face face, Coords coords});

class CubeCenter extends CubePiece {
  CubeCenter(super.currentFace, super.currentRow, super.currentColumn, super.colorName);
}

class CubeBorder extends CubePiece {
  CubeBorder(super.currentFace, super.currentRow, super.currentColumn, super.colorName);

  @override
  void setFixedConnections() {
    if (super.fixedConnection.isNotEmpty) return;
    for (FaceDirection neighbour in FaceDirection.values) {
      switch (neighbour) {
        case FaceDirection.up:
          int rowUp = super.currentRow - 1;
          if (rowUp < 0) {}
        case FaceDirection.left:
        case FaceDirection.down:
        case FaceDirection.right:
      }
    }
  }
}

class CubeCorner extends CubePiece {
  CubeCorner(super.currentFace, super.currentRow, super.currentColumn, super.colorName);
}

enum Face { front, top, right, back, bottom, left }

enum ColorName {
  white("W"),
  yellow("Y"),
  red("R"),
  orange("O"),
  green("G"),
  blue("B"),
  none("-");

  final String startChar;
  const ColorName(this.startChar);
}

enum CoordAxis { x, y }

class RubikCube {
  static final Map<(Face, Face), Face> mapFaceAndRelativeFaceToFace = <(Face, Face), Face>{
    (Face.front, Face.top): Face.top,
    (Face.front, Face.bottom): Face.bottom,
    (Face.front, Face.right): Face.right,
    (Face.front, Face.left): Face.left,
    (Face.front, Face.front): Face.front,
    (Face.front, Face.back): Face.back,

    (Face.left, Face.top): Face.top,
    (Face.left, Face.bottom): Face.bottom,
    (Face.left, Face.right): Face.front,
    (Face.left, Face.left): Face.back,
    (Face.left, Face.front): Face.left,
    (Face.left, Face.back): Face.right,

    (Face.right, Face.top): Face.top,
    (Face.right, Face.bottom): Face.bottom,
    (Face.right, Face.right): Face.back,
    (Face.right, Face.left): Face.front,
    (Face.right, Face.front): Face.right,
    (Face.right, Face.back): Face.left,

    (Face.back, Face.top): Face.top,
    (Face.back, Face.bottom): Face.bottom,
    (Face.back, Face.right): Face.left,
    (Face.back, Face.left): Face.right,
    (Face.back, Face.front): Face.back,
    (Face.back, Face.back): Face.front,

    (Face.top, Face.top): Face.back,
    (Face.top, Face.bottom): Face.front,
    (Face.top, Face.right): Face.right,
    (Face.top, Face.left): Face.left,
    (Face.top, Face.front): Face.top,
    (Face.top, Face.back): Face.bottom,

    (Face.bottom, Face.top): Face.front,
    (Face.bottom, Face.bottom): Face.back,
    (Face.bottom, Face.right): Face.right,
    (Face.bottom, Face.left): Face.left,
    (Face.bottom, Face.front): Face.bottom,
    (Face.bottom, Face.back): Face.top,
  };

  static final Map<ColorName, Face> mapColorNameToFace = <ColorName, Face>{
    ColorName.blue: Face.front,
    ColorName.red: Face.right,
    ColorName.green: Face.back,
    ColorName.orange: Face.left,
    ColorName.yellow: Face.top,
    ColorName.white: Face.bottom,
  };

  static final Map<Face, ColorName> mapFaceToColorName = <Face, ColorName>{
    Face.front: ColorName.blue,
    Face.right: ColorName.red,
    Face.back: ColorName.green,
    Face.left: ColorName.orange,
    Face.top: ColorName.yellow,
    Face.bottom: ColorName.white,
  };

  static Face getNeighbourFace(Face referenceFace, FaceDirection direction) {
    // var direction = FaceDirection.up;
    switch (referenceFace) {
      case Face.front:
        switch (direction) {
          case FaceDirection.up:
            return Face.top;
          case FaceDirection.left:
            return Face.left;
          case FaceDirection.down:
            return Face.bottom;
          case FaceDirection.right:
            return Face.right;
        }
      case Face.top:
        switch (direction) {
          case FaceDirection.up:
            return Face.back;
          case FaceDirection.left:
            return Face.left;
          case FaceDirection.down:
            return Face.front;
          case FaceDirection.right:
            return Face.right;
        }
      case Face.right:
        switch (direction) {
          case FaceDirection.up:
            return Face.top;
          case FaceDirection.left:
            return Face.front;
          case FaceDirection.down:
            return Face.bottom;
          case FaceDirection.right:
            return Face.back;
        }
      case Face.back:
        switch (direction) {
          case FaceDirection.up:
            return Face.top;
          case FaceDirection.down:
            return Face.bottom;
          case FaceDirection.left:
            return Face.right;
          case FaceDirection.right:
            return Face.left;
        }
      case Face.bottom:
        switch (direction) {
          case FaceDirection.up:
            return Face.front;
          case FaceDirection.down:
            return Face.back;
          case FaceDirection.left:
            return Face.left;
          case FaceDirection.right:
            return Face.right;
        }
      case Face.left:
        switch (direction) {
          case FaceDirection.up:
            return Face.top;
          case FaceDirection.down:
            return Face.bottom;
          case FaceDirection.left:
            return Face.back;
          case FaceDirection.right:
            return Face.front;
        }
    }
  }

  static final Map<Face, List<List<ColorName>>> mapFaceToColorNameMatrix = <Face, List<List<ColorName>>>{
    Face.front: [
      [ColorName.orange, ColorName.green, ColorName.red],
      [ColorName.blue, ColorName.blue, ColorName.white],
      [ColorName.white, ColorName.blue, ColorName.green],
    ],
    Face.right: [
      [ColorName.yellow, ColorName.blue, ColorName.green],
      [ColorName.red, ColorName.red, ColorName.orange],
      [ColorName.red, ColorName.orange, ColorName.orange],
    ],
    Face.left: [
      [ColorName.white, ColorName.red, ColorName.blue],
      [ColorName.green, ColorName.orange, ColorName.yellow],
      [ColorName.yellow, ColorName.green, ColorName.red],
    ],
    Face.back: [
      [ColorName.white, ColorName.green, ColorName.red],
      [ColorName.white, ColorName.green, ColorName.orange],
      [ColorName.yellow, ColorName.orange, ColorName.green],
    ],
    Face.top: [
      [ColorName.green, ColorName.white, ColorName.orange],
      [ColorName.yellow, ColorName.yellow, ColorName.red],
      [ColorName.white, ColorName.yellow, ColorName.blue],
    ],
    Face.bottom: [
      [ColorName.blue, ColorName.white, ColorName.yellow],
      [ColorName.red, ColorName.white, ColorName.blue],
      [ColorName.orange, ColorName.yellow, ColorName.blue],
    ],
  };

  static Map<Face, List<List<ColorName>>> copyOfMapFaceToColorNameMatrix() {
    var copy = <Face, List<List<ColorName>>>{};
    for (Face face in Face.values) {
      copy[face] = List<List<ColorName>>.generate(3, (row) {
        return List<ColorName>.generate(3, (column) {
          return mapFaceToColorNameMatrix[face]![row][column];
        });
      });
    }
    return copy;
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

  static void resetCube() {
    for (var face in Face.values) {
      for (var row in [0, 1, 2]) {
        for (var column in [0, 1, 2]) {
          if (row == 1 && column == 1) {
            continue;
          }
          setColorName(face, row, column, ColorName.none);
        }
      }
    }
  }

  static final List<Coords> middleCoords = <Coords>[
    (row: 0, column: 1),
    (row: 1, column: 0),
    (row: 1, column: 2),
    (row: 2, column: 1),
  ];
  static final List<Coords> cornerCoords = <Coords>[
    (row: 0, column: 0),
    (row: 0, column: 2),
    (row: 2, column: 0),
    (row: 2, column: 2),
  ];

  static List<Coords> getUnitedCoords() {
    var list = <Coords>[];
    list.addAll(middleCoords);
    list.addAll(cornerCoords);
    return list;
  }

  static bool isCorner(Coords coord) {
    if (cornerCoords.contains(coord)) {
      return true;
    }
    return false;
  }

  static void setCubeSolved() {
    for (var face in Face.values) {
      for (var row = 0; row < 3; ++row) {
        for (var column = 0; column < 3; ++column) {
          mapFaceToColorNameMatrix[face]![row][column] = mapFaceToColorName[face]!;
        }
      }
    }
  }

  static void createRandomCubeState() {
    setCubeSolved();
    Random randomGenerator = Random.secure();
    for (int i = 0; i < 100; ++i) {
      int r = randomGenerator.nextInt(18);
      Movement m = Movement.values[r];
      RubikSolverMovement.doMovement(Face.front, m);
    }
    // printCube();
  }

  static ColorName getColorName(Face face, int linha, int coluna) {
    if (linha < 0 || linha > 2 || coluna < 0 || coluna > 2) {
      return ColorName.none;
    }
    if (mapFaceToColorNameMatrix[face] == null) {
      return ColorName.none;
    }
    return mapFaceToColorNameMatrix[face]![linha][coluna];
  }

  static bool colorHasChanged = false;

  static void setColorName(Face face, int linha, int coluna, ColorName colorName) {
    if (linha < 0 || linha > 2 || coluna < 0 || coluna > 2) {
      return;
    }
    if (linha == 1 && coluna == 1) {
      return;
    }
    if (mapFaceToColorNameMatrix[face] == null) {
      return;
    }
    mapFaceToColorNameMatrix[face]![linha][coluna] = colorName;
    colorHasChanged = true;
  }

  static bool isFaceOppositeToOtherFace(Face face1, Face face2) {
    switch (face1) {
      case Face.front:
        return face2 == Face.back;
      case Face.back:
        return face2 == Face.front;
      case Face.right:
        return face2 == Face.left;
      case Face.left:
        return face2 == Face.right;
      case Face.top:
        return face2 == Face.bottom;
      case Face.bottom:
        return face2 == Face.top;
    }
  }

  static void resetCubeToState(Map<Face, List<List<ColorName>>> initialState) {
    for (var face in Face.values) {
      for (var row = 0; row < 3; ++row) {
        for (var column = 0; column < 3; ++column) {
          setColorName(face, row, column, initialState[face]![row][column]);
        }
      }
    }
  }

  static void printCubeFaceToCubeMatrix(Face face, List<List<String>> cubeMatrix, int startRow, int startColumn) {
    for (int r = 0; r < 3; ++r) {
      for (int c = 0; c < 3; ++c) {
        ColorName color = RubikCube.getColorName(face, r, c);
        cubeMatrix[startRow + r][startColumn + c] = color.startChar;
      }
    }
  }

  static void printCubeMatrix(List<List<String>> cubeMatrix) {
    print("Cube current state:");
    for (var cubeMatrixRow in cubeMatrix) {
      for (var cubeFaceColumn in cubeMatrixRow) {
        stdout.write(" $cubeFaceColumn ");
      }
      stdout.writeln();
    }
  }

  static void printCube() {
    // make a matrix 9x12 of characters, initially filled with character space
    List<List<String>> cubeMatrix = <List<String>>[];
    for (int r = 0; r < 9; ++r) {
      cubeMatrix.add(<String>[' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']);
    }
    // print the cube faces to the matrix
    printCubeFaceToCubeMatrix(Face.left, cubeMatrix, 3, 0);
    printCubeFaceToCubeMatrix(Face.front, cubeMatrix, 3, 3);
    printCubeFaceToCubeMatrix(Face.right, cubeMatrix, 3, 6);
    printCubeFaceToCubeMatrix(Face.back, cubeMatrix, 3, 9);
    printCubeFaceToCubeMatrix(Face.top, cubeMatrix, 0, 3);
    printCubeFaceToCubeMatrix(Face.bottom, cubeMatrix, 6, 3);

    printCubeMatrix(cubeMatrix);
  }
}
