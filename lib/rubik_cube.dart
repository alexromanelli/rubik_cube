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

  static Face getNeighbourFace(Face referenceFace, ColorName color) {
    var direction = FaceDirection.up;
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
}
