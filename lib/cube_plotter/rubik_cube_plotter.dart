import 'package:flutter/material.dart';
import 'package:rubik_cube/cube_plotter/util.dart';

import '../rubik_cube.dart';
import 'drawing_constants.dart';

class CubePart {
  int columnIndex;
  int rowIndex;
  Face face;
  Point2D startPoint;
  List<Point2D> edgePoint = [];
  Color? fillColor;
  List<Color> colorHistory = [];

  CubePart(this.rowIndex, this.columnIndex, this.face, this.startPoint);

  void setFillColor(Color color) {
    if (fillColor != null) {
      colorHistory.add(color);
    }
    fillColor = color;
  }

  void paint(Canvas canvas, Point2D refPoint, double partEdgeLength) {
    switch (face) {
      case Face.front:
      case Face.top:
      case Face.right:
      case Face.back:
      case Face.bottom:
      case Face.left:
    }
  }
}

class CubeFace {
  Face face;
  Point2D startPoint;
  List<List<CubePart>> matrix = [];

  CubeFace(this.face, this.startPoint) {
    buildMatrix();
  }

  void buildMatrix() {
    if (DrawingConstants.listFaceVector[face]!.length != 3) {
      return;
    }
    for (var row = 0; row < 3; row++) {
      var rowList = <CubePart>[];
      for (var column = 0; column < 3; column++) {
        var part = CubePart(row, column, face, startPoint);
        Point2D currentPoint = startPoint;
        part.edgePoint.add(currentPoint.copy());
        for (var vector in DrawingConstants.listFaceVector[face]!) {
          currentPoint = currentPoint + vector;
          part.edgePoint.add(currentPoint.copy());
        }
        rowList.add(part);
      }
      matrix.add(rowList);
    }
  }
}

// class RubikCube {
//   Map<Face, CubeFace> face = <Face, CubeFace>{
//     Face.front: CubeFace(Face.front, Point2D(0, 0)),
//     Face.top: CubeFace(Face.top, Point2D(0, 0)),
//     Face.right: CubeFace(Face.right, Point2D(0, 0)),
//     Face.back: CubeFace(Face.back, Point2D(0, 0)),
//     Face.bottom: CubeFace(Face.bottom, Point2D(0, 0)),
//     Face.left: CubeFace(Face.left, Point2D(0, 0)),
//   };
//
//   void setFaceStartPoint(Face face, Point2D startPoint) => this.face[face]!.startPoint = startPoint.copy();
// }

class RubikCubePlotter extends CustomPainter {
  var facePart = <Face, List<List<CubePart>>>{};
  var facePartCoordinates = <Face, List<List<Point2D>>>{};

  void paintCubePart(
    Canvas canvas,
    Size size,
    Face face,
    Point2D refPoint,
    double partEdgeLength,
    int row,
    int column,
  ) {
    Path path = Path();
    path.moveTo(refPoint.x, size.height - refPoint.y);
    var currentPoint = refPoint + DrawingConstants.listFaceVector[face]![0].multScalar(partEdgeLength);
    path.lineTo(currentPoint.x, size.height - currentPoint.y);
    currentPoint = currentPoint + DrawingConstants.listFaceVector[face]![1].multScalar(partEdgeLength);
    path.lineTo(currentPoint.x, size.height - currentPoint.y);
    currentPoint = currentPoint + DrawingConstants.listFaceVector[face]![2].multScalar(partEdgeLength);
    path.lineTo(currentPoint.x, size.height - currentPoint.y);
    currentPoint = Point2D(refPoint.x, refPoint.y);
    path.lineTo(currentPoint.x, size.height - currentPoint.y);
    path.close();

    Color? color = DrawingConstants.pieceColor[RubikCube.mapFaceToColorNameMatrix[face]![row][column]];
    if (face == Face.back || face == Face.left) {
      color = DrawingConstants.pieceColor[RubikCube.mapFaceToColorNameMatrix[face]![row][2 - column]];
    }
    if (face == Face.bottom) {
      color = DrawingConstants.pieceColor[RubikCube.mapFaceToColorNameMatrix[face]![2 - row][column]];
    }
    var p = Paint();
    p.style = PaintingStyle.fill;
    p.color = color!;
    canvas.drawPath(path, p);
    p.style = PaintingStyle.stroke;
    p.color = Colors.black;
    canvas.drawPath(path, p);
  }

  void paintCubeFace(Canvas canvas, Size size, Face face, Point2D faceRefPoint, double partEdgeLength) {
    for (var row = 0; row < 3; row++) {
      var lineRefPoint = faceRefPoint + DrawingConstants.listFaceVector[face]![0].multScalar(row * partEdgeLength);
      for (var column = 0; column < 3; column++) {
        var refPoint = lineRefPoint + DrawingConstants.listFaceVector[face]![1].multScalar(column * partEdgeLength);
        paintCubePart(canvas, size, face, refPoint, partEdgeLength, row, column);
      }
    }
  }

  var faceRefPoint = <Face, Point2D>{};

  var facePoint = <Face, List<Point2D>>{
    Face.front: [],
    Face.top: [],
    Face.right: [],
    Face.back: [],
    Face.bottom: [],
    Face.left: [],
  };

  double max_x = -double.maxFinite;
  double min_x = double.maxFinite;
  double max_y = -double.maxFinite;
  double min_y = double.maxFinite;

  void checkMaxMin(Point2D p) {
    if (p.x > max_x) {
      max_x = p.x;
    }
    if (p.x < min_x) {
      min_x = p.x;
    }
    if (p.y > max_y) {
      max_y = p.y;
    }
    if (p.y < min_y) {
      min_y = p.y;
    }
  }

  void computeFacePoint(Face face, Point2D refPoint, double partEdgeLength) {
    checkMaxMin(refPoint);
    var currentPoint = refPoint + DrawingConstants.listFaceVector[face]![0].multScalar(partEdgeLength * 3);
    checkMaxMin(currentPoint);
    facePoint[face]!.add(currentPoint.copy());
    currentPoint = currentPoint + DrawingConstants.listFaceVector[face]![1].multScalar(partEdgeLength * 3);
    checkMaxMin(currentPoint);
    facePoint[face]!.add(currentPoint.copy());
    currentPoint = currentPoint + DrawingConstants.listFaceVector[face]![2].multScalar(partEdgeLength * 3);
    checkMaxMin(currentPoint);
    facePoint[face]!.add(currentPoint.copy());
  }

  void clearComputedPoints() {
    faceRefPoint.clear();
    facePoint.clear();
    faceRefPoint = <Face, Point2D>{};

    facePoint = <Face, List<Point2D>>{
      Face.front: [],
      Face.top: [],
      Face.right: [],
      Face.back: [],
      Face.bottom: [],
      Face.left: [],
    };
  }

  void computeAllVertices(Size size, double length) {
    clearComputedPoints();
    var mediumPoint = Point2D((size.width / 2.7) - length, size.height - length * 4);
    var refPointFront = mediumPoint.copy();
    faceRefPoint[Face.front] = refPointFront.copy();
    facePoint[Face.front]!.add(refPointFront.copy());
    computeFacePoint(Face.front, refPointFront, length);

    var refPointTop = refPointFront + DrawingConstants.listFaceVector[Face.top]![0].multScalar(-length * 3);
    faceRefPoint[Face.top] = refPointTop.copy();
    facePoint[Face.top]!.add(refPointTop.copy());
    computeFacePoint(Face.top, refPointTop, length);

    var refPointRight = refPointFront + DrawingConstants.listFaceVector[Face.front]![1].multScalar(length * 3);
    faceRefPoint[Face.right] = refPointRight.copy();
    facePoint[Face.right]!.add(refPointRight.copy());
    computeFacePoint(Face.right, refPointRight, length);

    var refPointBack = refPointTop + DrawingConstants.listFaceVector[Face.top]![0].multScalar(-length * 3);
    faceRefPoint[Face.back] = refPointBack.copy();
    facePoint[Face.back]!.add(refPointBack.copy());
    computeFacePoint(Face.back, refPointBack, length);

    var refPointBottom = refPointTop + DrawingConstants.listFaceVector[Face.front]![0].multScalar(2 * length * 3);
    faceRefPoint[Face.bottom] = refPointBottom.copy();
    facePoint[Face.bottom]!.add(refPointBottom.copy());
    computeFacePoint(Face.bottom, refPointBottom, length);

    var refPointLeft = refPointFront + DrawingConstants.listFaceVector[Face.front]![1].multScalar(-length * 3);
    faceRefPoint[Face.left] = refPointLeft.copy();
    facePoint[Face.left]!.add(refPointLeft.copy());
    computeFacePoint(Face.left, refPointLeft, length);
  }

  void paintProjectionLines(Canvas canvas, Size size, double length) {
    Paint p = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black12
      ..colorFilter = ColorFilter.mode(Colors.black12, BlendMode.srcOver);

    canvas.drawLine(
      Offset(facePoint[Face.front]!.elementAt(0).x, size.height - facePoint[Face.front]!.elementAt(0).y),
      Offset(facePoint[Face.left]!.elementAt(0).x, size.height - facePoint[Face.left]!.elementAt(0).y),
      p,
    );
    canvas.drawLine(
      Offset(facePoint[Face.top]!.elementAt(0).x, size.height - facePoint[Face.top]!.elementAt(0).y),
      Offset(facePoint[Face.left]!.elementAt(3).x, size.height - facePoint[Face.left]!.elementAt(3).y),
      p,
    );
    canvas.drawLine(
      Offset(facePoint[Face.front]!.elementAt(1).x, size.height - facePoint[Face.front]!.elementAt(1).y),
      Offset(facePoint[Face.left]!.elementAt(1).x, size.height - facePoint[Face.left]!.elementAt(1).y),
      p,
    );
    canvas.drawLine(
      Offset(facePoint[Face.top]!.elementAt(0).x, size.height - facePoint[Face.top]!.elementAt(0).y),
      Offset(facePoint[Face.back]!.elementAt(0).x, size.height - facePoint[Face.back]!.elementAt(0).y),
      p,
    );
    canvas.drawLine(
      Offset(facePoint[Face.top]!.elementAt(3).x, size.height - facePoint[Face.top]!.elementAt(3).y),
      Offset(facePoint[Face.back]!.elementAt(3).x, size.height - facePoint[Face.back]!.elementAt(3).y),
      p,
    );
    canvas.drawLine(
      Offset(facePoint[Face.right]!.elementAt(2).x, size.height - facePoint[Face.right]!.elementAt(2).y),
      Offset(facePoint[Face.back]!.elementAt(2).x, size.height - facePoint[Face.back]!.elementAt(2).y),
      p,
    );
    canvas.drawLine(
      Offset(facePoint[Face.front]!.elementAt(1).x, size.height - facePoint[Face.front]!.elementAt(1).y),
      Offset(facePoint[Face.bottom]!.elementAt(1).x, size.height - facePoint[Face.bottom]!.elementAt(1).y),
      p,
    );
    canvas.drawLine(
      Offset(facePoint[Face.front]!.elementAt(2).x, size.height - facePoint[Face.front]!.elementAt(2).y),
      Offset(facePoint[Face.bottom]!.elementAt(2).x, size.height - facePoint[Face.bottom]!.elementAt(2).y),
      p,
    );
    canvas.drawLine(
      Offset(facePoint[Face.right]!.elementAt(2).x, size.height - facePoint[Face.right]!.elementAt(2).y),
      Offset(facePoint[Face.bottom]!.elementAt(3).x, size.height - facePoint[Face.bottom]!.elementAt(3).y),
      p,
    );

    var vect = DrawingConstants.listFaceVector[Face.front]!.elementAt(0).multScalar(length * 3);
    var projStartPoint = facePoint[Face.top]!.elementAt(0).sumVector(vect);
    canvas.drawLine(
      Offset(projStartPoint.x, size.height - projStartPoint.y),
      Offset(facePoint[Face.left]!.elementAt(2).x, size.height - facePoint[Face.left]!.elementAt(2).y),
      p,
    );
    canvas.drawLine(
      Offset(projStartPoint.x, size.height - projStartPoint.y),
      Offset(facePoint[Face.bottom]!.elementAt(0).x, size.height - facePoint[Face.bottom]!.elementAt(0).y),
      p,
    );
    canvas.drawLine(
      Offset(projStartPoint.x, size.height - projStartPoint.y),
      Offset(facePoint[Face.back]!.elementAt(1).x, size.height - facePoint[Face.back]!.elementAt(1).y),
      p,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    var length = size.width / 12;
    computeAllVertices(size, length);

    for (var face in [Face.back, Face.left, Face.bottom]) {
      paintCubeFace(canvas, size, face, faceRefPoint[face]!, length);
    }

    paintProjectionLines(canvas, size, length);

    for (var face in [Face.front, Face.right, Face.top]) {
      paintCubeFace(canvas, size, face, faceRefPoint[face]!, length);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return RubikCube.colorHasChanged;
  }
}
