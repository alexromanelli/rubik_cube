import 'package:flutter/material.dart';
import 'package:rubik_cube/cube_plotter/drawing_constants.dart';
import 'package:rubik_cube/strings.dart';

import '../../rubik_cube.dart';

class CubeReader extends StatefulWidget {
  const CubeReader({super.key});

  @override
  State<StatefulWidget> createState() {
    return CubeReaderState();
  }
}

enum CubeColors { branco, vermelho, azul, verde, amarelo, laranja }

enum CubeReaderMovement { up, bottom, left, right }

class CubeReaderState extends State<CubeReader> {
  int selectedPieceColorIndex = 0;

  static var colorButtonWithBorder = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.zero,
    side: BorderSide(width: 5.0, color: Colors.black),
  );
  static var colorButtonWithoutBorder = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.zero,
    side: BorderSide(color: Colors.black12, width: 2.0),
  );

  var widgetStateWithBorder = WidgetStateProperty<OutlinedBorder?>.fromMap(<WidgetStatesConstraint, OutlinedBorder?>{
    // WidgetState.focused: colorButtonWithBorder,
    // WidgetState.hovered: colorButtonWithBorder,
    // WidgetState.pressed: colorButtonWithBorder,
    WidgetState.any: colorButtonWithBorder,
  });
  var widgetStateWithoutBorder = WidgetStateProperty<OutlinedBorder?>.fromMap(<WidgetStatesConstraint, OutlinedBorder?>{
    // WidgetState.focused: colorButtonWithoutBorder,
    // WidgetState.hovered: colorButtonWithoutBorder,
    // WidgetState.pressed: colorButtonWithoutBorder,
    WidgetState.any: colorButtonWithoutBorder,
  });

  final Map<CubeColors, int> colorMap = {
    CubeColors.branco: 0,
    CubeColors.vermelho: 1,
    CubeColors.azul: 2,
    CubeColors.verde: 3,
    CubeColors.amarelo: 4,
    CubeColors.laranja: 5,
  };

  final Map<int, Color> colorIndexMap = {
    0: Colors.blue,
    1: Colors.red,
    2: Colors.green,
    3: Colors.orange,
    4: Colors.white,
    5: Colors.yellow,
  };

  static final Map<String, ColorName> mapStringToColorName = {
    "Azul": ColorName.blue,
    "Vermelho": ColorName.red,
    "Verde": ColorName.green,
    "Laranja": ColorName.orange,
    "Branco": ColorName.white,
    "Amarelo": ColorName.yellow,
  };

  void selecionaCorDaPeca(int colorIndex) {
    selectedPieceColorIndex = colorIndex;
  }

  void changeSelectedFace(CubeReaderMovement movement) {
    switch (movement) {
      case CubeReaderMovement.up:
        break;
      case CubeReaderMovement.bottom:
        break;
      case CubeReaderMovement.left:
        break;
      case CubeReaderMovement.right:
        break;
    }
  }

  Container buildColorButton(int colorIndex) {
    var colorName = DrawingConstants.colorNameByIndex[colorIndex];

    return Container(
      height: 50,
      width: 60,
      padding: EdgeInsets.only(left: 5.0, right: 5.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            selecionaCorDaPeca(colorIndex);
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
            WidgetState.focused: DrawingConstants.pieceColor[colorName]!,
            WidgetState.hovered: DrawingConstants.pieceColor[colorName]!,
            WidgetState.pressed: DrawingConstants.pieceColor[colorName]!,
            WidgetState.any: DrawingConstants.pieceColor[colorName]!,
          }),
          shape: selectedPieceColorIndex == colorIndex ? widgetStateWithBorder : widgetStateWithoutBorder,
        ),
        child: Text(""),
      ),
    );
  }

  ColorName selectedFaceColor = ColorName.blue;

  void selectFaceColor(String? colorNameStr) {
    if (colorNameStr != null) {
      selectedFaceColor = mapStringToColorName[colorNameStr]!;
    }
  }

  DropdownMenuEntry<String> buildMenuEntry(String colorValue, Color buttonColor) {
    return DropdownMenuEntry(
      value: colorValue,
      label: "",
      style: ButtonStyle(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Rubik's Cube Solver",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        backgroundColor: Color.fromRGBO(23, 23, 180, 1.0),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Flexible(
            //   flex: 1,
            //   child:
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsetsGeometry.all(20.0),
              // height: 60.0,
              child: Text(
                Strings.strings[TextAlias.readerInstruction]!,
                softWrap: true,
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Face: ", style: TextStyle(fontSize: 20)),
                DropdownMenu(
                  textStyle: TextStyle(
                    fontSize: 1.0,
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
                    buildMenuEntry("Azul", Colors.blue),
                    buildMenuEntry("Vermelho", Colors.red),
                    buildMenuEntry("Verde", Colors.green),
                    buildMenuEntry("Laranja", Colors.orange),
                    buildMenuEntry("Branco", Colors.white),
                    buildMenuEntry("Amarelo", Colors.yellow),
                  ],
                  initialSelection: "Azul",
                ),
              ],
            ),
            // ),
            Container(
              margin: EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildColorButton(0),
                  buildColorButton(1),
                  buildColorButton(2),
                  buildColorButton(3),
                  buildColorButton(4),
                  buildColorButton(5),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => changeSelectedFace(CubeReaderMovement.up),
                  icon: Icon(Icons.keyboard_double_arrow_up),
                  color: Colors.blue,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            0,
                            0,
                          )],
                    ),
                    onPressed: () => setState(() {
                      RubikCube.setColorName(
                        DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                        0,
                        0,
                        DrawingConstants.colorNameByIndex[selectedPieceColorIndex]!,
                      );
                    }),
                    child: null,
                  ),
                ),
                SizedBox(width: 1.0),
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            0,
                            1,
                          )],
                    ),
                    onPressed: () => setState(() {
                      RubikCube.setColorName(
                        DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                        0,
                        1,
                        DrawingConstants.colorNameByIndex[selectedPieceColorIndex]!,
                      );
                    }),
                    child: null,
                  ),
                ),
                SizedBox(width: 1.0),
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            0,
                            2,
                          )],
                    ),
                    onPressed: () => setState(() {
                      RubikCube.setColorName(
                        DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                        0,
                        2,
                        DrawingConstants.colorNameByIndex[selectedPieceColorIndex]!,
                      );
                    }),
                    child: null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => changeSelectedFace(CubeReaderMovement.left),
                  icon: Icon(Icons.keyboard_double_arrow_left),
                  color: Colors.blue,
                ),
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            1,
                            0,
                          )],
                    ),
                    onPressed: () => setState(() {
                      RubikCube.setColorName(
                        DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                        1,
                        0,
                        DrawingConstants.colorNameByIndex[selectedPieceColorIndex]!,
                      );
                    }),
                    child: null,
                  ),
                ),
                SizedBox(width: 1.0),
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(15.0),
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            1,
                            1,
                          )],
                    ),
                    onPressed: () {},
                    child: null,
                  ),
                ),
                SizedBox(width: 1.0),
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            1,
                            2,
                          )],
                    ),
                    onPressed: () => setState(() {
                      RubikCube.setColorName(
                        DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                        1,
                        2,
                        DrawingConstants.colorNameByIndex[selectedPieceColorIndex]!,
                      );
                    }),
                    child: null,
                  ),
                ),
                IconButton(
                  onPressed: () => changeSelectedFace(CubeReaderMovement.left),
                  icon: Icon(Icons.keyboard_double_arrow_right),
                  color: Colors.blue,
                ),
              ],
            ),
            SizedBox(height: 1.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            2,
                            0,
                          )],
                    ),
                    onPressed: () => setState(() {
                      RubikCube.setColorName(
                        DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                        2,
                        0,
                        DrawingConstants.colorNameByIndex[selectedPieceColorIndex]!,
                      );
                    }),
                    child: null,
                  ),
                ),
                SizedBox(width: 1.0),
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            2,
                            1,
                          )],
                    ),
                    onPressed: () => setState(() {
                      RubikCube.setColorName(
                        DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                        2,
                        1,
                        DrawingConstants.colorNameByIndex[selectedPieceColorIndex]!,
                      );
                    }),
                    child: null,
                  ),
                ),
                SizedBox(width: 1.0),
                SizedBox(
                  height: 70.0,
                  width: 70.0,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.zero,
                        side: BorderSide(color: Colors.black, width: 2.0),
                      ),
                      backgroundColor:
                          DrawingConstants.pieceColor[RubikCube.getColorName(
                            DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                            2,
                            2,
                          )],
                    ),
                    onPressed: () => setState(() {
                      RubikCube.setColorName(
                        DrawingConstants.mapColorNameToFace[selectedFaceColor]!,
                        2,
                        2,
                        DrawingConstants.colorNameByIndex[selectedPieceColorIndex]!,
                      );
                    }),
                    child: null,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => changeSelectedFace(CubeReaderMovement.bottom),
                  icon: Icon(Icons.keyboard_double_arrow_down),
                  color: Colors.blue,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
