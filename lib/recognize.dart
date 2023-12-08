import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'utils.dart';

img.Image _getResizedChessboard(File imageFile) {
  // Decode the image file to an img.Image object
  Uint8List imageBytes = imageFile.readAsBytesSync();
  img.Image? image = img.decodeImage(imageBytes);

  if (image == null) {
    throw Exception('Failed to load image');
  }

  // Resize the image to 256x256
  return img.copyResize(image,
      width: 256, height: 256, interpolation: img.Interpolation.linear);
}

// Function to get 64 tiles of the chessboard
List<img.Image> getChessboardTiles(File image, {bool useGrayscale = true}) {
  img.Image chessboard = _getResizedChessboard(image);

  List<img.Image> tiles = [];
  for (int rank = 0; rank < 8; rank++) {
    for (int file = 0; file < 8; file++) {
      img.Image tile = img.copyCrop(chessboard,
          x: file * 32, y: rank * 32, width: 32, height: 32);

      if (useGrayscale) {
        tile = img.grayscale(tile);
      }

      tiles.add(tile);
    }
  }

  return tiles;
}

Future<List<Uint8List>> processImageDataForModel(File imageFile) async {
  // Load your TFLite model
  Interpreter interpreter = await Interpreter.fromAsset('assets/model1.tflite');

  // Get input and output shapes and types
  var inputShape = interpreter.getInputTensor(0).shape;
  var inputType = interpreter.getInputTensor(0).type;
  var outputShape = interpreter.getOutputTensor(0).shape;
  var outputType = interpreter.getOutputTensor(0).type;

  // Process your image and get the tiles
  List<img.Image> tiles = getChessboardTiles(imageFile);

  // Prepare data for each tile
  List<Uint8List> processedDataList = [];
  for (var tile in tiles) {
    // Resize the tile according to the input shape of your model
    img.Image resizedTile =
        img.copyResize(tile, width: inputShape[1], height: inputShape[2]);

    // Convert tile to Uint8List (or Float32List, depending on your model input)
    Uint8List tileData = resizedTile.getBytes();

    // Add processed data to the list
    processedDataList.add(tileData);
  }

  // Close the interpreter when done
  interpreter.close();

  return processedDataList;
}

Future<String> predictChessboard(File image,
    {Map<String, dynamic> options = const {}}) async {
  // Check for 'quiet' option
  bool quiet = options.containsKey('quiet') ? options['quiet'] : false;

  var imgDataList = await processImageDataForModel(image);
  List predictions = [];
  double confidence = 1.0;

  for (int i = 0; i < 64; i++) {
    var tileImgData = imgDataList[i];
    var prediction = await predictTile(tileImgData); // Implement predictTile
    String fenChar = prediction.item1;
    double probability = prediction.item2;

    predictions.add(prediction);
  }

  String predictedFen = compressedFen(// Implement compressedFen
      [
    for (var r in _reshape(predictions.map((p) => p.item1).toList(), 8, 8))
      r.join()
  ].join('/'));

  return predictedFen;
}

Future<Tuple2<String, double>> predictTile(Uint8List tileImgData) async {
  const String fenChars = '1RNBQKPrnbqkp';
  // Load your TFLite model
  final interpreter = await Interpreter.fromAsset('assets/model1.tflite');

  // Prepare the input for the model
  // The input shape and type depend on your model's requirements
  var inputShape = interpreter.getInputTensor(0).shape;
  var inputType = interpreter.getInputTensor(0).type;

  // Process the tile image data as per your model's input requirements
  // This might involve resizing, reshaping, normalizing, etc.

  // Perform inference
  var output = List.filled(interpreter.getOutputTensor(0).shape[1], 0.0,
      growable: false);
  interpreter.run(tileImgData, 0);

  // Find the index of the max probability
  double maxProbability =
      output.reduce((curr, next) => curr > next ? curr : next);
  int index = output.indexOf(maxProbability);

  // Get the corresponding FEN character
  String fenChar = fenChars[index];

  // Close the interpreter when done
  interpreter.close();

  return Tuple2<String, double>(fenChar, maxProbability);
}

class Tuple2<T1, T2> {
  final T1 item1;
  final T2 item2;

  Tuple2(this.item1, this.item2);
}

List<List<T>> _reshape<T>(List<T> list, int rows, int cols) {
  List<List<T>> reshapedList = [];
  for (int i = 0; i < rows; i++) {
    int start = i * cols;
    int end = start + cols;
    reshapedList.add(list.sublist(start, end));
  }
  return reshapedList;
}
