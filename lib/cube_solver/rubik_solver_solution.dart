import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/rubik_cube.dart';

class FaceMovementLog {
  Face referenceFace;
  Movement movement;

  FaceMovementLog(this.referenceFace, this.movement);

  @override
  String toString() {
    var txt = RubikSolverMovement.movementToString(movement);
    return "$referenceFace $txt";
  }

  static List<FaceMovementLog> copyOf(List<FaceMovementLog> logs) {
    var copy = <FaceMovementLog>[];
    for (var log in logs) {
      var itemCopy = FaceMovementLog(log.referenceFace, log.movement);
      copy.add(itemCopy);
    }
    return copy;
  }
}

class CubeSolverSolution {
  Map<Face, List<List<ColorName>>> initialState = <Face, List<List<ColorName>>>{
    Face.front: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.back: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.right: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.left: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.top: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
    Face.bottom: [
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
      [ColorName.none, ColorName.none, ColorName.none],
    ],
  };

  // void setInitialState(Map<Face, List<List<ColorName>>> faceColor) {
  //   for (Face face in Face.values) {
  //     for (int r = 0; r < 3; ++r) {
  //       for (int c = 0; c < 3; ++c) {
  //         initialState[face]![r][c] = faceColor[face]![r][c];
  //       }
  //     }
  //   }
  // }

  List<FaceMovementLog> movementSequence = <FaceMovementLog>[];

  void addMovement(Face referenceFace, Movement movement) {
    var log = FaceMovementLog(referenceFace, movement);
    movementSequence.add(log);
  }

  void setInitialState() {
    initialState = RubikCube.copyOfMapFaceToColorNameMatrix();
    movementSequence.clear();
  }

  Future<bool> saveSolutionData() async {
    // TODO implement saveSolutionData to record the solution data into a Firebase instance
    return false;
  }

  void clear() {
    movementSequence.clear();
    setInitialState();
  }
}
