import 'dart:math';
import 'dart:ui';

import 'package:rubik_cube/cube_plotter/util.dart';
import 'package:rubik_cube/rubik_cube.dart';

class DrawingConstants {
  static final double _angle1 = 90;
  static final double _angle2 = -15;
  static final double _angle3 = 35;

  static final double frontAngle1 = -_angle1;
  static final double frontAngle2 = _angle2;
  static final double frontAngle3 = _angle1;
  static final double topAngle1 = 180 + _angle3;
  static final double topAngle2 = _angle2;
  static final double topAngle3 = _angle3;
  static final double rightAngle1 = -_angle1;
  static final double rightAngle2 = _angle3;
  static final double rightAngle3 = _angle1;
  static final double backAngle1 = -_angle1;
  static final double backAngle2 = _angle2;
  static final double backAngle3 = _angle1;
  static final double bottomAngle1 = 180 + _angle3;
  static final double bottomAngle2 = _angle2;
  static final double bottomAngle3 = _angle3;
  static final double leftAngle1 = -_angle1;
  static final double leftAngle2 = _angle3;
  static final double leftAngle3 = _angle1;

  static final listFaces = [Face.back, Face.bottom, Face.left, Face.front, Face.top, Face.right];

  static final mapColorNameToFace = <ColorName, Face>{
    ColorName.blue: Face.front,
    ColorName.red: Face.right,
    ColorName.green: Face.back,
    ColorName.orange: Face.left,
    ColorName.yellow: Face.top,
    ColorName.white: Face.bottom,
  };

  static final listFaceAngle = <Face, List<double>>{
    Face.front: [frontAngle1, frontAngle2, frontAngle3],
    Face.top: [topAngle1, topAngle2, topAngle3],
    Face.right: [rightAngle1, rightAngle2, rightAngle3],
    Face.back: [backAngle1, backAngle2, backAngle3],
    Face.bottom: [bottomAngle1, bottomAngle2, bottomAngle3],
    Face.left: [leftAngle1, leftAngle2, leftAngle3],
  };

  static final listFaceVector = <Face, List<Vector2D>>{
    Face.front: [
      Vector2D(Point2D(cos(listFaceAngle[Face.front]![0] * pi / 180), sin(listFaceAngle[Face.front]![0] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.front]![1] * pi / 180), sin(listFaceAngle[Face.front]![1] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.front]![2] * pi / 180), sin(listFaceAngle[Face.front]![2] * pi / 180))),
    ],
    Face.top: [
      Vector2D(Point2D(cos(listFaceAngle[Face.top]![0] * pi / 180), sin(listFaceAngle[Face.top]![0] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.top]![1] * pi / 180), sin(listFaceAngle[Face.top]![1] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.top]![2] * pi / 180), sin(listFaceAngle[Face.top]![2] * pi / 180))),
    ],
    Face.right: [
      Vector2D(Point2D(cos(listFaceAngle[Face.right]![0] * pi / 180), sin(listFaceAngle[Face.right]![0] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.right]![1] * pi / 180), sin(listFaceAngle[Face.right]![1] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.right]![2] * pi / 180), sin(listFaceAngle[Face.right]![2] * pi / 180))),
    ],
    Face.back: [
      Vector2D(Point2D(cos(listFaceAngle[Face.back]![0] * pi / 180), sin(listFaceAngle[Face.back]![0] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.back]![1] * pi / 180), sin(listFaceAngle[Face.back]![1] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.back]![2] * pi / 180), sin(listFaceAngle[Face.back]![2] * pi / 180))),
    ],
    Face.bottom: [
      Vector2D(Point2D(cos(listFaceAngle[Face.bottom]![0] * pi / 180), sin(listFaceAngle[Face.bottom]![0] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.bottom]![1] * pi / 180), sin(listFaceAngle[Face.bottom]![1] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.bottom]![2] * pi / 180), sin(listFaceAngle[Face.bottom]![2] * pi / 180))),
    ],
    Face.left: [
      Vector2D(Point2D(cos(listFaceAngle[Face.left]![0] * pi / 180), sin(listFaceAngle[Face.left]![0] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.left]![1] * pi / 180), sin(listFaceAngle[Face.left]![1] * pi / 180))),
      Vector2D(Point2D(cos(listFaceAngle[Face.left]![2] * pi / 180), sin(listFaceAngle[Face.left]![2] * pi / 180))),
    ],
  };

  static final colorNameByIndex = <int, ColorName>{
    0: ColorName.blue,
    1: ColorName.red,
    2: ColorName.green,
    3: ColorName.orange,
    4: ColorName.white,
    5: ColorName.yellow,
  };

  static final Map<ColorName, Color> pieceColor = const {
    ColorName.white: Color.fromRGBO(255, 255, 255, 1.0), // white
    ColorName.yellow: Color.fromRGBO(255, 255, 0, 1.0), // yellow
    ColorName.red: Color.fromRGBO(201, 0, 0, 1.0), // red
    ColorName.orange: Color.fromRGBO(255, 124, 0, 1.0), // orange
    ColorName.green: Color.fromRGBO(0, 255, 0, 1.0), // green
    ColorName.blue: Color.fromRGBO(0, 126, 255, 1.0), // blue
    ColorName.none: Color.fromRGBO(165, 165, 165, 1.0), // none
  };

  static Map<Face, List<List<List<double>>>> pieceCoordinates = {
    Face.front: [
      [
        [0.908, 49.774],
        [19.912, 53.138],
        [19.912, 34.133],
        [0.908, 30.769],
      ],
      [
        [19.912, 53.138],
        [38.917, 56.502],
        [38.917, 37.498],
        [19.912, 34.133],
      ],
      [
        [38.917, 56.502],
        [57.922, 59.867],
        [57.922, 40.862],
        [38.917, 37.498],
      ],
      [
        [0.908, 68.778],
        [19.912, 72.143],
        [19.912, 53.138],
        [0.908, 49.774],
      ],
      [
        [19.912, 72.143],
        [38.917, 75.507],
        [38.917, 56.502],
        [19.912, 53.138],
      ],
      [
        [38.917, 75.507],
        [57.922, 78.871],
        [57.922, 59.867],
        [38.917, 56.502],
      ],
      [
        [0.908, 87.783],
        [19.912, 91.147],
        [19.912, 72.143],
        [0.908, 68.778],
      ],
      [
        [19.912, 91.147],
        [38.917, 94.512],
        [38.917, 75.507],
        [19.912, 72.143],
      ],
      [
        [38.917, 94.512],
        [57.922, 97.876],
        [57.922, 78.871],
        [38.917, 75.507],
      ],
    ],
    Face.top: [
      [
        [27.529, 10.250],
        [46.521, 13.612],
        [59.828, 3.337],
        [40.836, 0.000],
      ],
      [
        [46.521, 13.612],
        [65.513, 16.974],
        [78.820, 6.699],
        [59.828, 3.337],
      ],
      [
        [65.513, 16.974],
        [84.505, 20.336],
        [97.812, 10.061],
        [78.820, 6.699],
      ],
      [
        [14.223, 20.525],
        [33.215, 23.887],
        [46.521, 13.612],
        [27.529, 10.250],
      ],
      [
        [33.215, 23.887],
        [52.207, 27.249],
        [65.513, 16.974],
        [46.521, 13.612],
      ],
      [
        [52.207, 27.249],
        [71.199, 30.611],
        [84.505, 20.336],
        [65.513, 16.974],
      ],
      [
        [0.916, 30.800],
        [19.908, 34.162],
        [33.215, 23.887],
        [14.223, 20.525],
      ],
      [
        [19.908, 34.162],
        [38.900, 37.524],
        [52.207, 27.249],
        [33.215, 23.887],
      ],
      [
        [38.900, 37.524],
        [57.892, 40.887],
        [71.199, 30.611],
        [52.207, 27.249],
      ],
    ],
    Face.right: [
      [
        [58.030, 59.725],
        [71.243, 49.520],
        [71.293, 30.453],
        [58.080, 40.658],
      ],
      [
        [71.243, 49.520],
        [84.457, 39.314],
        [84.507, 20.247],
        [71.293, 30.453],
      ],
      [
        [84.457, 39.314],
        [97.670, 29.109],
        [97.720, 10.042],
        [84.507, 20.247],
      ],
      [
        [57.980, 78.792],
        [71.193, 68.586],
        [71.243, 49.520],
        [58.030, 59.725],
      ],
      [
        [71.193, 68.586],
        [84.407, 58.381],
        [84.457, 39.314],
        [71.243, 49.520],
      ],
      [
        [84.407, 58.381],
        [97.620, 48.175],
        [97.670, 29.109],
        [84.457, 39.314],
      ],
      [
        [57.930, 97.858],
        [71.143, 87.653],
        [71.193, 68.586],
        [57.980, 78.792],
      ],
      [
        [71.143, 87.653],
        [84.357, 77.448],
        [84.407, 58.381],
        [71.193, 68.586],
      ],
      [
        [84.357, 77.448],
        [97.570, 67.242],
        [97.620, 48.175],
        [84.407, 58.381],
      ],
    ],
    Face.back: [
      [
        [0.108, 137.977],
        [18.820, 134.656],
        [18.812, 115.356],
        [0.100, 118.676],
      ],
      [
        [18.820, 134.656],
        [37.533, 131.335],
        [37.525, 112.035],
        [18.812, 115.356],
      ],
      [
        [37.533, 131.335],
        [56.245, 128.015],
        [56.237, 108.714],
        [37.525, 112.035],
      ],
      [
        [0.116, 157.276],
        [18.828, 153.956],
        [18.820, 134.656],
        [0.108, 137.976],
      ],
      [
        [18.828, 153.956],
        [37.540, 150.635],
        [37.532, 131.335],
        [18.820, 134.656],
      ],
      [
        [37.540, 150.635],
        [56.253, 147.315],
        [56.245, 128.015],
        [37.532, 131.335],
      ],
      [
        [0.124, 176.576],
        [18.836, 173.256],
        [18.828, 153.956],
        [0.116, 157.276],
      ],
      [
        [18.836, 173.256],
        [37.548, 169.935],
        [37.540, 150.635],
        [18.828, 153.956],
      ],
      [
        [37.548, 169.935],
        [56.261, 166.615],
        [56.253, 147.315],
        [37.540, 150.635],
      ],
    ],
    Face.bottom: [
      [
        [12.525, 187.851],
        [31.187, 184.542],
        [18.786, 173.152],
        [0.124, 176.460],
      ],
      [
        [31.187, 184.543],
        [49.849, 181.234],
        [37.448, 169.843],
        [18.786, 173.152],
      ],
      [
        [49.849, 181.234],
        [68.511, 177.926],
        [56.109, 166.535],
        [37.448, 169.843],
      ],
      [
        [24.926, 199.242],
        [43.588, 195.933],
        [31.187, 184.542],
        [12.525, 187.851],
      ],
      [
        [43.588, 195.933],
        [62.250, 192.625],
        [49.849, 181.234],
        [31.187, 184.543],
      ],
      [
        [62.250, 192.625],
        [80.912, 189.316],
        [68.511, 177.926],
        [49.849, 181.234],
      ],
      [
        [37.327, 210.633],
        [55.989, 207.324],
        [43.588, 195.933],
        [24.926, 199.242],
      ],
      [
        [55.989, 207.324],
        [74.651, 204.016],
        [62.250, 192.625],
        [43.588, 195.933],
      ],
      [
        [74.651, 204.016],
        [93.313, 200.707],
        [80.912, 189.316],
        [62.250, 192.625],
      ],
    ],
    Face.left: [
      [
        [56.216, 128.015],
        [68.658, 139.322],
        [68.650, 120.035],
        [56.208, 108.728],
      ],
      [
        [68.658, 139.322],
        [81.100, 150.628],
        [81.092, 131.341],
        [68.650, 120.035],
      ],
      [
        [81.099, 150.556],
        [93.410, 161.821],
        [93.403, 142.605],
        [81.091, 131.340],
      ],
      [
        [56.223, 147.303],
        [68.666, 158.609],
        [68.658, 139.322],
        [56.215, 128.015],
      ],
      [
        [68.666, 158.610],
        [81.108, 169.916],
        [81.100, 150.628],
        [68.658, 139.322],
      ],
      [
        [81.107, 169.853],
        [93.401, 181.125],
        [93.393, 161.898],
        [81.099, 150.627],
      ],
      [
        [56.231, 166.590],
        [68.674, 177.897],
        [68.666, 158.609],
        [56.223, 147.303],
      ],
      [
        [68.674, 177.897],
        [81.116, 189.203],
        [81.108, 169.916],
        [68.666, 158.610],
      ],
      [
        [81.115, 189.214],
        [93.401, 200.527],
        [93.393, 181.229],
        [81.107, 169.915],
      ],
    ],
  };
}
