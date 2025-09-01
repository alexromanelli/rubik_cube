import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';

class AlgorithmStepResult {
  bool success;
  List<FaceMovementLog> logList;

  AlgorithmStepResult(this.success, this.logList);

  /// This is a really naïve approach.
  int logListAbreviation() {
    int numberOfRemovedMoves = 0;
    var newLogList = <FaceMovementLog>[];
    int index = 0;
    while (index < logList.length - 1) {

      for (int lookahead = 3; lookahead > 0; --lookahead) {
        var subsequence = logList.sublist(index, index + lookahead);
        switch (lookahead) {
          case 4: ;
          case 3: ;
          case 2: ;
          case 1: ;
        }

        // if lookahead is 3 (subsequence length is 4) and all subsequence's elements are identical, do
        // not add these movements into the new list, because the result cube's state is
        // equal to the inicial state. Removed moves counting must be incremented
        // by 4.

        // if lookahead is 2 (subsequence length is 3) and all movements are identical, add to the new list
        // the opposite move (let M be any movement and "->" indicates the opposite,
        // then M -> M' and M' -> M). Removed counting is incremented by 2.

        // if lookahead is 1 and all
      }

    }
    for (int index = 0; index < logList.length - 1; ++index) {
      for (int lookahead = 4; lookahead >= 0; --lookahead) {
        var subsequence = logList.sublist(index, index + lookahead);
        // if all subsequence's elements are identical, do not add these
        // movements into the new list, because the result cube's state is
        // equal to the inicial state.

        // if lookahead is 3 and all movements are identical, add to
      }
    }
    return numberOfRemovedMoves;
  }
}

interface class SolverAlgorithm {
  CubeSolverSolution? solveCubeInstance() {
    return null;
  }

  void returnToInitialState() {}
}
