import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class PlayPage extends StatefulWidget {
  final String fen;

  const PlayPage({Key? key, required this.fen}) : super(key: key);

  @override
  _PlayPageState createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late ChessBoardController chessBoardController;
  bool isToggled = false; // Toggle state
  bool isStockFishToggled = false;
  bool isEditModeEnabled = false;

  @override
  void initState() {
    super.initState();
    chessBoardController = ChessBoardController();
    chessBoardController.loadFen(widget.fen);
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

  void toggleEditMode() {
    setState(() {
      isEditModeEnabled = !isEditModeEnabled;
      // Optionally reset the chessboard or apply other changes when edit mode is toggled
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
        color: Colors.black, // Set the background color to black
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "BoardOrientation: ",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    Switch(
                      value: isToggled,
                      onChanged: (value) {
                        setState(() {
                          isToggled = value;
                          // Perform any action based on the toggle state
                        });
                      },
                      activeColor:
                          Colors.white, // Set the color when the switch is ON
                      inactiveThumbColor:
                          Colors.black, // Set the color when the switch is OFF
                    ),
                    const SizedBox(width: 60),
                    IconButton(
                      onPressed: () {
                        String newFen =
                            'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/PPPKPPPP w KQkq - 0 1'; // Replace with your FEN
                        updateFen(newFen);
                      }, // Call the new method
                      icon: const Icon(
                        Icons.edit_square,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              // Toggle Button Row
              // Display the ChessBoard
              ChessBoard(
                controller: chessBoardController,
                boardColor: BoardColor.green,
                boardOrientation: PlayerColor.white,
                enableUserMoves:
                    true, // Control user moves based on the edit mode state
              ),
              // Additional widgets can be added here
              Container(
                color: Colors.brown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
                          size: 34,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.navigate_before,
                          color: Colors.white,
                          size: 34,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                          size: 34,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                          size: 34,
                        ))
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'StockFish: ',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                    value: isStockFishToggled,
                    onChanged: (value) {
                      setState(() {
                        isStockFishToggled = value;
                        // Perform any action based on the toggle state
                      });
                    },
                    activeColor:
                        Colors.yellow, // Set the color when the switch is ON
                    inactiveThumbColor:
                        Colors.grey, // Set the color when the switch is OFF
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                color: Colors.white,
                width: 300,
                height: 90,
                child: Column(
                  children: [
                    Container(
                      width: 300,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Set your desired border color
                          // width: 2.0, // Set your desired border width
                        ),
                      ),
                      child: const Row(children: [
                        Text(
                          ' The Best Move 1:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyButton1',
                          ),
                        )
                      ]),
                    ),
                    Container(
                      width: 300,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Set your desired border color
                          // width: 2.0, // Set your desired border width
                        ),
                      ),
                      child: const Row(children: [
                        Text(
                          ' The Best Move 2:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyButton1',
                          ),
                        )
                      ]),
                    ),
                    Container(
                      width: 300,
                      height: 30,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Set your desired border color
                          // width: 2.0, // Set your desired border width
                        ),
                      ),
                      child: const Row(children: [
                        Text(
                          ' The Best Move 3:',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'MyButton1',
                          ),
                        )
                      ]),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
