import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Tic-Tac-Toe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green[500],
          toolbarHeight: 70,
          centerTitle: true,
        ),
        body: const TicTacToe(),
      ),
    );
  }
}

class TicTacToe extends StatefulWidget {
  const TicTacToe({super.key});

  @override
  _TicTacToeState createState() => _TicTacToeState();
}

class _TicTacToeState extends State<TicTacToe> {
  final List<int> person1 = [];
  final List<int> person2 = [];

  final List<int?> buttonStates = List.filled(9, null); // To track button states

  int countMove = 0;
  bool gameEnded = false; // To track if the game has ended

  void _buttonPressed(int index) {
    if (gameEnded) return; // Don't allow moves if the game has ended
    if (buttonStates[index] != null) return; // Do nothing if button is already clicked

    setState(() {
      final num = index + 1; // Button index starts from 0, but moves are 1-9
      countMove++;
      final isPerson1 = countMove % 2 != 0;

      if(isPerson1){
        buttonStates[index]=1;
        person1.add(num);
      }else{
        buttonStates[index]=2;
        person2.add(num);
      }

      bool person1Wins = _matchChecking(person1);
      bool person2Wins = _matchChecking(person2);

      if (person1Wins || person2Wins) { //if any of the condition is true
        gameEnded = true;
        String theWinner = person1Wins ? 'Person 1' : 'Person 2';
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Winner!', style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold, letterSpacing: 1.3),),
              content: Text('$theWinner wins ✨✨',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, letterSpacing: 1.4),),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    _resetGame(); // Reset the game state
                  },
                  child: Text('Exit'),
                ),
              ],
            );
          },
        );
      }
    });
  }

  bool _matchChecking(List<int> playerMoves) {
    final List<List<int>> winningPatterns =
    [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
      [1, 5, 9],
      [3, 5, 7]
    ];

    return winningPatterns.any(
          (pattern) => pattern.every((element) => playerMoves.contains(element)),
    );
  }

  void _resetGame() {
    setState(() {
      person1.clear();
      person2.clear();
      buttonStates.fillRange(0, buttonStates.length, null); // Clear button states
      countMove = 0;
      gameEnded = false; // Reset gameEnded flag
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button(0),
                _button(1),
                _button(2),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button(3),
                _button(4),
                _button(5),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _button(6),
                _button(7),
                _button(8),
              ],
            ),
          ),
          SizedBox(height: 20), // Add spacing before the reset button
          ElevatedButton(
            onPressed: _resetGame,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black, // Background color of the reset button
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            ),
            child: Text(
              'Reset Game',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(int index) {
    return ElevatedButton(
      onPressed: () => _buttonPressed(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: _getButtonColor(index),
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), // Rounded corners
        ),
      ),
      child: Text(
        buttonStates[index] == 1 ? '️😎' : buttonStates[index] == 2 ? '🤩' : '🐼',
        style: TextStyle(fontSize: 28,),//😎😍🤩😭🥶🤡🐻‍
      ),
    );
  }

  Color _getButtonColor(int index) {
    final state = buttonStates[index];
    if (state == 1) {
      return Colors.black; // Color for person1
    } else if (state == 2) {
      return Colors.white; // Color for person2
    } else {
      return Colors.amber[300]!; // Default color for unclicked buttons
    }
  }
}
