import 'package:flutter/material.dart';
import 'package:rubik_cube/cube_plotter/drawing_constants.dart';
import 'package:rubik_cube/rubik_cube.dart';
import 'package:rubik_cube/strings.dart';

class RubikReader extends StatefulWidget {
  const RubikReader({super.key});

  @override
  State<RubikReader> createState() {
    return RubikReaderState();
  }
}

typedef MatrixCellCoordinates = (int row, int column);

class RubikReaderState extends State<RubikReader> {
  static final facePosition = <Face, MatrixCellCoordinates>{
    Face.front: (3, 3),
    Face.left: (3, 0),
    Face.right: (3, 6),
    Face.back: (3, 9),
    Face.top: (0, 3),
    Face.bottom: (6, 3),
  };

  final panelMatrix = <List<FilledButton?>>[
    [null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null],
  ];

  void completePanelMatrix() {
    for (var face in Face.values) {
      if (face == Face.none) { continue; }
      int r = facePosition[face]!.$1;
      int c = facePosition[face]!.$2;
      for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 3; ++j) {
          panelMatrix[r + i][c + j] = buttonPanelMatrix(face, i, j);
        }
      }
    }
  }

  void setPieceColor(Face face, int row, int column, int colorIndex) {
    setState(() {
      RubikCube.setColorName(
        face,
        row,
        column,
        DrawingConstants.colorNameByIndex[colorIndex]!,
      );
    });
  }

  FilledButton buttonPanelMatrix(Face face, int r, int c) {
    var centralBordersCircularRadius = 8.0;
    var externalBordersCircularRadius = 4.0;
    var borderSideWidth = 1.5;

    BorderRadiusGeometry border;
    if(r == 1 && c == 1) {
      border = BorderRadiusGeometry.all(Radius.circular(centralBordersCircularRadius));
    } else if (r == 0 && c == 1) {
      border = BorderRadiusGeometry.only(
          bottomLeft: Radius.circular(centralBordersCircularRadius), 
          bottomRight: Radius.circular(centralBordersCircularRadius), 
          topLeft: Radius.circular(externalBordersCircularRadius), 
          topRight: Radius.circular(externalBordersCircularRadius));
    } else if (r == 1 && c == 0) {
      border = BorderRadiusGeometry.only(
          topRight: Radius.circular(centralBordersCircularRadius), 
          bottomRight: Radius.circular(centralBordersCircularRadius), 
          topLeft: Radius.circular(externalBordersCircularRadius), 
          bottomLeft: Radius.circular(externalBordersCircularRadius));
    } else if (r == 1 && c == 2) {
      border = BorderRadiusGeometry.only(
          topLeft: Radius.circular(centralBordersCircularRadius), 
          bottomLeft: Radius.circular(centralBordersCircularRadius), 
          bottomRight: Radius.circular(externalBordersCircularRadius), 
          topRight: Radius.circular(externalBordersCircularRadius));
    } else if (r == 2 && c == 1) {
      border = BorderRadiusGeometry.only(
          topLeft: Radius.circular(centralBordersCircularRadius), 
          topRight: Radius.circular(centralBordersCircularRadius), 
          bottomRight: Radius.circular(externalBordersCircularRadius), 
          bottomLeft: Radius.circular(externalBordersCircularRadius));
    } else {
      border = BorderRadiusGeometry.circular(externalBordersCircularRadius);
    }
    return FilledButton(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: border,
          side: BorderSide(color: Colors.black38, width: borderSideWidth),
        ),
        backgroundColor:
            DrawingConstants.pieceColor[RubikCube.getColorName(face, r, c)],
      ),
      onPressed: () => setPieceColor(face, r, c, selectedPieceColorIndex),
      child: null,
    );
  }

  int selectedPieceColorIndex = 0;

  static var colorButtonWithBorder = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.zero,
    side: BorderSide(width: 5.0, color: Colors.black),
  );

  static var colorButtonWithoutBorder = RoundedRectangleBorder(
    borderRadius: BorderRadiusGeometry.zero,
    side: BorderSide(color: Colors.black12, width: 2.0),
  );

  var widgetStateWithBorder = WidgetStateProperty<OutlinedBorder?>.fromMap(
    <WidgetStatesConstraint, OutlinedBorder?>{
      WidgetState.focused | WidgetState.hovered | WidgetState.pressed | WidgetState.any: colorButtonWithBorder,
    },
  );

  var widgetStateWithoutBorder = WidgetStateProperty<OutlinedBorder?>.fromMap(
    <WidgetStatesConstraint, OutlinedBorder?>{
      WidgetState.focused | WidgetState.hovered | WidgetState.pressed | WidgetState.any: colorButtonWithoutBorder,
    },
  );

  static final Color
  appBarBackgroundColor = Colors.grey;

  List<Widget> rubikReaderPanel() {
    return List<Row>.generate(9, (index) => rubikReaderPanelRow(index));
  }

  void resetCubePieceColors() {
    setState(() {
      RubikCube.resetCube();
    });
  }

  @override
  Widget build(BuildContext context) {
    completePanelMatrix();
    var controlWidgets = <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 35.0),
        child: TextButton(
          onPressed: () => resetCubePieceColors(),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color> {
              WidgetState.any: Color.fromRGBO(119, 203, 220, 1.0),
            }),
            shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
              WidgetState.any: RoundedRectangleBorder(side: BorderSide(color: Colors.black, style: BorderStyle.solid, width: 1.0), borderRadius: BorderRadius.circular(8.0)),
            })
          ),
          child: Text("Reset", style: TextStyle(color: Colors.black, fontSize: 15.0),)
        ),
      )
    ];
    controlWidgets.insertAll(0, List<Widget>.generate(6, (index) => buildColorButton(index)));

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: controlWidgets,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: appBarBackgroundColor,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: [
          SizedBox(height: 10.0,),
          // rubikReaderColorSelectionRow(),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  // width: 1000.0,
                  // height: 1000.0,
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: rubikReaderPanel(),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }

  Widget rubikReaderInstructionText() {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Text(
        Strings.strings[TextAlias.readerInstruction]!,
        softWrap: true,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Row rubikReaderPanelRow(int rowIndex) {
    var buttonSize = 50.0;
    var marginBetweenFaces = 8.0;
    var marginTop = (rowIndex % 3) == 0 ? marginBetweenFaces : 0.0;
    var horizontalSizedBoxWidth = 15.0;
    var rowChildren = <Widget>[
      SizedBox(width: horizontalSizedBoxWidth),
      SizedBox(width: horizontalSizedBoxWidth),
    ];
    var buttonList = List<Widget>.generate(12, (index) {
      var marginLeft = (index % 3) == 0 ? marginBetweenFaces : 0.0;
      return Container(
        width: buttonSize,
        height: buttonSize,
        margin: EdgeInsets.only(
          top: marginTop,
          left: marginLeft,
          right: 2.0,
          bottom: 2.0,
        ),
        child: panelMatrix[rowIndex][index],
      );
    });
    rowChildren.insertAll(1, buttonList);
    return Row(
      children: rowChildren,
    );
  }

  Widget rubikReaderColorSelectionRow() {
    var controlWidgets = <Widget>[];
    controlWidgets.add(TextButton(
        onPressed: () => RubikCube.resetCube(),
        child: Text("Reset", style: TextStyle(color: Colors.black, fontSize: 20.0),)
    ));
    controlWidgets.addAll(List<Widget>.generate(6, (index) => buildColorButton(index)));
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        border: BoxBorder.fromLTRB(
          bottom: BorderSide(
            color: Colors.black38,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: controlWidgets,
      ),
    );
  }

  Container buildColorButton(int colorIndex) {
    var colorName = DrawingConstants.colorNameByIndex[colorIndex];

    return Container(
      height: 40,
      width: 45,
      padding: EdgeInsets.only(left: 2.0, right: 3.0),
      child: TextButton(
        onPressed: () {
          setState(() {
            selecionaCorDaPeca(colorIndex);
          });
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty<Color>.fromMap(
            <WidgetStatesConstraint, Color>{
              WidgetState.focused |
                      WidgetState.hovered |
                      WidgetState.pressed |
                      WidgetState.any:
                  DrawingConstants.pieceColor[colorName]!,
            },
          ),
          shape: selectedPieceColorIndex == colorIndex
              ? widgetStateWithBorder
              : widgetStateWithoutBorder,
        ),
        child: Text(""),
      ),
    );
  }

  void selecionaCorDaPeca(int colorIndex) {
    setState(() {
      selectedPieceColorIndex = colorIndex;
    });
  }
}
