import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Guess the color'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const TextStyle _mainTextStyle = TextStyle(color: Colors.white);

  // final List<Color> _colors = [
  //   Colors.green,
  //   Colors.red,
  //   Colors.yellow,
  //   Colors.blue,
  //   Colors.brown,
  //   Colors.cyan
  // ];
  final Map<Color, String> _colorToName = {
    Colors.green: "green",
    Colors.red: "red",
    Colors.yellow: "yellow",
    Colors.blue: "blue",
    Colors.brown: "brown",
    Colors.cyan: "cyan"
  };

  final List<String> _colorNames = [
    "green",
    "red",
    "yellow",
    "blue",
    "brown",
    "cyan"
  ];

  final Map<String, Color> _nameToColor = {
    "green": Colors.green,
    "red": Colors.red,
    "yellow": Colors.yellow,
    "blue": Colors.blue,
    "brown": Colors.brown,
    "cyan": Colors.cyan
  };

  final Random _random = Random();
  final int timeInterval = 4;

  Timer _timer;
  int _timerTick;
  int _score = 0;
  String _currentColorText;
  Color _currentColor;
  Color _colorToDisplay;
  bool _answered = false;
  List<Color> _options = [];

  @override
  void initState() {
    super.initState();

    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, _onTimer);
    _timerTick = 0;

    _updateGame();
  }

  void _onTimer(Timer timer) {
    _timerTick++;

    if (_timerTick >= timeInterval) {
      _checkScore();
      _updateGame();
      _timerTick = 0;
    }
  }

  void _updateGame() {
    var index = _random.nextInt(_colorNames.length);
    _currentColorText = _colorNames[index];

    var filtered = _colorNames.where((c) => c != _currentColorText).take(2);
    _currentColor = _nameToColor[_currentColorText];

    _options.clear();
    _options.add(_currentColor);

    for (var n in filtered) {
      _options.add(_nameToColor[n]);
    }
    _colorToDisplay = _options[_random.nextInt(2) + 1];

    _options.shuffle();
  }

  void _checkScore() {
    if (!_answered)
      setState(() {
        _score--;
      });
    else {
      setState(() {
        _score++;
      });
      _answered = false;
    }
  }

  void _onTileTap(Color color) {
    _answered = color == _currentColor;
    _timerTick = 0; // reset timer
    _checkScore();
    _updateGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1b1e44),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1b1e44),
        elevation: 0.0,
        title: Text(widget.title),
      ),
      drawer: Drawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Which color is written?",
                style: _mainTextStyle,
                textAlign: TextAlign.start,
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Text(
                  _currentColorText,
                  style: TextStyle(fontSize: 80, color: _colorToDisplay),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                "Answer. Quickly!",
                style: _mainTextStyle,
              ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: LinearProgressIndicator(
                  backgroundColor: Color(0xFF955A82),
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFED91AD)),
                  value: 0.6,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Column(
                  children: [
                    Text(
                      "Your score",
                      style: _mainTextStyle,
                    ),
                    Text(
                      "$_score",
                      style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _getTiles(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: null,
    );
  }

  List<Widget> _getTiles() {
    List<Widget> _tiles = [];
    for (var c in _options) {
      _tiles.add(GestureDetector(
        child: ColorTile(color: c),
        onTap: () => _onTileTap(c),
      ));
    }
    return _tiles;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class ColorTile extends StatelessWidget {
  final Color color;
  const ColorTile({
    Key key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Container(
        color: color,
      ),
    );
  }
}
