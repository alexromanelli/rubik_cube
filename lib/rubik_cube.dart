enum NeighbourDirection { up, left, down, right }

enum PieceType { center, border, corner }

abstract class CubePiece {
  Face currentFace;
  int currentRow;
  int currentColumn;
  final ColorName colorName;
  final Map<NeighbourDirection, CubePiece> fixedConnection = <NeighbourDirection, CubePiece>{};

  CubePiece(this.currentFace, this.currentRow, this.currentColumn, this.colorName);

  void setFixedConnections() {}
}

class CubeCenter extends CubePiece {
  CubeCenter(super.currentFace, super.currentRow, super.currentColumn, super.colorName);
}

class CubeBorder extends CubePiece {
  CubeBorder(super.currentFace, super.currentRow, super.currentColumn, super.colorName);

  @override
  void setFixedConnections() {
    if (super.fixedConnection.isNotEmpty) return;
    for (NeighbourDirection neighbour in NeighbourDirection.values) {
      switch (neighbour) {
        case NeighbourDirection.up:
          int rowUp = super.currentRow - 1;
          if (rowUp < 0) {}
        case NeighbourDirection.left:
        case NeighbourDirection.down:
        case NeighbourDirection.right:
      }
    }
  }
}

class CubeCorner extends CubePiece {
  CubeCorner(super.currentFace, super.currentRow, super.currentColumn, super.colorName);
}

enum Face { front, top, right, back, bottom, left }

enum ColorName { white, yellow, red, orange, green, blue, none }

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

  static final Map<Face, List<List<ColorName>>> mapFaceToColorNameMatrix = <Face, List<List<ColorName>>>{
    Face.front: [
      [ColorName.yellow, ColorName.orange, ColorName.white],
      [ColorName.orange, ColorName.blue, ColorName.blue],
      [ColorName.blue, ColorName.yellow, ColorName.green],
    ],
    Face.right: [
      [ColorName.orange, ColorName.green, ColorName.red],
      [ColorName.yellow, ColorName.red, ColorName.yellow],
      [ColorName.red, ColorName.green, ColorName.orange],
    ],
    Face.left: [
      [ColorName.red, ColorName.red, ColorName.orange],
      [ColorName.white, ColorName.orange, ColorName.blue],
      [ColorName.white, ColorName.blue, ColorName.yellow],
    ],
    Face.back: [
      [ColorName.yellow, ColorName.orange, ColorName.white],
      [ColorName.orange, ColorName.green, ColorName.blue],
      [ColorName.blue, ColorName.yellow, ColorName.green],
    ],
    Face.top: [
      [ColorName.blue, ColorName.green, ColorName.blue],
      [ColorName.white, ColorName.yellow, ColorName.white],
      [ColorName.green, ColorName.white, ColorName.green],
    ],
    Face.bottom: [
      [ColorName.orange, ColorName.green, ColorName.yellow],
      [ColorName.red, ColorName.white, ColorName.red],
      [ColorName.red, ColorName.red, ColorName.white],
    ],
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

  void executaMovimento() {}
}
