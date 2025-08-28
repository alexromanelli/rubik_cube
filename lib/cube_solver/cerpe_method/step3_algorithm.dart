// import 'package:rubik_cube/cube_solver/cerpe_method/step_algorithm.dart';
// import 'package:rubik_cube/cube_solver/rubik_solver_algorithm.dart';
// import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
// import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
// import 'package:rubik_cube/rubik_cube.dart';
//
// enum CornerRelativeSide { left, right, down, up }
//
// class CornerItem {
//   ColorName color;
//   late Face currentFace;
//   late Coords currentCoords;
//
//   CornerItem(this.color);
//
//   void setCurrentFace(Face face) {
//     currentFace = face;
//   }
//
//   void setCurrentCoords(Coords coords) {
//     currentCoords = coords;
//   }
// }
//
// enum CornerSide { upRight, upLeft, downRight, downLeft }
//
// class FaceAndCornerSide {
//   Face face;
//   CornerSide cornerSide;
//
//   FaceAndCornerSide(this.face, this.cornerSide);
//
//   @override
//   bool operator ==(Object other) {
//     if (face == (other as FaceAndCornerSide).face && cornerSide == other.cornerSide) {
//       return true;
//     }
//     return false;
//   }
// }
//
// class Corner {
//   static Map<FaceAndCornerSide, List<Face>> cornerFace = <FaceAndCornerSide, List<Face>>{
//     FaceAndCornerSide(Face.front, CornerSide.downRight): <Face>[Face.front, Face.right, Face.bottom],
//     FaceAndCornerSide(Face.front, CornerSide.downLeft): <Face>[Face.front, Face.left, Face.bottom],
//     FaceAndCornerSide(Face.front, CornerSide.upRight): <Face>[Face.front, Face.right, Face.top],
//     FaceAndCornerSide(Face.front, CornerSide.upLeft): <Face>[Face.front, Face.left, Face.top],
//
//     FaceAndCornerSide(Face.top, CornerSide.downRight): <Face>[Face.top, Face.right, Face.front],
//     FaceAndCornerSide(Face.top, CornerSide.downLeft): <Face>[Face.top, Face.left, Face.front],
//     FaceAndCornerSide(Face.top, CornerSide.upRight): <Face>[Face.top, Face.right, Face.back],
//     FaceAndCornerSide(Face.top, CornerSide.upLeft): <Face>[Face.top, Face.left, Face.back],
//
//     FaceAndCornerSide(Face.back, CornerSide.downRight): <Face>[Face.back, Face.left, Face.bottom],
//     FaceAndCornerSide(Face.back, CornerSide.downLeft): <Face>[Face.back, Face.right, Face.bottom],
//     FaceAndCornerSide(Face.back, CornerSide.upRight): <Face>[Face.back, Face.left, Face.top],
//     FaceAndCornerSide(Face.back, CornerSide.upLeft): <Face>[Face.back, Face.right, Face.top],
//
//     FaceAndCornerSide(Face.right, CornerSide.downRight): <Face>[Face.right, Face.back, Face.bottom],
//     FaceAndCornerSide(Face.right, CornerSide.downLeft): <Face>[Face.right, Face.front, Face.bottom],
//     FaceAndCornerSide(Face.right, CornerSide.upRight): <Face>[Face.right, Face.back, Face.top],
//     FaceAndCornerSide(Face.right, CornerSide.upLeft): <Face>[Face.right, Face.front, Face.top],
//
//     FaceAndCornerSide(Face.left, CornerSide.downRight): <Face>[Face.left, Face.front, Face.bottom],
//     FaceAndCornerSide(Face.left, CornerSide.downLeft): <Face>[Face.left, Face.back, Face.bottom],
//     FaceAndCornerSide(Face.left, CornerSide.upRight): <Face>[Face.left, Face.front, Face.top],
//     FaceAndCornerSide(Face.left, CornerSide.upLeft): <Face>[Face.left, Face.back, Face.top],
//
//     FaceAndCornerSide(Face.bottom, CornerSide.downRight): <Face>[Face.bottom, Face.right, Face.back],
//     FaceAndCornerSide(Face.bottom, CornerSide.downLeft): <Face>[Face.bottom, Face.left, Face.back],
//     FaceAndCornerSide(Face.bottom, CornerSide.upRight): <Face>[Face.bottom, Face.right, Face.front],
//     FaceAndCornerSide(Face.bottom, CornerSide.upLeft): <Face>[Face.bottom, Face.left, Face.front],
//   };
//
//   static Map<CornerSide, Coords> mapCornerSideToCoords = <CornerSide, Coords>{
//     CornerSide.upLeft: (row: 0, column: 0),
//     CornerSide.upRight: (row: 0, column: 2),
//     CornerSide.downLeft: (row: 2, column: 0),
//     CornerSide.downRight: (row: 2, column: 2),
//   };
//
//   static List<Face> faceOfInterest = <Face>[Face.front, Face.right, Face.back, Face.left, Face.bottom];
//
//   static Map<Face, Map<CornerRelativeSide, Face>> mapFaceToMapSideToFace = <Face, Map<CornerRelativeSide, Face>>{
//     Face.front: <CornerRelativeSide, Face>{
//       CornerRelativeSide.left: Face.left,
//       CornerRelativeSide.right: Face.right,
//       CornerRelativeSide.top: Face.top,
//     },
//     Face.back: <CornerRelativeSide, Face>{
//       CornerRelativeSide.left: Face.right,
//       CornerRelativeSide.right: Face.left,
//       CornerRelativeSide.top: Face.top,
//     },
//     Face.left: <CornerRelativeSide, Face>{
//       CornerRelativeSide.left: Face.back,
//       CornerRelativeSide.right: Face.front,
//       CornerRelativeSide.top: Face.top,
//     },
//     Face.right: <CornerRelativeSide, Face>{
//       CornerRelativeSide.left: Face.front,
//       CornerRelativeSide.right: Face.back,
//       CornerRelativeSide.top: Face.top,
//     },
//   };
//
//   static Map<Face, Map<CornerSide, FaceAndCornerSide>> mapCornerWhiteFaceAndSideToRelativeFrontFaceAndSide =
//       <Face, Map<CornerSide, FaceAndCornerSide>>{
//         Face.front: <CornerSide, FaceAndCornerSide>{
//           CornerSide.upLeft: FaceAndCornerSide(Face.left, CornerSide.upRight),
//           CornerSide.upRight: FaceAndCornerSide(Face.right, CornerSide.upLeft),
//           CornerSide.downLeft: FaceAndCornerSide(Face.left, CornerSide.downRight),
//           CornerSide.downRight: FaceAndCornerSide(Face.right, CornerSide.downLeft),
//         },
//         Face.right: <CornerSide, FaceAndCornerSide>{
//           CornerSide.upLeft: FaceAndCornerSide(Face.front, CornerSide.upRight),
//           CornerSide.upRight: FaceAndCornerSide(Face.back, CornerSide.upLeft),
//           CornerSide.downLeft: FaceAndCornerSide(Face.front, CornerSide.downRight),
//           CornerSide.downRight: FaceAndCornerSide(Face.back, CornerSide.downLeft),
//         },
//         Face.back: <CornerSide, FaceAndCornerSide>{
//           CornerSide.upLeft: FaceAndCornerSide(Face.right, CornerSide.upRight),
//           CornerSide.upRight: FaceAndCornerSide(Face.left, CornerSide.upLeft),
//           CornerSide.downLeft: FaceAndCornerSide(Face.right, CornerSide.downRight),
//           CornerSide.downRight: FaceAndCornerSide(Face.left, CornerSide.downLeft),
//         },
//         Face.left: <CornerSide, FaceAndCornerSide>{
//           CornerSide.upLeft: FaceAndCornerSide(Face.back, CornerSide.upRight),
//           CornerSide.upRight: FaceAndCornerSide(Face.front, CornerSide.upLeft),
//           CornerSide.downLeft: FaceAndCornerSide(Face.back, CornerSide.downRight),
//           CornerSide.downRight: FaceAndCornerSide(Face.front, CornerSide.downLeft),
//         },
//         Face.top: <CornerSide, FaceAndCornerSide>{
//           CornerSide.upLeft: FaceAndCornerSide(Face.back, CornerSide.upRight),
//           CornerSide.upRight: FaceAndCornerSide(Face.right, CornerSide.upRight),
//           CornerSide.downLeft: FaceAndCornerSide(Face.left, CornerSide.upRight),
//           CornerSide.downRight: FaceAndCornerSide(Face.front, CornerSide.upRight),
//         },
//       };
//
//   void createCornerPieceListByFaceAndCornerSide(FaceAndCornerSide faceAndCornerSide0) {
//
//     var color0 = RubikCube.mapFaceToColorName[faceAndCornerSide0.face];
//     var currentFace0 = faceAndCornerSide0.face;
//     var currentSide0 = faceAndCornerSide0.cornerSide;
//     var cornerPiece = CornerPiece(color0, relativeSide, currentFaceAndCornerSide)
//   }
//
//   final Map<CornerRelativeSide, CornerPiece> pieceMap = <CornerRelativeSide, CornerPiece>{
//     CornerRelativeSide.down: CornerPiece(ColorName.white, relativeSide, currentFaceAndCornerSide)
//   };
//   Corner() {
//     cornerSide = <CornerItem>[];
//   }
// }
//
// class CornerPiece {
//   static Map<CornerSide, Corner> mapCornerSideToWhiteCorner = <CornerSide, Corner>{
//     CornerSide.upLeft:
//   };
//   /// The color of this piece.s
//   ColorName color;
//
//   /// The pieceSide can be left or right, according to the division between faces, when the white piece is at its correct place.
//   /// If the white side is on the bottom, the other two sides is to the left and to the right.
//   CornerRelativeSide relativeSide;
//
//   FaceAndCornerSide currentFaceAndCornerSide;
//
//   CornerPiece(this.color, this.relativeSide, this.currentFaceAndCornerSide);
//
//   void cornerWasMovedByU() {
//     if (currentFaceAndCornerSide.face == Face.top) {
//       currentFaceAndCornerSide.cornerSide = switch (currentFaceAndCornerSide.cornerSide) {
//         CornerSide.upRight => CornerSide.downRight,
//         CornerSide.upLeft => CornerSide.upRight,
//         CornerSide.downRight => CornerSide.downLeft,
//         CornerSide.downLeft => CornerSide.upLeft,
//       };
//     } else {
//       currentFaceAndCornerSide.face = RubikCube.getNeighbourFace(currentFaceAndCornerSide.face, FaceDirection.left);
//     }
//   }
// }
//
// class Step3Algorithm implements StepAlgorithm {
//   late List<Corner> cornerList;
//
//   Step3Algorithm() {
//     // cornerList.addAll(<Corner>[
//     //   Corner(<CornerItem>[CornerItem(), (), (), (), (), (), (), ()]),
//     // ]);
//   }
//
//   void getCornersData() {
//     // for (var face in Face.values) {
//     //   for (var row = 0; row < 3; ++row) {
//     //     for (var column = 0; column < 3; ++column) {
//     //       if ()
//     //     }
//     //   }
//     // }
//   }
//
//   @override
//   AlgorithmStepResult runStep() {
//     var step = <FaceMovementLog>[];
//     /*
//     // repetir até posicionar as quatro quinas brancas
//     // encontrar uma quina com um lado branco
//     // // se estiver com lado branco posicionado na base, nada a fazer
//     // // se estiver com outro lado encostado na base branca, fazer os movimentos B, U, B'
//     // // se não estiver encostado na base
//     //        executar o movimento U até que a quina esteja sobre o local onde deve ser posicionado,
//     //          ou seja, quando a quina está entre os lados que têm as cores dela
//     //        casos observados, descritos no livro "O segredo do cubo mágico em 8 passos", de Renan Cerpe
//     //          Quina branca na esquerda (como este algoritmo não descreve casos de quinas na frontal, trata-se de tomar
//     //                                    como a frente a face do lado da quina que não é o branco, que vou chamar
//     //                                    de frente relativa)
//     //            neste caso, executar os passos L', U', L, isso em relação à face com a frente relativa (não branca)
//     //              é preciso converter esses movimentos para ficarem em relação à frente azul
//     //          Quina branca na direita
//     // // // // Quina branca no topo
//     */
//
//     //  repeat until four white corners are positioned:
//     while (numOfPositionedCorners(RubikCube.mapColorNameToFace[ColorName.white]!) < 4) {
//       //    find a corner with a white side, and:
//       (Face face, CornerSide cornerSide)? faceAndCornerSide = findFirstWhiteCorner();
//       if (faceAndCornerSide == null) {
//         // ERROR detected
//         return AlgorithmStepResult(false, step);
//       }
//       //      if its white side is on the cube's white face
//       //        check if the corner's parts' current faces are the same around this corner
//       //          if the corner's parts' current faces' colors match the corner's colors
//       //            there is nothing to do
//       //          else, put this corner out of the white base
//       if (RubikCube.mapFaceToColorName[faceAndCornerSide.$1] == ColorName.white) {
//         continue;
//       }
//       //      if it is with some other side on the cube's white face, do these movements: R, U, R'
//       if (faceAndCornerSide.$2 == CornerSide.downLeft || faceAndCornerSide.$2 == CornerSide.downRight) {
//         var refFace = Corner
//             .mapCornerWhiteFaceAndSideToRelativeFrontFaceAndSide[faceAndCornerSide.$1]![faceAndCornerSide.$2]!
//             .face;
//         var movesToPutCornerOutOfBase = <FaceMovementLog>[
//           FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R]!),
//           FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.U]!),
//           FaceMovementLog(Face.front, mapFaceAndMovementToReferToFront[refFace]![Movement.R_]!),
//         ];
//         step.addAll(movesToPutCornerOutOfBase);
//         for (var faceMovementLog in movesToPutCornerOutOfBase) {
//           RubikSolverMovement.doMovement(faceMovementLog.referenceFace, faceMovementLog.movement);
//         }
//         continue;
//       }
//       //      if it is not touching the base:
//       //        do the movement U until this corner is above the place it should be, i.e., where the corner is between the
//       //          faces with the corner's colors
//       Face currentFace = faceAndCornerSide.$1;
//       CornerSide currentCornerSide = faceAndCornerSide.$2;
//       while (!cornerIsAboveCorrectPlace(currentFace, currentCornerSide)) {
//         step.add(FaceMovementLog(Face.front, Movement.U));
//         RubikSolverMovement.doMovement(Face.front, Movement.U);
//         currentFace = RubikCube.getNeighbourFace(currentFace, FaceDirection.left);
//         currentCornerSide = switch (currentCornerSide) {
//           // clockwise transitions
//           CornerSide.upRight => CornerSide.downRight,
//           CornerSide.upLeft => CornerSide.upRight,
//           CornerSide.downRight => CornerSide.downLeft,
//           CornerSide.downLeft => CornerSide.upLeft,
//         };
//       }
//       // faceAndCornerSide = (currentFace, currentCornerSide);
//       //        act according the observed cases, which are described in the Renan Cerpe's book "O segredo do cubo mágico em 8 passos"
//       var whiteCornerSide = getCornerWhiteSide(currentFace, currentCornerSide);
//       //          White corner to the left
//       //            do the movements L', U' and L, relative to tha corner's left side (they should be translated to be relative to the blue side)
//       //          White corner to the right
//       //          White corner to the top
//     }
//     return AlgorithmStepResult(true, FaceMovementLog.copyOf(step));
//   }
//
//   (Face, CornerSide)? findFirstWhiteCorner() {
//     for (var face in Corner.faceOfInterest) {
//       for (var cornerSide in CornerSide.values) {
//         var coords = Corner.mapCornerSideToCoords[cornerSide]!;
//         if (RubikCube.getColorName(face, coords.row, coords.column) == ColorName.white) {
//           return (face, cornerSide);
//         }
//       }
//     }
//     return null;
//   }
//
//   int numOfPositionedCorners(Face face) {
//     var color = RubikCube.mapFaceToColorName[face];
//     int count = 0;
//     for (int row = 0; row < 3; ++row) {
//       for (int column = 0; column < 3; ++column) {
//         if (RubikCube.getColorName(face, row, column) == color) {
//           ++count;
//         }
//       }
//     }
//     return count;
//   }
//
//   static Map<Face, Map<Movement, Movement>> mapFaceAndMovementToReferToFront = <Face, Map<Movement, Movement>>{
//     Face.right: <Movement, Movement>{
//       Movement.U: Movement.U,
//       Movement.U_: Movement.U_,
//       Movement.U2: Movement.U2,
//       Movement.B: Movement.L,
//       Movement.B_: Movement.L_,
//       Movement.B2: Movement.L2,
//       Movement.R: Movement.B,
//       Movement.R_: Movement.B_,
//       Movement.R2: Movement.B2,
//       Movement.L: Movement.F,
//       Movement.L_: Movement.F_,
//       Movement.L2: Movement.F2,
//       Movement.F: Movement.R,
//       Movement.F_: Movement.R_,
//       Movement.F2: Movement.R2,
//     },
//     Face.left: <Movement, Movement>{
//       Movement.U: Movement.U,
//       Movement.U_: Movement.U_,
//       Movement.U2: Movement.U2,
//       Movement.B: Movement.R,
//       Movement.B_: Movement.R_,
//       Movement.B2: Movement.R2,
//       Movement.R: Movement.F,
//       Movement.R_: Movement.F_,
//       Movement.R2: Movement.F2,
//       Movement.L: Movement.B,
//       Movement.L_: Movement.B_,
//       Movement.L2: Movement.B2,
//       Movement.F: Movement.L,
//       Movement.F_: Movement.L_,
//       Movement.F2: Movement.L2,
//     },
//     Face.back: <Movement, Movement>{
//       Movement.U: Movement.U,
//       Movement.U_: Movement.U_,
//       Movement.U2: Movement.U2,
//       Movement.B: Movement.F,
//       Movement.B_: Movement.F_,
//       Movement.B2: Movement.F2,
//       Movement.R: Movement.L,
//       Movement.R_: Movement.L_,
//       Movement.R2: Movement.L2,
//       Movement.L: Movement.R,
//       Movement.L_: Movement.R_,
//       Movement.L2: Movement.R2,
//       Movement.F: Movement.B,
//       Movement.F_: Movement.B_,
//       Movement.F2: Movement.B2,
//     },
//     Face.front: <Movement, Movement>{
//       Movement.U: Movement.U,
//       Movement.U_: Movement.U_,
//       Movement.U2: Movement.U2,
//       Movement.B: Movement.B,
//       Movement.B_: Movement.B_,
//       Movement.B2: Movement.B2,
//       Movement.R: Movement.R,
//       Movement.R_: Movement.R_,
//       Movement.R2: Movement.R2,
//       Movement.L: Movement.L,
//       Movement.L_: Movement.L_,
//       Movement.L2: Movement.L2,
//       Movement.F: Movement.F,
//       Movement.F_: Movement.F_,
//       Movement.F2: Movement.F2,
//     },
//   };
//
//   Movement translateFaceAndMovementToReferToFront(Face refFace, Movement movement) {
//     if (refFace == Face.top || refFace == Face.bottom) {
//       return movement;
//     }
//     Movement actualMove = mapFaceAndMovementToReferToFront[refFace]![movement]!;
//     return actualMove;
//   }
//
//   bool cornerIsAboveCorrectPlace(Face face, CornerSide cornerSide) {
//     FaceAndCornerSide faceAndCornerSide = FaceAndCornerSide(face, cornerSide);
//     var cornerFaceList = Corner.cornerFace[faceAndCornerSide]!;
//     var cornerCoords = Corner.mapCornerSideToCoords[cornerSide]!;
//     if (cornerFaceList.length != 3) {
//       return false;
//     }
//     var cornerColorList = <ColorName>[
//       RubikCube.getColorName(cornerFaceList[0], cornerCoords.row, cornerCoords.column),
//       RubikCube.getColorName(cornerFaceList[1], cornerCoords.row, cornerCoords.column),
//       RubikCube.getColorName(cornerFaceList[2], cornerCoords.row, cornerCoords.column),
//     ];
//     int sameColors = 0;
//     for (ColorName color in cornerColorList) {
//       if (color != ColorName.white) {
//         continue;
//       }
//       for (var cornerFace in cornerFaceList) {
//         ColorName faceColorName = RubikCube.mapFaceToColorName[cornerFace]!;
//         if (faceColorName == color) {
//           sameColors += 1;
//           break;
//         }
//       }
//     }
//     return sameColors == 2;
//   }
//
//   CornerSide getCornerWhiteSide(Face currentFace, CornerSide currentCornerSide) {
//     CornerSide side =
//         Corner.mapCornerWhiteFaceAndSideToRelativeFrontFaceAndSide[currentFace]![currentCornerSide]!.cornerSide;
//     return side;
//   }
// }
