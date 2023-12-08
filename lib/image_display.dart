import 'package:flutter/material.dart';
import 'dart:io';


import 'edit_screen.dart';

class ImageDisplayPage extends StatelessWidget {
  final File imageFile;
  final double topPadding;
  final double bottomPadding;

  const ImageDisplayPage({
    Key? key,
    required this.imageFile,
    this.topPadding = 20.0,
    this.bottomPadding = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 10;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Selected Image'),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              'assets/minimal_chess2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content Column
          Positioned(
            top: topPadding,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Container(
                width: screenWidth,
                height: screenWidth,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: Colors.teal,
                    width: 7.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(0.0)),
                  child: Container(
                    color: Colors.black,
                    child: Center(
                      child: Image.file(
                        imageFile,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Positioned Button at the Bottom
          Positioned(
            bottom: bottomPadding,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black54,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(170, 50),
                  maximumSize: const Size(200, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  elevation: 5, // Shadow
                ),
                onPressed: () async {
                  // List<img.Image> tiles = getChessboardTiles(imageFile);
                  // Uint8List firstTileBytes = img.encodePng(tiles[0]);

                  // // Write the Uint8List to a temporary file
                  // String tempPath = (await getTemporaryDirectory()).path;
                  // File tempFile = File('$tempPath/temp_tile.png');
                  // await tempFile.writeAsBytes(firstTileBytes);

                  // Navigate to EditPage with the temporary file
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => EditPage(imageFile: imageFile),
                    ),
                  );
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.casino),
                    SizedBox(width: 8),
                    Text(
                      'Scan the image',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MyButton1',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
