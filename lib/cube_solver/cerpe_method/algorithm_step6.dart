import 'package:rubik_cube/cube_solver/cerpe_method/algorithm_step.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

class FaceAndMovementList {
  Face face;
  List<Movement> movementList;
  FaceAndMovementList(this.face, this.movementList);
}

class AlgorithmStep6 implements AlgorithmStep {

  static List<FaceMovementLog> sune = <FaceMovementLog>[
    FaceMovementLog(Face.front, Movement.r),
    FaceMovementLog(Face.front, Movement.u),
    FaceMovementLog(Face.front, Movement.r_),
    FaceMovementLog(Face.front, Movement.u),
    FaceMovementLog(Face.front, Movement.r),
    FaceMovementLog(Face.front, Movement.u2),
    FaceMovementLog(Face.front, Movement.r_),
  ];

  static List<FaceMovementLog> getSuneToReferenceFace(Face refFace) {
    List<FaceMovementLog> faceMovementLogList = <FaceMovementLog> [
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[refFace]![Movement.r]!),
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[refFace]![Movement.u]!),
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[refFace]![Movement.r_]!),
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[refFace]![Movement.u]!),
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[refFace]![Movement.r]!),
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[refFace]![Movement.u2]!),
      FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[refFace]![Movement.r_]!),
    ];
    return faceMovementLogList;
  }

  @override
  AlgorithmStepResult runStep() {
    var result = AlgorithmStepResult(true, <FaceMovementLog>[]);
    while (!checkTopFaceFullYellow()) {
      // RubikCube.printCube(); //////////////////////////////////////////////////////////// debug
      var face = checkCondition1(result);
      if (face != Face.none) {
        List<FaceMovementLog> sune = <FaceMovementLog>[];
        sune.addAll(getSuneToReferenceFace(Face.front));
        result.logList.addAll(sune);
        for (var log in sune) {
          RubikSolverMovement.doMovement(Face.front, log.movement);
        }
        // RubikCube.printCube(); //////////////////////////////////////////////////////////// debug
      } else {
        face = checkCondition2(result);
        if (face != Face.none) {
          List<FaceMovementLog> sune = <FaceMovementLog>[];
          sune.addAll(getSuneToReferenceFace(face));
          result.logList.addAll(sune);
          for (var log in sune) {
            RubikSolverMovement.doMovement(Face.front, log.movement);
          }
          var mov = FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[face]![Movement.u]!);
          result.logList.add(mov);
          RubikSolverMovement.doMovement(Face.front, mov.movement);
          // RubikCube.printCube(); //////////////////////////////////////////////////////////// debug
        } else {
          face = checkCondition3(result);
          if (face != Face.none) {
            List<FaceMovementLog> sune = <FaceMovementLog>[];
            sune.addAll(getSuneToReferenceFace(face));
            result.logList.addAll(sune);
            for (var log in sune) {
              RubikSolverMovement.doMovement(Face.front, log.movement);
            }
            var mov = FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[face]![Movement.u_]!);
            result.logList.add(mov);
            RubikSolverMovement.doMovement(Face.front, mov.movement);

            // RubikCube.printCube(); //////////////////////////////////////////////////////////// debug
          } else {
            face = checkCondition4(result);
            if (face != Face.none) {
              List<FaceMovementLog> sune = <FaceMovementLog>[];
              sune.addAll(getSuneToReferenceFace(face));
              result.logList.addAll(sune);
              for (var log in sune) {
                RubikSolverMovement.doMovement(Face.front, log.movement);
              }

              // RubikCube.printCube(); //////////////////////////////////////////////////////////// debug
            } else {
              face = checkCondition5(result);
              if (face != Face.none) {
                List<FaceMovementLog> sune = <FaceMovementLog>[];
                sune.addAll(getSuneToReferenceFace(face));
                result.logList.addAll(sune);
                for (var log in sune) {
                  RubikSolverMovement.doMovement(Face.front, log.movement);
                  // RubikCube.printCube();
                }
                var mov = FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[face]![Movement.u_]!);
                result.logList.add(mov);
                RubikSolverMovement.doMovement(Face.front, mov.movement);

                // RubikCube.printCube(); //////////////////////////////////////////////////////////// debug
              } else {
                face = checkCondition6(result);
                if (face != Face.none) {
                  List<FaceMovementLog> sune = <FaceMovementLog>[];
                  sune.addAll(getSuneToReferenceFace(face));
                  result.logList.addAll(sune);
                  for (var log in sune) {
                    RubikSolverMovement.doMovement(Face.front, log.movement);
                  }
                  var mov = FaceMovementLog(Face.front, RubikCube.mapFaceAndMovementToReferToFront[face]![Movement.u2]!);
                  result.logList.add(mov);
                  RubikSolverMovement.doMovement(Face.front, mov.movement);

                  // RubikCube.printCube(); //////////////////////////////////////////////////////////// debug
                } else {
                  face = checkCondition7(result);
                  if (face != Face.none) {
                    List<FaceMovementLog> sune = <FaceMovementLog>[];
                    sune.addAll(getSuneToReferenceFace(face));
                    result.logList.addAll(sune);
                    for (var log in sune) {
                      RubikSolverMovement.doMovement(Face.front, log.movement);
                    }
                    // RubikCube.printCube(); //////////////////////////////////////////////////////////// debug
                  }
                }
              }
            }
          }
        }
      }
    }
    return result;
  }

  bool checkTopFaceFullYellow() {
    for (var row = 0; row < 3; ++row) {
      for (var column = 0; column < 3; ++column) {
        var color = RubikCube.getColorName(Face.top, row, column);
        if (color != ColorName.yellow) {
          return false;
        }
      }
    }
    return true;
  }

  FaceAndMovementList getFaceAndMovementList(List<FaceMovementLog> movementList) {
    if (movementList.length == 1) {
      return FaceAndMovementList(Face.front, <Movement>[Movement.u]);
    } if (movementList.length == 2) {
      return FaceAndMovementList(Face.front, <Movement>[Movement.u2]);
    } if (movementList.length == 3) {
      return FaceAndMovementList(Face.front, <Movement>[Movement.u_]);
    } if (movementList.length == 4) {
      return FaceAndMovementList(Face.front, <Movement>[]);
    }
    return FaceAndMovementList(Face.none, []);
  }
  
  Face checkCondition1(AlgorithmStepResult result) {
    List<FaceMovementLog> movementList = <FaceMovementLog>[];
    var topYellowCoordinates = <Coords>[
      (row: 0, column: 0),
      (row: 0, column: 1),
      (row: 1, column: 0),
      (row: 1, column: 1),
      (row: 1, column: 2),
      (row: 2, column: 1),
      (row: 2, column: 2),
    ];
    var mapFaceToYellowCoordinatesList = <Face, List<Coords>>{
      Face.front: [(row: 0, column: 0)],
      Face.right: [(row: 0, column: 2)],
    };

    bool check0 = false, check1 = false, check2 = false;
    for (var count = 1; count <= 3; ++count) {
      for (var coords in topYellowCoordinates) {
        check0 = RubikCube.getColorName(Face.top, coords.row, coords.column) == ColorName.yellow;
        if (!check0) {
          break;
        }
      }
      if (check0) {
        var coordsList1 = mapFaceToYellowCoordinatesList[Face.front]!;
        for (var coords1 in coordsList1) {
          check1 = (RubikCube.getColorName(Face.front, coords1.row, coords1.column) != ColorName.yellow);
          if (!check1) {
            continue;
          }
        }
        if (check1) {
          var coordsList2 = mapFaceToYellowCoordinatesList[Face.right]!;
          for (var coords2 in coordsList2) {
            check2 = (RubikCube.getColorName(Face.right, coords2.row, coords2.column) == ColorName.yellow);
            if (check1 && check2) {
              return Face.front;
            }
          }
        }
      }
      // rotate top face
      movementList.add(FaceMovementLog(Face.front, Movement.u));
      RubikSolverMovement.doMovement(Face.front, Movement.u);
      result.logList.add(FaceMovementLog(Face.front, Movement.u));
    }
    return Face.none;
  }

  // for (LateralFace face in LateralFace.values) {
  //   var coordsMatrix = RubikCube.mapFaceToTopCoordsMatrix[face]!;
  //   labelOuterMatrixLoop:
  //   for (var row = 0; row < 3; ++row) {
  //     for (var col = 0; col < 3; ++col) {
  //       var coords = coordsMatrix[row][col];
  //       if ((coords.row == 0 && coords.column == 2) || (coords.row == 2 && coords.column == 0)) {
  //         continue;
  //       }
  //       if (RubikCube.getColorName(Face.top, coords.row, coords.column) != ColorName.yellow) {
  //         break labelOuterMatrixLoop;
  //       }
  //     }
  //   }
  //   if (RubikCube.getColorName(face.faceValue, 0, 0) != ColorName.yellow) {
  //     continue;
  //   }
  //   var neighbour = RubikCube.getNeighbourFace(face.faceValue, FaceDirection.right);
  //   if (RubikCube.getColorName(neighbour, 0, 2) != ColorName.yellow) {
  //     continue;
  //   }
  //   return face.faceValue;
  // }
  // return Face.none;

  Face checkCondition2(AlgorithmStepResult result) {
    List<FaceMovementLog> movementList = <FaceMovementLog>[];
    var topYellowCoordinates = <Coords>[
      (row: 0, column: 1),
      (row: 0, column: 2),
      (row: 1, column: 0),
      (row: 1, column: 1),
      (row: 1, column: 2),
      (row: 2, column: 1),
      (row: 2, column: 2),
    ];
    var mapFaceToYellowCoordinatesList = <Face, List<Coords>>{
      Face.front: [(row: 0, column: 0)],
    };

    bool check0 = false, check1 = false;
    for (var count = 1; count <= 3; ++count) {
      for (var coords in topYellowCoordinates) {
        check0 = RubikCube.getColorName(Face.top, coords.row, coords.column) == ColorName.yellow;
        if (!check0) {
          break;
        }
      }
      if (check0) {
        var coordsList1 = mapFaceToYellowCoordinatesList[Face.front]!;
        for (var coords1 in coordsList1) {
          check1 = RubikCube.getColorName(Face.front, coords1.row, coords1.column) == ColorName.yellow;
          if (check1) {
            return Face.front;
          }
        }
      }
      // rotate top face
      movementList.add(FaceMovementLog(Face.front, Movement.u));
      RubikSolverMovement.doMovement(Face.front, Movement.u);
      result.logList.add(FaceMovementLog(Face.front, Movement.u));
    }
    return Face.none;
  }
    // for (LateralFace face in LateralFace.values) {
    //   var coordsMatrix = RubikCube.mapFaceToTopCoordsMatrix[face]!;
    //   labelOuterMatrixLoop:
    //   for (var row = 0; row < 3; ++row) {
    //     for (var col = 0; col < 3; ++col) {
    //       var coords = coordsMatrix[row][col];
    //       if ((coords.row == 0 && coords.column == 0) || (coords.row == 2 && coords.column == 0)) {
    //         continue;
    //       }
    //       if (RubikCube.getColorName(Face.top, coords.row, coords.column) != ColorName.yellow) {
    //         break labelOuterMatrixLoop;
    //       }
    //     }
    //   }
    //   if (RubikCube.getColorName(face.faceValue, 0, 0) != ColorName.yellow) {
    //     continue;
    //   }
    //   return face.faceValue;
    // }
    // return Face.none;

  Face checkCondition3(AlgorithmStepResult result) {
    List<FaceMovementLog> movementList = <FaceMovementLog>[];
    var topYellowCoordinates = <Coords>[
      (row: 0, column: 0),
      (row: 0, column: 1),
      (row: 0, column: 2),
      (row: 1, column: 0),
      (row: 1, column: 1),
      (row: 1, column: 2),
      (row: 2, column: 1),
    ];
    var mapFaceToYellowCoordinatesList = <Face, List<Coords>>{
      Face.front: [
        (row: 0, column: 0),
        (row: 0, column: 2)
      ],
    };

    bool check0 = false, check1 = false;
    for (var count = 1; count <= 3; ++count) {
      for (var coords in topYellowCoordinates) {
        check0 = RubikCube.getColorName(Face.top, coords.row, coords.column) == ColorName.yellow;
        if (!check0) {
          break;
        }
      }
      if (check0) {
        var coordsList1 = mapFaceToYellowCoordinatesList[Face.front]!;
        check1 = true;
        for (var coords1 in coordsList1) {
          check1 = check1 && RubikCube.getColorName(Face.front, coords1.row, coords1.column) == ColorName.yellow;
          if (!check1) {
            break;
          }
        }
        if (check1) {
          return Face.front;
        }
      }
      // rotate top face
      movementList.add(FaceMovementLog(Face.front, Movement.u));
      RubikSolverMovement.doMovement(Face.front, Movement.u);
      result.logList.add(FaceMovementLog(Face.front, Movement.u));
    }
    return Face.none;
  }
    // for (LateralFace face in LateralFace.values) {
    //   var coordsMatrix = RubikCube.mapFaceToTopCoordsMatrix[face]!;
    //   labelOuterMatrixLoop:
    //   for (var row = 0; row < 3; ++row) {
    //     for (var col = 0; col < 3; ++col) {
    //       var coords = coordsMatrix[row][col];
    //       if (coords.row == 2 && coords.column == 0 || coords.row == 2 && coords.column == 2) {
    //         continue;
    //       }
    //       if (RubikCube.getColorName(Face.top, coords.row, coords.column) != ColorName.yellow) {
    //         break labelOuterMatrixLoop;
    //       }
    //     }
    //   }
    //   if (RubikCube.getColorName(face.faceValue, 0, 0) != ColorName.yellow || RubikCube.getColorName(face.faceValue, 0, 2) != ColorName.yellow) {
    //     continue;
    //   }
    //   return face.faceValue;
    // }
    // return Face.none;

  Face checkCondition4(AlgorithmStepResult result) {
    List<FaceMovementLog> movementList = <FaceMovementLog>[];
    var topYellowCoordinates = <Coords>[
      (row: 0, column: 1),
      (row: 1, column: 0),
      (row: 1, column: 1),
      (row: 1, column: 2),
      (row: 2, column: 1),
    ];
    var mapFaceToYellowCoordinatesList = <Face, List<Coords>>{
      Face.right: [(row: 0, column: 0), (row: 0, column: 2)],
    };

    bool check0 = false, check1 = false;
    for (var count = 1; count <= 3; ++count) {
      for (var coords in topYellowCoordinates) {
        check0 = RubikCube.getColorName(Face.top, coords.row, coords.column) == ColorName.yellow;
        if (!check0) {
          break;
        }
      }
      if (check0) {
        var coordsList1 = mapFaceToYellowCoordinatesList[Face.right]!;
        for (var coords1 in coordsList1) {
          check1 = RubikCube.getColorName(Face.right, coords1.row, coords1.column) == ColorName.yellow;
          if (!check1) {
            break;
          }
        }
        if (check1) {
          return Face.front;
        }
      }
      // rotate top face
      movementList.add(FaceMovementLog(Face.front, Movement.u));
      RubikSolverMovement.doMovement(Face.front, Movement.u);
      result.logList.add(FaceMovementLog(Face.front, Movement.u));
    }
    return Face.none;
  }
    // for (LateralFace face in LateralFace.values) {
    //   var coordsMatrix = RubikCube.mapFaceToTopCoordsMatrix[face]!;
    //   labelOuterMatrixLoop:
    //   for (var row = 0; row < 3; ++row) {
    //     for (var col = 0; col < 3; ++col) {
    //       var coords = coordsMatrix[row][col];
    //       if (coords.row == 2 && coords.column == 0 || coords.row == 2 && coords.column == 2 ||
    //           coords.row == 0 && coords.column == 0 || coords.row == 0 && coords.column == 2) {
    //         continue;
    //       }
    //       if (RubikCube.getColorName(Face.top, coords.row, coords.column) != ColorName.yellow) {
    //         break labelOuterMatrixLoop;
    //       }
    //     }
    //   }
    //   var neighbour = RubikCube.getNeighbourFace(face.faceValue, FaceDirection.right);
    //   if (RubikCube.getColorName(neighbour, 0, 0) != ColorName.yellow || RubikCube.getColorName(neighbour, 0, 2) != ColorName.yellow) {
    //     continue;
    //   }
    //   return face.faceValue;
    // }
    // return Face.none;

  Face checkCondition5(AlgorithmStepResult result) {
    List<FaceMovementLog> movementList = <FaceMovementLog>[];
    var topYellowCoordinates = <Coords>[
      (row: 0, column: 1),
      (row: 1, column: 0),
      (row: 1, column: 1),
      (row: 1, column: 2),
      (row: 2, column: 1),
    ];
    var mapFaceToYellowCoordinatesList = <Face, List<Coords>>{
      Face.front: [(row: 0, column: 2)],
    };

    bool check0 = true, check1 = true;
    for (var count = 1; count <= 3; ++count) {
      for (var coords in topYellowCoordinates) {
        check0 = check0 && RubikCube.getColorName(Face.top, coords.row, coords.column) == ColorName.yellow;
        if (!check0) {
          break;
        }
      }
      if (check0) {
        var coordsList1 = mapFaceToYellowCoordinatesList[Face.front]!;
        for (var coords1 in coordsList1) {
          check1 = check1 && (RubikCube.getColorName(Face.front, coords1.row, coords1.column) != ColorName.yellow);
        }
        if (check1) {
          return Face.front;
        }
      }
      // rotate top face
      movementList.add(FaceMovementLog(Face.front, Movement.u));
      RubikSolverMovement.doMovement(Face.front, Movement.u);
      result.logList.add(FaceMovementLog(Face.front, Movement.u));
    }
    return Face.none;
  }
    // for (LateralFace face in LateralFace.values) {
    //   var coordsMatrix = RubikCube.mapFaceToTopCoordsMatrix[face]!;
    //   labelOuterMatrixLoop:
    //   for (var row = 0; row < 3; ++row) {
    //     for (var col = 0; col < 3; ++col) {
    //       var coords = coordsMatrix[row][col];
    //       if (coords.row == 2 && coords.column == 0 || coords.row == 2 && coords.column == 2 ||
    //           coords.row == 0 && coords.column == 0 || coords.row == 0 && coords.column == 2) {
    //         continue;
    //       }
    //       if (RubikCube.getColorName(Face.top, coords.row, coords.column) != ColorName.yellow) {
    //         break labelOuterMatrixLoop;
    //       }
    //     }
    //   }
    //   if (RubikCube.getColorName(face.faceValue, 0, 2) != ColorName.yellow) {
    //     continue;
    //   }
    //   return face.faceValue;
    // }
    // return Face.none;


  Face checkCondition6(AlgorithmStepResult result) {
    List<FaceMovementLog> movementList = <FaceMovementLog>[];
    var topYellowCoordinates = <Coords>[
      (row: 0, column: 1),
      (row: 1, column: 0),
      (row: 1, column: 1),
      (row: 1, column: 2),
      (row: 2, column: 0),
      (row: 2, column: 1),
    ];
    var mapFaceToYellowCoordinatesList = <Face, List<Coords>>{
      Face.right: [(row: 0, column: 0)],
    };

    bool check0 = true, check1 = true;
    for (var count = 1; count <= 3; ++count) {
      for (var coords in topYellowCoordinates) {
        check0 = check0 && RubikCube.getColorName(Face.top, coords.row, coords.column) ==
            ColorName.yellow;
        if (!check0) {
          break;
        }
      }
      if (check0) {
        var coordsList1 = mapFaceToYellowCoordinatesList[Face.right]!;
        for (var coords1 in coordsList1) {
          check1 = check1 &&
          (RubikCube.getColorName(Face.right, coords1.row, coords1.column) !=
              ColorName.yellow);
          if (!check1) {
            break;
          }
        }
        if (check1) {
          return Face.front;
        }
      }
      // rotate top face
      movementList.add(FaceMovementLog(Face.front, Movement.u));
      RubikSolverMovement.doMovement(Face.front, Movement.u);
      result.logList.add(FaceMovementLog(Face.front, Movement.u));
    }
    return Face.none;
  }
    // for (LateralFace face in LateralFace.values) {
    //   var coordsMatrix = RubikCube.mapFaceToTopCoordsMatrix[face]!;
    //   labelOuterMatrixLoop:
    //   for (var row = 0; row < 3; ++row) {
    //     for (var col = 0; col < 3; ++col) {
    //       var coords = coordsMatrix[row][col];
    //       if (coords.row == 2 && coords.column == 2 || coords.row == 0 && coords.column == 0 ||
    //           coords.row == 0 && coords.column == 2) {
    //         continue;
    //       }
    //       if (RubikCube.getColorName(Face.top, coords.row, coords.column) != ColorName.yellow) {
    //         break labelOuterMatrixLoop;
    //       }
    //     }
    //   }
    //   var neighbour = RubikCube.getNeighbourFace(face.faceValue, FaceDirection.right);
    //   if (RubikCube.getColorName(neighbour, 0, 0) != ColorName.yellow) {
    //     continue;
    //   }
    //   return face.faceValue;
    // }
    // return Face.none;

  
  Face checkCondition7(AlgorithmStepResult result) {
    List<FaceMovementLog> movementList = <FaceMovementLog>[];
    var topYellowCoordinates = <Coords>[
      (row: 0, column: 1),
      (row: 1, column: 0),
      (row: 1, column: 1),
      (row: 1, column: 2),
      (row: 2, column: 0),
      (row: 2, column: 1),
    ];
    var mapFaceToYellowCoordinatesList = <Face, List<Coords>>{
      Face.front: [(row: 0, column: 2)],
      Face.right: [(row: 0, column: 2)],
    };

    bool check0 = true, check1 = true, check2 = true;
    for (var count = 1; count <= 3; ++count) {
      for (var coords in topYellowCoordinates) {
        check0 = check0 && RubikCube.getColorName(Face.top, coords.row, coords.column) ==
            ColorName.yellow;
        if (!check0) {
          break;
        }
      }
      if (check0) {
        var coordsList1 = mapFaceToYellowCoordinatesList[Face.front]!;
        for (var coords1 in coordsList1) {
          check1 = check1 &&
          RubikCube.getColorName(Face.front, coords1.row, coords1.column) !=
              ColorName.yellow;
          if (!check1) {
            break;
          }
        }
        if (check1) {
          var coordsList2 = mapFaceToYellowCoordinatesList[Face.right]!;
          for (var coords2 in coordsList2) {
            check2 = check2 &&
            RubikCube.getColorName(Face.right, coords2.row, coords2.column) !=
                ColorName.yellow;
          }
          if (check2) {
            return Face.front;
          }
        }
      }
      movementList.add(FaceMovementLog(Face.front, Movement.u));
      RubikSolverMovement.doMovement(Face.front, Movement.u);
      result.logList.add(FaceMovementLog(Face.front, Movement.u));
    }
    return Face.none;
  }
    // for (LateralFace face in LateralFace.values) {
    //   var coordsMatrix = RubikCube.mapFaceToTopCoordsMatrix[face]!;
    //   labelOuterMatrixLoop:
    //   for (var row = 0; row < 3; ++row) {
    //     for (var col = 0; col < 3; ++col) {
    //       var coords = coordsMatrix[row][col];
    //       if (coords.row == 2 && coords.column == 2 || coords.row == 0 && coords.column == 0 ||
    //           coords.row == 0 && coords.column == 2) {
    //         continue;
    //       }
    //       if (RubikCube.getColorName(Face.top, coords.row, coords.column) != ColorName.yellow) {
    //         break labelOuterMatrixLoop;
    //       }
    //     }
    //   }
    //   if (RubikCube.getColorName(face.faceValue, 0, 2) != ColorName.yellow) {
    //     continue;
    //   }
    //   var neighbour = RubikCube.getNeighbourFace(face.faceValue, FaceDirection.right);
    //   if (RubikCube.getColorName(neighbour, 0, 2) != ColorName.yellow) {
    //     continue;
    //   }
    //   return face.faceValue;
    // }
    // return Face.none;

}