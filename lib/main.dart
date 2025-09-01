import 'package:flutter/material.dart';
import 'package:rubik_cube/cube_plotter/drawing_constants.dart';
import 'package:rubik_cube/cube_reader/manual_reader/cube_reader.dart';
import 'package:rubik_cube/cube_reader/manual_reader/rubik_reader.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_solution.dart';
import 'package:rubik_cube/rubik_cube.dart';

import 'cube_plotter/rubik_cube_plotter.dart';
import 'cube_solver/cerpe_method/cerpe_solver_algorithm.dart';

void main() {
  runApp(const RubikCubeSolverGUI());
}

class RubikCubeSolverGUI extends StatelessWidget {
  const RubikCubeSolverGUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Rubik Cube Solver', home: StartView());
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
  late List<bool> usedMove = <bool>[];
  late int usedMoveCurrentPos;

  late SingleChildScrollView solutionScrollablePanel;
  List<Widget> solutionStepButtonList = <Widget>[];
  List<GlobalKey> solutionStepButtonKeyList = <GlobalKey>[];

  late bool showFaceRotationTool;

  CubeSolverSolution? currentSolution;

  _StartViewState() {
    carouselController = CarouselController();
    selectedFaceColor = ColorName.none;
    selectedRotationSense = RotationSense.clockwise;
    resetUsedMove();
    showFaceRotationTool = false;
  }

  void resetUsedMove() {
    usedMove.clear();
    usedMoveCurrentPos = 0;
    if (currentSolution != null &&
        currentSolution!.movementSequence.isNotEmpty) {
      for (int i = 0; i < currentSolution!.movementSequence.length; ++i) {
        usedMove.add(false);
      }
    }
  }

  void setNextUsedMove() {
    if (usedMoveCurrentPos < usedMove.length) {
      usedMove[usedMoveCurrentPos++] = true;
    }
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
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DrawingConstants.pieceColor[selectedFaceColor],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),

      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty<Color>.fromMap(<
          WidgetStatesConstraint,
          Color
        >{
          WidgetState.focused: DrawingConstants.pieceColor[selectedFaceColor]!,
          WidgetState.hovered: DrawingConstants.pieceColor[selectedFaceColor]!,
          WidgetState.pressed: DrawingConstants.pieceColor[selectedFaceColor]!,
          WidgetState.any: DrawingConstants.pieceColor[selectedFaceColor]!,
        }),
      ),
      label: Text(
        "",
        style: TextStyle(
          backgroundColor: DrawingConstants.pieceColor[selectedFaceColor],
        ),
      ),
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

  DropdownMenuEntry<String> buildFaceSelectionMenuEntry(
    String colorValue,
    Color buttonColor,
  ) {
    return DropdownMenuEntry(
      value: colorValue,
      label: "",
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Size>{
          WidgetState.any: Size.fromWidth(80.0),
        }),
        backgroundColor:
            WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
              WidgetState.focused |
                      WidgetState.pressed |
                      WidgetState.hovered |
                      WidgetState.any:
                  buttonColor,
            }),
        shape: WidgetStateProperty<OutlinedBorder>.fromMap(
          <WidgetStatesConstraint, OutlinedBorder>{
            WidgetState.focused |
                WidgetState.pressed |
                WidgetState.hovered |
                WidgetState.any: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              side: BorderSide(
                color: Colors.black,
                width: 1.0,
                style: BorderStyle.solid,
              ),
            ),
          },
        ),
      ),
    );
  }

  DropdownMenuEntry<RotationSense> buildRotationSelectionMenuEntry(
    RotationSense sense,
  ) {
    return DropdownMenuEntry(
      value: sense,
      label: switch (sense) {
        RotationSense.clockwise => "Sentido horário",
        RotationSense.counterclockwise => "Sentido anti-horário",
      },
      style: ButtonStyle(
        fixedSize: WidgetStateProperty.fromMap(<WidgetStatesConstraint, Size>{
          WidgetState.any: Size.fromWidth(230.0),
        }),
        shape: WidgetStateProperty<OutlinedBorder>.fromMap(
          <WidgetStatesConstraint, OutlinedBorder>{
            WidgetState.any: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              side: BorderSide(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                width: 2.0,
                style: BorderStyle.solid,
              ),
            ),
          },
        ),
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
    solutionStepButtonList.clear();
    solutionStepButtonKeyList.clear();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Rubik's Cube Solver",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actionsPadding: EdgeInsets.only(right: 15.0, top: 5.0, bottom: 5.0),
        backgroundColor: Colors.grey,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 6.0,
            children: [
              Container(
                width: 116.0,
                height: 40.0,
                margin: EdgeInsets.only(right: 15.0),
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    showFaceRotationTool = !showFaceRotationTool;
                    setState(() {});
                  },
                  style: ButtonStyle(
                    fixedSize: WidgetStatePropertyAll(Size(116, 40)),
                    shape: WidgetStateProperty<OutlinedBorder>.fromMap(
                      <WidgetStatesConstraint, OutlinedBorder>{
                        WidgetState.any: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          side: BorderSide(color: Colors.black26, width: 1.0),
                        ),
                      },
                    ),
                    padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                      <WidgetStatesConstraint, EdgeInsetsGeometry>{
                        WidgetState.any: const EdgeInsets.only(
                          bottom: 5.0,
                          top: 5.0,
                          right: 3.0,
                          left: 3.0,
                        ),
                      },
                    ),
                    backgroundColor: (showFaceRotationTool
                        ? WidgetStateProperty<Color>.fromMap(
                            <WidgetStatesConstraint, Color>{
                              WidgetState.pressed | WidgetState.hovered:
                                  Colors.blueAccent,
                              WidgetState.any: Colors.indigoAccent,
                            },
                          )
                        : WidgetStateProperty<Color>.fromMap(
                            <WidgetStatesConstraint, Color>{
                              WidgetState.any: Colors.lightGreen,
                            },
                          )),
                    alignment: Alignment.center,
                  ),
                  child: Text(
                    (showFaceRotationTool
                        ? "Hide rotation tool"
                        : "Show rotation tool"),
                    style: TextStyle(color: Colors.black, fontSize: 12.0),
                  ),
                ),
              ),
              Container(
                width: 40.0,
                height: 40.0,
                alignment: Alignment.center,
                child: IconButton(
                  iconSize: 30.0,
                  icon: const Icon(Icons.palette_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RubikReader()),
                    ).then((value) => setState(() {}));
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty<OutlinedBorder>.fromMap(
                      <WidgetStatesConstraint, OutlinedBorder>{
                        WidgetState.any: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      },
                    ),
                    padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                      <WidgetStatesConstraint, EdgeInsetsGeometry>{
                        WidgetState.any: const EdgeInsets.only(
                          bottom: 5.0,
                          top: 5.0,
                        ),
                      },
                    ),
                    backgroundColor: WidgetStateProperty<Color>.fromMap(
                      <WidgetStatesConstraint, Color>{
                        WidgetState.focused: Colors.indigoAccent,
                        WidgetState.pressed | WidgetState.hovered:
                            Colors.blueAccent,
                        WidgetState.any: Colors.blue,
                      },
                    ),
                    alignment: Alignment.center,
                  ),
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
                    currentSolution = null;
                    resetUsedMove();
                    setState(() {});
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty<OutlinedBorder>.fromMap(
                      <WidgetStatesConstraint, OutlinedBorder>{
                        WidgetState.any: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      },
                    ),
                    padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                      <WidgetStatesConstraint, EdgeInsetsGeometry>{
                        WidgetState.any: const EdgeInsets.only(
                          bottom: 5.0,
                          top: 5.0,
                        ),
                      },
                    ),
                    backgroundColor: WidgetStateProperty<Color>.fromMap(
                      <WidgetStatesConstraint, Color>{
                        WidgetState.focused: Colors.indigoAccent,
                        WidgetState.pressed | WidgetState.hovered:
                            Colors.blueAccent,
                        WidgetState.any: Colors.blue,
                      },
                    ),
                    alignment: Alignment.center,
                  ),
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
                    var solver = CerpeSolverAlgorithm();
                    currentSolution = solver.solveCubeInstance();
                    solver.returnToInitialState();
                    resetUsedMove();
                    setState(() {});
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty<OutlinedBorder>.fromMap(
                      <WidgetStatesConstraint, OutlinedBorder>{
                        WidgetState.any: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                      },
                    ),
                    padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                      <WidgetStatesConstraint, EdgeInsetsGeometry>{
                        WidgetState.any: const EdgeInsets.only(
                          bottom: 5.0,
                          top: 5.0,
                        ),
                      },
                    ),
                    backgroundColor: WidgetStateProperty<Color>.fromMap(
                      <WidgetStatesConstraint, Color>{
                        WidgetState.focused: Colors.indigoAccent,
                        WidgetState.pressed | WidgetState.hovered:
                            Colors.blueAccent,
                        WidgetState.any: Colors.blue,
                      },
                    ),
                    alignment: Alignment.center,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SingleChildScrollView(
          child: Container(
            height: 1000.0,
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                (showFaceRotationTool
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          height: 80.0,
                          alignment: Alignment.center,
                          child: Row(
                            spacing: 6.0,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Centro:"),
                              buildDropdownColorMenu(),
                              DropdownMenu(
                                width: 200,
                                textStyle: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                ),
                                requestFocusOnTap: false,
                                onSelected: (value) {
                                  setState(() {
                                    selectRotationSense(value);
                                  });
                                },
                                dropdownMenuEntries:
                                    <DropdownMenuEntry<RotationSense>>[
                                      buildRotationSelectionMenuEntry(
                                        RotationSense.clockwise,
                                      ),
                                      buildRotationSelectionMenuEntry(
                                        RotationSense.counterclockwise,
                                      ),
                                    ],
                                initialSelection: RotationSense.clockwise,
                              ),
                              Container(
                                height: 70.0,
                                alignment: Alignment.center,
                                child: IconButton(
                                  iconSize: 30.0,
                                  icon: const Icon(
                                    Icons.loop_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      executaRotacao();
                                    });
                                  },
                                  style: ButtonStyle(
                                    shape:
                                        WidgetStateProperty<
                                          OutlinedBorder
                                        >.fromMap(<
                                          WidgetStatesConstraint,
                                          OutlinedBorder
                                        >{
                                          WidgetState.any:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                              ),
                                        }),
                                    alignment: Alignment.center,
                                    backgroundColor:
                                        WidgetStateProperty<Color>.fromMap(
                                          <WidgetStatesConstraint, Color>{
                                            WidgetState.focused:
                                                Colors.indigoAccent,
                                            WidgetState.pressed |
                                                    WidgetState.hovered:
                                                Colors.blueAccent,
                                            WidgetState.any: Colors.blue,
                                          },
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SizedBox(height: 5.0)),
                currentSolution == null ||
                        currentSolution!.movementSequence.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Text("Ainda não solucionado"),
                      )
                    : Row(
                        spacing: 6.0,
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            alignment: Alignment.center,
                            // padding: EdgeInsets.only(left: 6.0),
                            child: IconButton(
                              iconSize: 30,
                              onPressed: () {
                                if (usedMoveCurrentPos <
                                    currentSolution!.movementSequence.length) {
                                  RubikSolverMovement.doMovement(
                                    Face.front,
                                    currentSolution!
                                        .movementSequence[usedMoveCurrentPos]
                                        .movement,
                                  );
                                  ++usedMoveCurrentPos;
                                  scrollToNextStep();
                                  setState(() {});
                                }
                              },
                              style: ButtonStyle(
                                fixedSize: WidgetStateProperty<Size>.fromMap(
                                  <WidgetStatesConstraint, Size>{
                                    WidgetState.any: Size.square(50),
                                  },
                                ),
                                shape:
                                    WidgetStateProperty<OutlinedBorder>.fromMap(
                                      <WidgetStatesConstraint, OutlinedBorder>{
                                        WidgetState.any: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Color.fromRGBO(0, 0, 0, 0.2),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6.0,
                                          ),
                                        ),
                                      },
                                    ),
                                alignment: Alignment.center,
                                backgroundColor:
                                    WidgetStateProperty<Color>.fromMap(<
                                      WidgetStatesConstraint,
                                      Color
                                    >{
                                      // WidgetState.hovered: Colors.orange,
                                      // WidgetState.pressed: Colors.deepOrange,
                                      WidgetState.any: Colors.green,
                                    }),
                              ),
                              icon: Icon(
                                Icons.play_circle_outline,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                          Container(
                            width: 50.0,
                            height: 50.0,
                            alignment: Alignment.center,
                            // padding: EdgeInsets.only(left: 6.0),
                            child: IconButton(
                              iconSize: 30,
                              onPressed: () {
                                if (usedMoveCurrentPos <
                                    currentSolution!.movementSequence.length) {
                                  RubikSolverMovement.doMovement(
                                    Face.front,
                                    currentSolution!
                                        .movementSequence[usedMoveCurrentPos]
                                        .movement,
                                  );
                                  ++usedMoveCurrentPos;
                                  scrollToNextStep();
                                  setState(() {});
                                }
                              },
                              style: ButtonStyle(
                                fixedSize: WidgetStateProperty<Size>.fromMap(
                                  <WidgetStatesConstraint, Size>{
                                    WidgetState.any: Size.square(50),
                                  },
                                ),
                                shape:
                                    WidgetStateProperty<OutlinedBorder>.fromMap(
                                      <WidgetStatesConstraint, OutlinedBorder>{
                                        WidgetState.any: RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Color.fromRGBO(0, 0, 0, 0.1),
                                            width: 1.0,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6.0,
                                          ),
                                        ),
                                      },
                                    ),
                                alignment: Alignment.center,
                                backgroundColor:
                                    WidgetStateProperty<Color>.fromMap(<
                                      WidgetStatesConstraint,
                                      Color
                                    >{
                                      WidgetState.hovered: Colors.amber,
                                      // WidgetState.pressed: Colors.deepOrange,
                                      WidgetState.any: Colors.amberAccent,
                                    }),
                              ),
                              icon: Icon(
                                Icons.run_circle_outlined,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ),
                          Expanded(child: createSolutionScrollPanel()),
                        ],
                      ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    height: 800,
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CustomPaint(
                          painter: RubikCubePlotter(),
                          size: Size(800.0, 800.0) /*size: Size(800, 800)*/,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget createSolutionScrollPanel() {
    solutionScrollablePanel = SingleChildScrollView(
      padding: EdgeInsets.only(right: 6.0),
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          maxHeight: 50.0,
        ),
        child: Wrap(
          direction: Axis.horizontal,
          spacing: 6.0,
          alignment: WrapAlignment.start,
          children: createSolutionRow(),
        ),
      ),
    );
    return solutionScrollablePanel;
  }

  void scrollToNextStep() {
    if (usedMoveCurrentPos > 0) {
      Scrollable.ensureVisible(
        solutionStepButtonKeyList[usedMoveCurrentPos - 1].currentContext!,
      );
    }
  }

  Color getColorByIndex(int index) {
    Color color = index < usedMoveCurrentPos ? Colors.grey : Colors.blue;
    return color;
  }

  List<Widget> createSolutionRow() {
    int numberOfMoves = currentSolution != null
        ? currentSolution!.movementSequence.length
        : 0;
    List<Widget> solutionMoves = <Widget>[
      Container(
        height: 50.0,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 5.0, right: 5.0),
        margin: EdgeInsets.only(left: 5.0, right: 5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Colors.white,
          border: BoxBorder.all(
            color: Colors.black45,
            width: 1.0,
            style: BorderStyle.solid,
          ),
        ),
        child: Text(
          "$numberOfMoves\nmovimentos",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ),
      ),
    ];
    if (currentSolution == null || currentSolution!.movementSequence.isEmpty) {
      return solutionMoves;
    }
    solutionMoves.addAll(
      List<Widget>.generate(numberOfMoves, (index) {
        var key = GlobalKey();
        solutionStepButtonKeyList.add(key);
        var container = Container(
          key: key,
          width: 50.0,
          height: 50.0,
          alignment: Alignment.center,
          child: TextButton(
            onPressed: index >= usedMoveCurrentPos && index < numberOfMoves
                ? () {
                    RubikSolverMovement.doMovement(
                      Face.front,
                      currentSolution!.movementSequence[index].movement,
                    );
                    setNextUsedMove();
                    scrollToNextStep();
                    setState(() {});
                  }
                : () {},
            style: ButtonStyle(
              fixedSize: WidgetStateProperty<Size>.fromMap(
                <WidgetStatesConstraint, Size>{
                  WidgetState.any: Size.fromHeight(50),
                },
              ),
              shape: WidgetStateProperty<OutlinedBorder>.fromMap(
                <WidgetStatesConstraint, OutlinedBorder>{
                  WidgetState.any: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                },
              ),
              alignment: Alignment.center,
              backgroundColor: (usedMoveCurrentPos > index
                  ? WidgetStateProperty<Color>.fromMap(
                      <WidgetStatesConstraint, Color>{
                        WidgetState.any: Colors.grey,
                      },
                    )
                  : (usedMoveCurrentPos == index
                        ? WidgetStateProperty<Color>.fromMap(
                            <WidgetStatesConstraint, Color>{
                              WidgetState.any: Colors.purple,
                            },
                          )
                        : WidgetStateProperty<Color>.fromMap(
                            <WidgetStatesConstraint, Color>{
                              WidgetState.any: Colors.indigoAccent,
                            },
                          ))),
            ),
            child: Text(
              currentSolution!.movementSequence[index].movement.name,
              style: TextStyle(color: Colors.white, fontSize: 18.0),
            ),
          ),
        );
        solutionStepButtonList.add(container);
        return container;
      }),
    );
    return solutionMoves;
  }
}
