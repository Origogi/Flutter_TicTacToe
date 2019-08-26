import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'TicTacToe'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum GameState { RUNNING, X_WIN, O_WIN, DRAW }

class _MyHomePageState extends State {
  String _player = "X";

  static final int BOARD_COUNT = 9;
  GameState currentGameState = GameState.RUNNING;
  Map<String, Color> _colors;

  List boardStates = new List(BOARD_COUNT);

  _MyHomePageState() {
    _init();

    _colors = new Map();
    _colors['X'] = Colors.red[100];
    _colors['O'] = Colors.blue[100];
    _colors[''] = Colors.grey[100];
  }

  void _setBoardState(int index) {
    if (boardStates[index] != '' || currentGameState != GameState.RUNNING) {
      return;
    }
    setState(() {
      boardStates[index] = _player;
      if (_player == 'X') {
        _player = 'O';
      } else {
        _player = 'X';
      }
    });

    updateGameState();
  }

  void _clear() {
    setState(() {
      _init();
    });
  }

  void _init() {
    _player = 'X';

    for (int i = 0; i < boardStates.length; i++) {
      boardStates[i] = '';
    }

    currentGameState = GameState.RUNNING;
  }

  void updateGameState() {
    setState(() {
      for (int i = 0; i < 3; i++) {
        String compared = boardStates[i * 3];
        bool equals = true;
        for (int j = 1; j < 3; j++) {
          if (compared != boardStates[i * 3 + j] ||
              boardStates[i * 3 + j] == '') {
            equals = false;
            break;
          }
        }

        if (equals) {
          if (compared == 'X') {
            currentGameState = GameState.X_WIN;
          } else {
            currentGameState = GameState.O_WIN;
          }
        }
      }

      for (int i = 0; i < 3; i++) {
        String compared = boardStates[i];
        bool equals = true;
        for (int j = 1; j < 3; j++) {
          if (compared != boardStates[i + j * 3] ||
              boardStates[i + j * 3] == '') {
            equals = false;
            break;
          }
        }

        if (equals) {
          if (compared == 'X') {
            currentGameState = GameState.X_WIN;
          } else {
            currentGameState = GameState.O_WIN;
          }
          return;
        }
      }

      bool equals = true;
      String compared = boardStates[0];

      for (int i = 0; i < 3; i++) {
        print((4 * i).toString() + '/' + compared + '/' + boardStates[4 * i]);

        if (compared != boardStates[4 * i] || boardStates[4 * i] == '') {
          equals = false;
          break;
        }
      }

      print(equals.toString());

      if (equals) {
        if (compared == 'X') {
          currentGameState = GameState.X_WIN;
        } else {
          currentGameState = GameState.O_WIN;
        }
        return;
      }

      equals = true;
      compared = boardStates[2];

      for (int i = 1; i <= 3; i++) {
        if (compared != boardStates[2 * i] || boardStates[2 * i] == '') {
          equals = false;
        }
      }

      if (equals) {
        if (compared == 'X') {
          currentGameState = GameState.X_WIN;
        } else {
          currentGameState = GameState.O_WIN;
        }
        return;
      }

      int notNullcount = boardStates.where((item) => item != '').length;

      if (notNullcount == BOARD_COUNT) {
        currentGameState = GameState.DRAW;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
        appBar: AppBar(
          title: Text('Tic Tac Toe'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                '$_player is turn',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            Expanded(
                child: GridView.count(
              crossAxisCount: 3,
              children: List.generate(BOARD_COUNT, (index) {
                return Container(
                    padding: EdgeInsets.all(5),
                    child: FlatButton(
                      color: _colors[''],
                      disabledColor: _colors[boardStates[index]],
                      child: Text(
                        boardStates[index],
                        style: Theme.of(context).textTheme.display1,
                      ),
                      onPressed: currentGameState == GameState.RUNNING &&
                              boardStates[index] == ''
                          ? () => _setBoardState(index)
                          : null,
                    ));
              }),
            )),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text('Game State'),
                  Text(currentGameState.toString().split('.').last)
                ],
              ),
            ),
            RaisedButton(
              onPressed: _clear,
              child: Text('Reset'),
            )
          ],
        ));
    return scaffold;
  }
}
