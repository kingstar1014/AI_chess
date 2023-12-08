import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'PlayPage.dart';

class EditPage extends StatefulWidget {
  final File imageFile;

  const EditPage({Key? key, required this.imageFile}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late ChessBoardController chessBoardController;
  bool isToggled = false; // Toggle state
  bool isStockFishToggled = false;
  bool isEditModeEnabled = false;
  bool isRemove = false;

  BoardPieceType? pickedPieceType;
  PlayerColor? pickedPieceColor;
  final colors = [
    PlayerColor.black,
    PlayerColor.black,
    PlayerColor.black,
    PlayerColor.black,
    PlayerColor.black,
    PlayerColor.black,
    PlayerColor.black,
    PlayerColor.white,
    PlayerColor.white,
    PlayerColor.white,
    PlayerColor.white,
    PlayerColor.white,
    PlayerColor.white,
    PlayerColor.white
  ];
  final types = [
    BoardPieceType.King,
    BoardPieceType.Queen,
    BoardPieceType.Rook,
    BoardPieceType.Bishop,
    BoardPieceType.Knight,
    BoardPieceType.Pawn,
    null,
    BoardPieceType.King,
    BoardPieceType.Queen,
    BoardPieceType.Rook,
    BoardPieceType.Bishop,
    BoardPieceType.Knight,
    BoardPieceType.Pawn,
    null,
  ];

  // Maintain the selected button index
  int selectedButtonIndex = -1;

  // Define button data
  final List<ButtonData> buttons = [
    ButtonData('assets/Chess_kdt45.svg'),
    ButtonData('assets/Chess_qdt45.svg'),
    ButtonData('assets/Chess_rdt45.svg'),
    ButtonData('assets/Chess_bdt45.svg'),
    ButtonData('assets/Chess_ndt45.svg'),
    ButtonData('assets/Chess_pdt45.svg'),
    ButtonData(Icons.highlight_off_sharp), // Seventh button
    ButtonData('assets/Chess_klt45.svg'),
    ButtonData('assets/Chess_qlt45.svg'),
    ButtonData('assets/Chess_rlt45.svg'),
    ButtonData('assets/Chess_blt45.svg'),
    ButtonData('assets/Chess_nlt45.svg'),
    ButtonData('assets/Chess_plt45.svg'),
    ButtonData(Icons.replay_sharp), // Last button
  ];

  @override
  void initState() {
    super.initState();
    chessBoardController = ChessBoardController();
    // setupInitialPositions();
  }

  @override
  void dispose() {
    chessBoardController.dispose();
    super.dispose();
  }

  void updateFen(String newFen) {
    chessBoardController.loadFen(newFen);
  }

  void rePiece(String square) {
    chessBoardController.removePiece(square);
  }

  void put_piece1() {
    chessBoardController.putPiece(pickedPieceType!, "e2", pickedPieceColor!);
  }

  void toggleEditMode() {
    setState(() {
      isEditModeEnabled = !isEditModeEnabled;
      // Optionally reset the chessboard or apply other changes when edit mode is toggled
    });
  }

  // Handle button tap
  void onButtonTap(int index) {
    setState(() {
      if (index != 13) {
        if (selectedButtonIndex == index) {
          selectedButtonIndex = -1;
          pickedPieceColor = null;
          pickedPieceType = null;
          if (index == 6) {
            isRemove = false;
          }
        } else {
          selectedButtonIndex = index;
          if (index == 6) {
            isRemove = true;
          } else {
            isRemove = false;
          }
          pickedPieceColor = colors[index];
          pickedPieceType = types[index];
        }
      } else {
        selectedButtonIndex = -1;
        isRemove = false;
        pickedPieceColor = null;
        pickedPieceType = null;
        chessBoardController.loadFen(
            'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Analyze the board'),
      ),
      body: Container(
        // Wrap the content with a Container
        // color: Colors.blueGrey[600], // Set the background color to black
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/minimal_chess2.png'), // Replace with your image path
            fit: BoxFit.cover, // Adjust the fit based on your preference
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Edit Board',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'MyButton1',
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              Container(
                  color: Colors.brown,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        7, // Number of buttons in the top row
                        (index) => Row(
                          children: [
                            buildIconButton(index, buttons[index]),
                            const SizedBox(
                                width:
                                    8.0), // Add a gap of 8.0 units between buttons
                          ],
                        ),
                      ),
                    ),
                  )),
              // Bottom row with 7 buttons
              Container(
                  color: Colors.brown,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        7, // Number of buttons in the bottom row
                        (index) => Row(
                          children: [
                            buildIconButton(index + 7, buttons[index + 7]),
                            const SizedBox(
                                width:
                                    8.0), // Add a gap of 8.0 units between buttons
                          ],
                        ),
                      ),
                    ),
                  )),

              // Display the ChessBoard
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return GestureDetector(
                    onTapUp: (TapUpDetails details) {
                      final RenderBox renderBox =
                          context.findRenderObject() as RenderBox;
                      final localPosition =
                          renderBox.globalToLocal(details.globalPosition);
                      final squareSize = constraints.maxWidth /
                          8; // Assumes a standard chessboard size

                      final int fileIndex =
                          (localPosition.dx / squareSize).floor();
                      final int rankIndex =
                          7 - (localPosition.dy / squareSize).floor();

                      final List<String> files = [
                        'a',
                        'b',
                        'c',
                        'd',
                        'e',
                        'f',
                        'g',
                        'h'
                      ];
                      final String clickedSquare =
                          files[fileIndex] + (rankIndex + 1).toString();
                      if (isRemove) {
                        chessBoardController.removePiece(clickedSquare);
                      } else {
                        chessBoardController.putPiece(
                            pickedPieceType!, clickedSquare, pickedPieceColor!);
                      }

                      // Now you have the clicked square in 'clickedSquare'
                      print("Clicked square: $clickedSquare");
                    },
                    child: ChessBoard(
                      controller: chessBoardController,
                      boardColor: BoardColor.green,
                      boardOrientation: PlayerColor.white,
                      enableUserMoves: true,
                    ),
                  );
                },
              ),

              // Additional widgets can be added here

              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800], // Background color
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
                      String currentFen = chessBoardController
                          .getFen(); // Get the current FEN from the chessboard controller

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlayPage(fen: currentFen),
                        ),
                      );
                    },
                    child: const Row(
                      mainAxisSize: MainAxisSize
                          .min, // Ensures the Row only takes necessary space
                      children: [
                        // Space between icon and text
                        Text(
                          'Start the Game',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyButton1',
                          ),
                        ), // The text
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a circular IconButton with dynamic color based on selection
  Widget buildIconButton(int index, ButtonData buttonData) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selectedButtonIndex == index
            ? Colors.blue // Change color if selected
            : Colors.white,
      ),
      child: IconButton(
        onPressed: () {
          print(index);
          onButtonTap(index); // Handle button tap
        },
        icon: buttonData.iconAsset is IconData // Check if it's an IconData
            ? Icon(
                buttonData.iconAsset,
                color: Colors.brown,
                size: 20,
              )
            : SvgPicture.asset(
                buttonData.iconAsset, // Assuming it's a String for SVG asset
                width: 30, // Set the desired width
                height: 30, // Set the desired height
              ),
      ),
    );
  }
}

class ButtonData {
  final dynamic iconAsset; // Use dynamic to accept both IconData and String

  ButtonData(this.iconAsset);
}
