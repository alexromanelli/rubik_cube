import 'dart:ui';

import 'package:rubik_cube/rubik_cube.dart';

import 'drawing_constants.dart';

class Point2D {
  double x;
  double y;

  Point2D(this.x, this.y);

  Point2D copy() {
    return Point2D(x, y);
  }

  void sumScalar(double s) {
    x += s;
    y += s;
  }

  void multScalarInPlace(double s) {
    x *= s;
    y *= s;
  }

  Point2D multScalar(double s) {
    var point = Point2D(x, y);
    point.x *= s;
    point.y *= s;
    return point;
  }

  void sumVectorInPlace(Vector2D v) {
    x += v.endPoint.x;
    y += v.endPoint.y;
  }

  Point2D sumVector(Vector2D v) {
    var point = Point2D(x, y);
    point.x += v.endPoint.x;
    point.y += v.endPoint.y;
    return point;
  }

  Point2D operator +(Object other) {
    var point = Point2D(x, y);
    return point.sumVector(other as Vector2D);
  }
}

class Vector2D {
  Point2D endPoint;

  Vector2D(this.endPoint);

  void sumScalarInPlace(double s) {
    endPoint.x += s;
    endPoint.y += s;
  }

  void multScalarInPlace(double s) {
    endPoint.x *= s;
    endPoint.y *= s;
  }

  Vector2D sumScalar(double s) {
    Vector2D v = Vector2D(endPoint.copy());
    v.endPoint.x += s;
    v.endPoint.y += s;
    return v;
  }

  Vector2D multScalar(double s) {
    Vector2D v = Vector2D(endPoint.copy());
    v.endPoint.x *= s;
    v.endPoint.y *= s;
    return v;
  }

  void sumVector(Vector2D v) {
    endPoint.x += v.endPoint.x;
    endPoint.y += v.endPoint.y;
  }
}

Map<Face, Map<int, Color>> facePieceColor = {
  Face.front: {
    0: DrawingConstants.pieceColor[ColorName.white]!,
    1: DrawingConstants.pieceColor[ColorName.yellow]!,
    2: DrawingConstants.pieceColor[ColorName.yellow]!,
    3: DrawingConstants.pieceColor[ColorName.blue]!,
    4: DrawingConstants.pieceColor[ColorName.blue]!,
    5: DrawingConstants.pieceColor[ColorName.red]!,
    6: DrawingConstants.pieceColor[ColorName.orange]!,
    7: DrawingConstants.pieceColor[ColorName.blue]!,
    8: DrawingConstants.pieceColor[ColorName.red]!,
  },
  Face.top: {
    //////////////////////////// -----> CORRIGIR AS CORES DAS OUTRAS FACES
    0: DrawingConstants.pieceColor[ColorName.white]!,
    1: DrawingConstants.pieceColor[ColorName.yellow]!,
    2: DrawingConstants.pieceColor[ColorName.yellow]!,
    3: DrawingConstants.pieceColor[ColorName.blue]!,
    4: DrawingConstants.pieceColor[ColorName.blue]!,
    5: DrawingConstants.pieceColor[ColorName.red]!,
    6: DrawingConstants.pieceColor[ColorName.orange]!,
    7: DrawingConstants.pieceColor[ColorName.blue]!,
    8: DrawingConstants.pieceColor[ColorName.red]!,
  },
  Face.right: {
    0: DrawingConstants.pieceColor[ColorName.white]!,
    1: DrawingConstants.pieceColor[ColorName.yellow]!,
    2: DrawingConstants.pieceColor[ColorName.yellow]!,
    3: DrawingConstants.pieceColor[ColorName.blue]!,
    4: DrawingConstants.pieceColor[ColorName.blue]!,
    5: DrawingConstants.pieceColor[ColorName.red]!,
    6: DrawingConstants.pieceColor[ColorName.orange]!,
    7: DrawingConstants.pieceColor[ColorName.blue]!,
    8: DrawingConstants.pieceColor[ColorName.red]!,
  },
  Face.back: {
    0: DrawingConstants.pieceColor[ColorName.white]!,
    1: DrawingConstants.pieceColor[ColorName.yellow]!,
    2: DrawingConstants.pieceColor[ColorName.yellow]!,
    3: DrawingConstants.pieceColor[ColorName.blue]!,
    4: DrawingConstants.pieceColor[ColorName.blue]!,
    5: DrawingConstants.pieceColor[ColorName.red]!,
    6: DrawingConstants.pieceColor[ColorName.orange]!,
    7: DrawingConstants.pieceColor[ColorName.blue]!,
    8: DrawingConstants.pieceColor[ColorName.red]!,
  },
  Face.bottom: {
    0: DrawingConstants.pieceColor[ColorName.white]!,
    1: DrawingConstants.pieceColor[ColorName.yellow]!,
    2: DrawingConstants.pieceColor[ColorName.yellow]!,
    3: DrawingConstants.pieceColor[ColorName.blue]!,
    4: DrawingConstants.pieceColor[ColorName.blue]!,
    5: DrawingConstants.pieceColor[ColorName.red]!,
    6: DrawingConstants.pieceColor[ColorName.orange]!,
    7: DrawingConstants.pieceColor[ColorName.blue]!,
    8: DrawingConstants.pieceColor[ColorName.red]!,
  },
  Face.left: {
    0: DrawingConstants.pieceColor[ColorName.white]!,
    1: DrawingConstants.pieceColor[ColorName.yellow]!,
    2: DrawingConstants.pieceColor[ColorName.yellow]!,
    3: DrawingConstants.pieceColor[ColorName.blue]!,
    4: DrawingConstants.pieceColor[ColorName.blue]!,
    5: DrawingConstants.pieceColor[ColorName.red]!,
    6: DrawingConstants.pieceColor[ColorName.orange]!,
    7: DrawingConstants.pieceColor[ColorName.blue]!,
    8: DrawingConstants.pieceColor[ColorName.red]!,
  },
};
