
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'splash_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'payment.dart';

import 'recognize.dart';

void main() {
  runApp(const MaterialApp(home: SplashScreen()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'The Best Chess Player'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      File imageFile = File(image.path);
      String genFen = await predictChessboard(imageFile);
      print(genFen);

      // List<img.Image> tiles = getChessboardTiles(imageFile);
      // Uint8List firstTileBytes = img.encodePng(tiles[3]);

      // // Write the Uint8List to a temporary file
      // String tempPath = (await getTemporaryDirectory()).path;
      // File tempFile = File('$tempPath/temp_tile.png');
      // await tempFile.writeAsBytes(firstTileBytes);

      // Navigate to the new page
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => ImageDisplayPage(imageFile: imageFile),
      //   ),
      // );
    }
  }

  ChessBoardController controller = ChessBoardController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Stack(
              alignment: Alignment
                  .center, // Adjust this for the text position on the image
              children: [
                Image(image: AssetImage('assets/minimal_chess1.png')),
                Padding(
                  padding: EdgeInsets.only(bottom: 150.0),
                  child: Text(
                    'AI Chess',
                    style: TextStyle(
                        fontSize: 24, // Adjust font size as needed
                        color: Colors
                            .white, // Choose a color that contrasts with the image
                        fontWeight: FontWeight.bold,
                        fontFamily: 'MyCustomFont'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            // This will fill the rest of the screen
            child: Container(
              color: Colors.blueGrey[400],
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize
                      .min, // Constrain the column size to its children
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54, // Background color
                        foregroundColor: Colors.white, // Text color
                        minimumSize: const Size(170, 50),
                        maximumSize: const Size(200, 50), // Size
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(50), // Rounded corners
                        ),
                        elevation: 5, // Shadow
                      ),
                      onPressed: () {
                        _pickImage(ImageSource.camera);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize
                            .min, // Ensures the Row only takes necessary space
                        children: [
                          Icon(Icons.camera_alt_outlined), // The icon
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            'Take a picture',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyButton1'),
                          ), // The text
                        ],
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing between buttons
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black54, // Background color
                        foregroundColor: Colors.white, // Text color
                        minimumSize: const Size(170, 50),
                        maximumSize: const Size(200, 50), // Size
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(50), // Rounded corners
                        ),
                        elevation: 5, // Shadow
                      ),
                      onPressed: () {
                        _pickImage(ImageSource.gallery);
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize
                            .min, // Ensures the Row only takes necessary space
                        children: [
                          Icon(Icons.photo), // The icon
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            'From gallery',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyButton1'),
                          ), // The text
                        ],
                      ),
                    ),
                    const SizedBox(height: 10), // Spacing between buttons
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[600], // Background color
                        foregroundColor: Colors.white, // Text color
                        minimumSize: const Size(170, 50),
                        maximumSize: const Size(200, 50), // Size
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(50), // Rounded corners
                        ),
                        elevation: 5, // Shadow
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const PaymentPage(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize
                            .min, // Ensures the Row only takes necessary space
                        children: [
                          Icon(Icons.photo), // The icon
                          SizedBox(width: 8), // Space between icon and text
                          Text(
                            'Setup Billing',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'MyButton1'),
                          ), // The text
                        ],
                      ),
                    ),
                    // Add more buttons here if needed
                  ],
                ),
              ),
              // Add other content or widgets here as necessary
            ),
          ),
        ],
      ),
    );
  }
}
