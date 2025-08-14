import 'package:rubik_cube/cube_plotter/drawing_constants.dart';

class RubikCube {
  static final Map<Face, List<List<ColorName>>> mapFaceToColorNameMatrix = <Face, List<List<ColorName>>>{
    Face.front: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.blue, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.right: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.red, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.left: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.orange, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.back: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.green, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.top: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.yellow, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.bottom: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.white, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
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
