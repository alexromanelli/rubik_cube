import 'package:flutter/material.dart';
import 'package:rubik_cube/cube_reader/manual_reader/cube_reader_pre.dart';
import 'package:rubik_cube/cube_reader/manual_reader/rubik_reader.dart';
import 'package:rubik_cube/cube_solver/rubik_solver_movement.dart';

import 'cube_plotter/rubik_cube_plotter.dart';

void main() {
  runApp(const RubikCubeSolverGUI());
}

enum Movement {
  L1, // left 90° clockwise
  R1, // right 90° clockwise
  T1, // top 90° clockwise
  B1, // bottom 90° clockwise
  L2, // left 90° counterclockwise
  R2, // right 90° counterclockwise
  T2, // top 90° counterclockwise
  B2, // bottom 90° counterclockwise
}

class CubeMove {
  final List<Movement> _move = [];

  CubeMove();

  List<Movement> get move => _move;

  void addMove(Movement move) {
    _move.add(move);
  }
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

  _StartViewState() {
    carouselController = CarouselController();
  }

  void refresh() {
    setState(() {});
  }

  CubeMove move = CubeMove();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text(
          "Rubik Cube Solver",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        actionsPadding: EdgeInsets.only(right: 30.0, top: 10.0, bottom: 10.0),
        backgroundColor: Colors.grey,
        actions: [
          IconButton(
            iconSize: 30.0,
            icon: const Icon(Icons.palette_outlined, color: Colors.white),
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => CubeReaderPre()));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RubikReader()))
                        .then((value) => setState(() {})
              );
            },
            alignment: Alignment.center,
            style: ButtonStyle(
              shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
                WidgetState.any: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
              }),
              padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(<WidgetStatesConstraint, EdgeInsetsGeometry>{
                WidgetState.any: const EdgeInsets.only(bottom: 9.0, top: 3.0),
              }),
              backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                WidgetState.focused: Colors.grey,
                WidgetState.pressed | WidgetState.hovered: Colors.blueAccent,
                WidgetState.any: Colors.blueAccent,
              }),
              alignment: Alignment.center,
            ),
            // style: ButtonStyle(iconAlignment: IconAlignment.start),
          ),
          SizedBox(width: 10.0),
          IconButton(
            iconSize: 30.0,
            icon: const Icon(Icons.refresh_outlined, color: Colors.white),
            onPressed: () {
              setState(() {
                RubikSolverMovement.testaRotacao();
              });
            },
            alignment: Alignment.center,
            style: ButtonStyle(
              shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
                WidgetState.any: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
              }),
              padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(<WidgetStatesConstraint, EdgeInsetsGeometry>{
                WidgetState.any: const EdgeInsets.only(bottom: 9.0, top: 3.0),
              }),
              backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                WidgetState.focused: Colors.grey,
                WidgetState.pressed | WidgetState.hovered | WidgetState.any: Colors.blueAccent,
              }),
              alignment: Alignment.center,
            ),
            // style: ButtonStyle(iconAlignment: IconAlignment.start),
          ),
        ],
      ),
      body: /*Container(
        alignment: Alignment.topCenter,
        child:*/ SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          alignment: Alignment.center,
          // width: 1000,
          // height: 1000,
          child: CustomPaint(painter: RubikCubePlotter(), size: Size(1000, 800)),
        ),
      ),
      /*),*/
    );
  }
}
