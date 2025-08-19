import 'package:flutter/material.dart';
import 'package:rubik_cube/cube_plotter/drawing_constants.dart';
import 'package:rubik_cube/cube_reader/manual_reader/cube_reader.dart';
import 'package:rubik_cube/cube_reader/manual_reader/rubik_reader.dart';
import 'package:rubik_cube/cube_solver/cerpe-method/cerpe-solver-algorithm.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

import 'cube_plotter/rubik_cube_plotter.dart';

void main() {
  runApp(const RubikCubeSolverGUI());
}

class RubikCubeSolverGUI extends StatelessWidget {
  const RubikCubeSolverGUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rubik Cube Solver',
      // theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: StartView(),
    );
  }
}

/// The StartView class (and _StartViewState) are in charge to present a Rubik Cube
/// on screen, and to make available the moves that players do. A move should be
/// understood basically as a 90° rotation and is applied to one side of the cube.
/// There are always two moves on the same side, one move is clockwise and the other,
/// counterclockwise, relative to the center of the same side.
class StartView extends StatefulWidget {
  const StartView({super.key});

  @override
  State<StartView> createState() => _StartViewState();
}

class _StartViewState extends State<StartView> {
  late CarouselController carouselController;

  late DropdownMenu<String> dropdownColorMenu;

  late ColorName selectedFaceColor;
  late RotationSense selectedRotationSense;
  late Widget solutionRow;

  CubeSolverSolution? currentSolution;

  _StartViewState() {
    carouselController = CarouselController();
    selectedFaceColor = ColorName.none;
    selectedRotationSense = RotationSense.clockwise;
  }

  DropdownMenu<String> buildDropdownColorMenu() {
    return DropdownMenu<String>(
      width: 80,
      textStyle: TextStyle(
        fontSize: 15.0,
        backgroundColor: DrawingConstants.pieceColor[selectedFaceColor],
        color: DrawingConstants.pieceColor[selectedFaceColor],
      ),
      requestFocusOnTap: false,
      // menuHeight: 30.0,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DrawingConstants.pieceColor[selectedFaceColor],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),

      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
          WidgetState.focused: DrawingConstants.pieceColor[selectedFaceColor]!,
          WidgetState.hovered: DrawingConstants.pieceColor[selectedFaceColor]!,
          WidgetState.pressed: DrawingConstants.pieceColor[selectedFaceColor]!,
          WidgetState.any: DrawingConstants.pieceColor[selectedFaceColor]!,
        }),
      ),
      label: Text("", style: TextStyle(backgroundColor: DrawingConstants.pieceColor[selectedFaceColor])),
      onSelected: (value) {
        setState(() {
          selectFaceColor(value);
        });
      },
      dropdownMenuEntries: <DropdownMenuEntry<String>>[
        buildFaceSelectionMenuEntry("Azul", Colors.blue),
        buildFaceSelectionMenuEntry("Vermelho", Colors.red),
        buildFaceSelectionMenuEntry("Verde", Colors.green),
        buildFaceSelectionMenuEntry("Laranja", Colors.orange),
        buildFaceSelectionMenuEntry("Branco", Colors.white),
        buildFaceSelectionMenuEntry("Amarelo", Colors.yellow),
      ],
      initialSelection: "Vermelho",
    );
  }

  void refresh() {
    setState(() {});
  }

  void selectFaceColor(String? colorNameStr) {
    if (colorNameStr != null) {
      selectedFaceColor = CubeReaderState.colorNameMap[colorNameStr]!;
    }
  }

  void selectRotationSense(RotationSense? sense) {
    if (sense != null) {
      selectedRotationSense = sense;
    }
  }

  DropdownMenuEntry<String> buildFaceSelectionMenuEntry(String colorValue, Color buttonColor) {
    return DropdownMenuEntry(
      value: colorValue,
      label: "",
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Size>{WidgetState.any: Size.fromWidth(80.0)}),
        backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
          WidgetState.focused | WidgetState.pressed | WidgetState.hovered | WidgetState.any: buttonColor,
        }),
        shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
          WidgetState.focused | WidgetState.pressed | WidgetState.hovered | WidgetState.any: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
            side: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
          ),
        }),
      ),
    );
  }

  DropdownMenuEntry<RotationSense> buildRotationSelectionMenuEntry(RotationSense sense) {
    return DropdownMenuEntry(
      value: sense,
      label: switch (sense) {
        RotationSense.clockwise => "Sentido horário",
        RotationSense.counterclockwise => "Sentido anti-horário",
      },
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Size>{WidgetState.any: Size.fromWidth(230.0)}),
        // backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
        //   WidgetState.focused | WidgetState.pressed | WidgetState.hovered | WidgetState.any: Colors.white,
        // }),
        // shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
        //   WidgetState.focused | WidgetState.pressed | WidgetState.hovered | WidgetState.any: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(4.0)),
        //     side: BorderSide(color: Colors.black, width: 1.0, style: BorderStyle.solid),
        //   ),
        // }),
      ),
    );
  }

  void executaRotacao() {
    if (selectedFaceColor != ColorName.none) {
      Face face = RubikCube.mapColorNameToFace[selectedFaceColor]!;
      RubikSolverMovement.rotateFace90(face, selectedRotationSense);
    }
  }

  @override
  Widget build(BuildContext context) {
    solutionRow = createSolutionRow();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        // toolbarHeight: 50,
        title: const Text(
          "Rubik's Cube Solver",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actionsPadding: EdgeInsets.only(right: 30.0, top: 5.0, bottom: 5.0),
        backgroundColor: Colors.grey,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4.0,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                alignment: Alignment.center,
                child: IconButton(
                  iconSize: 30.0,
                  icon: const Icon(Icons.palette_outlined, color: Colors.white),
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CubeReaderPre()));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RubikReader()),
                    ).then((value) => setState(() {}));
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
                      WidgetState.any: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    }),
                    padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                      <WidgetStatesConstraint, EdgeInsetsGeometry>{
                        WidgetState.any: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                      },
                    ),
                    backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                      WidgetState.focused: Colors.indigoAccent,
                      WidgetState.pressed | WidgetState.hovered: Colors.blueAccent,
                      WidgetState.any: Colors.blue,
                    }),
                    alignment: Alignment.center,
                  ),
                  // style: ButtonStyle(iconAlignment: IconAlignment.start),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                alignment: Alignment.center,
                child: IconButton(
                  iconSize: 30.0,
                  icon: const Icon(Icons.shuffle_outlined, color: Colors.white),
                  onPressed: () {
                    RubikCube.createRandomCubeState();
                    setState(() {});
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
                      WidgetState.any: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    }),
                    padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                      <WidgetStatesConstraint, EdgeInsetsGeometry>{
                        WidgetState.any: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                      },
                    ),
                    backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                      WidgetState.focused: Colors.indigoAccent,
                      WidgetState.pressed | WidgetState.hovered: Colors.blueAccent,
                      WidgetState.any: Colors.blue,
                    }),
                    alignment: Alignment.center,
                  ),
                  // style: ButtonStyle(iconAlignment: IconAlignment.start),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                alignment: Alignment.center,
                child: IconButton(
                  iconSize: 30.0,
                  icon: const Icon(Icons.start, color: Colors.white),
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => CubeReaderPre()));
                    var solver = CerpeSolverAlgorithm();
                    currentSolution = solver.solveCubeInstance();
                    for (var move in currentSolution!.movementSequence) {
                      print(move.toString());
                    }
                    solver.returnToInitialState();
                    setState(() {});
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
                      WidgetState.any: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                    }),
                    padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                      <WidgetStatesConstraint, EdgeInsetsGeometry>{
                        WidgetState.any: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                      },
                    ),
                    backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                      WidgetState.focused: Colors.indigoAccent,
                      WidgetState.pressed | WidgetState.hovered: Colors.blueAccent,
                      WidgetState.any: Colors.blue,
                    }),
                    alignment: Alignment.center,
                  ),
                  // style: ButtonStyle(iconAlignment: IconAlignment.start),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: 1010.0,
          child: Column(
            children: [
              SizedBox(height: 10.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Row(
                    spacing: 6.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Rotacionar lado:"),
                      buildDropdownColorMenu(),
                      DropdownMenu(
                        width: 200,
                        textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                        requestFocusOnTap: false,
                        onSelected: (value) {
                          setState(() {
                            selectRotationSense(value);
                          });
                        },
                        dropdownMenuEntries: <DropdownMenuEntry<RotationSense>>[
                          buildRotationSelectionMenuEntry(RotationSense.clockwise),
                          buildRotationSelectionMenuEntry(RotationSense.counterclockwise),
                        ],
                        initialSelection: RotationSense.clockwise,
                      ),
                      Container(
                        // width: 50.0,
                        height: 50.0,
                        alignment: Alignment.center,
                        child: IconButton(
                          iconSize: 30.0,
                          icon: const Icon(Icons.loop_outlined, color: Colors.white),
                          onPressed: () {
                            setState(() {
                              executaRotacao();
                            });
                          },
                          style: ButtonStyle(
                            shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
                              WidgetState.any: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                            }),
                            // fixedSize: WidgetStatePropertyAll(Size.square(50.0)),
                            alignment: Alignment.center,
                            // padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                            //   <WidgetStatesConstraint, EdgeInsetsGeometry>{
                            //     WidgetState.any: const EdgeInsets.only(bottom: 5.0, top: 5.0),
                            //   },
                            // ),
                            backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                              WidgetState.focused: Colors.indigoAccent,
                              WidgetState.pressed | WidgetState.hovered: Colors.blueAccent,
                              WidgetState.any: Colors.blue,
                            }),
                          ),
                          // style: ButtonStyle(iconAlignment: IconAlignment.start),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(/*height: 50.0,*/ alignment: Alignment.center, child: createSolutionRow()),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: 900,
                  alignment: Alignment.center,
                  // margin: EdgeInsets.all(10.0),
                  // width: 1000,
                  // height: 1000,
                  child: Column(
                    children: [
                      CustomPaint(painter: RubikCubePlotter(), size: Size(900.0, 800.0) /*size: Size(800, 800)*/),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget createSolutionRow() {
    if (currentSolution == null || currentSolution!.movementSequence.isEmpty) {
      return Container(height: 0.0, child: Row(children: []));
    }
    int moves = currentSolution!.movementSequence.length;
    List<Widget> solutionMoves = List<Widget>.generate(
      moves,
      (index) => Container(
        width: 45.0,
        height: 50.0,
        alignment: Alignment.center,
        child: TextButton(
          onPressed: () {
            setState(() {
              RubikSolverMovement.doMovement(Face.front, currentSolution!.movementSequence[index].movement);
              setState(() {});
            });
          },
          style: ButtonStyle(
            shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
              WidgetState.any: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
            }),
            alignment: Alignment.center,
            backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused: Colors.indigoAccent,
              WidgetState.pressed | WidgetState.hovered: Colors.blueAccent,
              WidgetState.any: Colors.blue,
            }),
          ),
          child: Text(currentSolution!.movementSequence[index].movement.name, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
    return Row(spacing: 6.0, mainAxisAlignment: MainAxisAlignment.center, children: solutionMoves);
  }
}
