import 'package:flutter/material.dart';
import 'package:rubik_cube/cube_reader/manual_reader/rubik_reader.dart';
import 'package:rubik_cube/strings.dart';

class CubeReaderPre extends StatefulWidget {
  CubeReaderPre({super.key});
  final CubeReaderPreState estado = CubeReaderPreState();

  @override
  State<StatefulWidget> createState() {
    return estado;
  }
}

class CubeReaderPreState extends State<CubeReaderPre> {
  // final estado = _CubeReaderPreState();
  late CarouselController carouselController;
  late int lastIndex = 0;

  CubeReaderPreState() {
    carouselController = CarouselController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Rubik Cube Solver",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        backgroundColor: Color.fromRGBO(23, 23, 180, 1.0),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SizedBox(
          height: 1000,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 100.0),
                  Container(
                    padding: EdgeInsetsGeometry.all(30),
                    child: Text(Strings.strings[TextAlias.preReaderInstruction]!, style: TextStyle(fontSize: 20)),
                  ),
                  SizedBox(width: 100.0),
                  Container(
                    //              height: 100,
                    //alignment: Alignment.center,
                    child: TextButton(
                      style: ButtonStyle(
                        alignment: Alignment.center,
                        padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
                          <WidgetStatesConstraint, EdgeInsetsGeometry>{
                            WidgetState.focused: EdgeInsets.only(bottom: 20.0, top: 15.0, left: 10.0, right: 10.0),
                            WidgetState.hovered: EdgeInsets.only(bottom: 20.0, top: 15.0, left: 10.0, right: 10.0),
                            WidgetState.pressed: EdgeInsets.only(bottom: 20.0, top: 15.0, left: 10.0, right: 10.0),
                            WidgetState.any: EdgeInsets.only(bottom: 20.0, top: 15.0, left: 10.0, right: 10.0),
                          },
                        ),
                        backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
                          WidgetState.focused: Colors.orange,
                          WidgetState.hovered: Colors.orange,
                          WidgetState.pressed: Colors.orange,
                          WidgetState.any: Colors.lightBlueAccent,
                        }),
                        textStyle: WidgetStateProperty<TextStyle>.fromMap(<WidgetStatesConstraint, TextStyle>{
                          WidgetState.focused: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w100,
                            color: Colors.orange,
                          ),
                          WidgetState.hovered: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          WidgetState.pressed: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          WidgetState.any: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
                        }),
                        shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
                          WidgetState.focused: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          WidgetState.hovered: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          WidgetState.pressed: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          WidgetState.any: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black, width: 2.0),
                          ),
                        }),
                      ),
                      onPressed: () {
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => CubeReader()));
                        Navigator.push(context, MaterialPageRoute(builder: (context) => RubikReader()));
                      },
                      child: Text(
                        "Definir cores",
                        style: TextStyle(
                          fontStyle: FontStyle.normal,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  height: 900,
                  width: 1000,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  // child: Image(image: AssetImage("lib/assets/img/rubik-cube-posicao-inicial.png")),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 40,
                        onPressed: () {
                          lastIndex = lastIndex - 1;
                          if (lastIndex < 0) {
                            lastIndex = 7;
                          }
                          carouselController.animateToItem(lastIndex);
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      SizedBox(
                        height: 600,
                        width: 840,
                        child: CarouselView(
                          itemExtent: double.infinity,
                          scrollDirection: Axis.horizontal,
                          controller: carouselController,
                          children: List<Widget>.generate(8, (int index) {
                            return Image(image: AssetImage('lib/assets/img/rubik-cube-posicao-inicial-$index.png'));
                          }),
                        ),
                      ),
                      IconButton(
                        iconSize: 40,
                        onPressed: () {
                          lastIndex = (lastIndex + 1) % 8;
                          carouselController.animateToItem(lastIndex);
                        },
                        icon: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //   return SingleChildScrollView(
    //     scrollDirection: Axis.vertical,
    //     child: Container(
    //       height: 1040,
    //       child: Column(
    //         children: [
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               SizedBox(width: 100.0),
    //               Container(
    //                 padding: EdgeInsetsGeometry.all(30),
    //                 child: Text(Strings.strings[TextAlias.preReaderInstruction]!, style: TextStyle(fontSize: 20)),
    //               ),
    //               SizedBox(width: 100.0),
    //               Container(
    //                 //              height: 100,
    //                 //alignment: Alignment.center,
    //                 child: TextButton(
    //                   style: ButtonStyle(
    //                     alignment: Alignment.center,
    //                     padding: WidgetStateProperty<EdgeInsetsGeometry>.fromMap(
    //                       <WidgetStatesConstraint, EdgeInsetsGeometry>{
    //                         WidgetState.focused: EdgeInsets.only(bottom: 20.0, top: 15.0, left: 10.0, right: 10.0),
    //                         WidgetState.hovered: EdgeInsets.only(bottom: 20.0, top: 15.0, left: 10.0, right: 10.0),
    //                         WidgetState.pressed: EdgeInsets.only(bottom: 20.0, top: 15.0, left: 10.0, right: 10.0),
    //                         WidgetState.any: EdgeInsets.only(bottom: 20.0, top: 15.0, left: 10.0, right: 10.0),
    //                       },
    //                     ),
    //                     backgroundColor: WidgetStateProperty<Color>.fromMap(<WidgetStatesConstraint, Color>{
    //                       WidgetState.focused: Colors.orange,
    //                       WidgetState.hovered: Colors.orange,
    //                       WidgetState.pressed: Colors.orange,
    //                       WidgetState.any: Colors.lightBlueAccent,
    //                     }),
    //                     textStyle: WidgetStateProperty<TextStyle>.fromMap(<WidgetStatesConstraint, TextStyle>{
    //                       WidgetState.focused: TextStyle(
    //                         fontSize: 20.0,
    //                         fontWeight: FontWeight.w100,
    //                         color: Colors.orange,
    //                       ),
    //                       WidgetState.hovered: TextStyle(
    //                         fontSize: 20.0,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.green,
    //                       ),
    //                       WidgetState.pressed: TextStyle(
    //                         fontSize: 20.0,
    //                         fontWeight: FontWeight.bold,
    //                         color: Colors.white,
    //                       ),
    //                       WidgetState.any: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),
    //                     }),
    //                     shape: WidgetStateProperty<OutlinedBorder>.fromMap(<WidgetStatesConstraint, OutlinedBorder>{
    //                       WidgetState.focused: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(5.0),
    //                         side: BorderSide(color: Colors.black, width: 2.0),
    //                       ),
    //                       WidgetState.hovered: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(5.0),
    //                         side: BorderSide(color: Colors.black, width: 2.0),
    //                       ),
    //                       WidgetState.pressed: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(5.0),
    //                         side: BorderSide(color: Colors.black, width: 2.0),
    //                       ),
    //                       WidgetState.any: RoundedRectangleBorder(
    //                         borderRadius: BorderRadius.circular(5.0),
    //                         side: BorderSide(color: Colors.black, width: 2.0),
    //                       ),
    //                     }),
    //                   ),
    //                   onPressed: () {
    //                     Navigator.push(context, MaterialPageRoute(builder: (context) => CubeReader()));
    //                   },
    //                   child: Text(
    //                     "Definir cores",
    //                     style: TextStyle(
    //                       fontStyle: FontStyle.normal,
    //                       fontSize: 20.0,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.black,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Container(
    //             height: 900,
    //             width: 1000,
    //             alignment: Alignment.topCenter,
    //             padding: EdgeInsets.only(left: 20.0, right: 20.0),
    //             // child: Image(image: AssetImage("lib/assets/img/rubik-cube-posicao-inicial.png")),
    //             child: Row(
    //               children: [
    //                 IconButton(
    //                   onPressed: () {
    //                     lastIndex = (lastIndex + 1) % carouselController.positions.length;
    //                     carouselController.animateToItem(lastIndex);
    //                   },
    //                   icon: Icon(Icons.arrow_right_alt),
    //                 ),
    //                 Container(
    //                   height: 600,
    //                   width: 800,
    //                   child: CarouselView(
    //                     itemExtent: double.infinity,
    //                     scrollDirection: Axis.horizontal,
    //                     controller: carouselController,
    //                     children: List<Widget>.generate(8, (int index) {
    //                       return Image(image: AssetImage('lib/assets/img/rubik-cube-posicao-inicial-$index.png'));
    //                     }),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    //   }
    // }
    //
  }
}
