import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final int maxCount = 10;
  int _counter = 10;
  //Timer _timer;

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
      animationBehavior: AnimationBehavior.preserve,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.linear).flipped,
      reverseCurve: Curves.fastOutSlowIn,
    )..addStatusListener((AnimationStatus status) {
        print(status);
        if (status == AnimationStatus.dismissed) _controller.value = 1;
        //   _controller.forward();
        // else if (status == AnimationStatus.completed) _controller.reverse();
      });
  }

  void startTimer() {
    // const oneSec = const Duration(seconds: 1);
    // if (_timer.isActive) return;
    // _timer = new Timer.periodic(
    //     oneSec,
    //     (Timer timer) => setState(() {
    //           if (_counter < 1) {
    //             timer.cancel();
    //             _counter = maxCount;
    //           } else {
    //             _counter--;
    //           }
    //         }));
    print("CLICK");
    _controller.reverse(from: 1);
  }

  @override
  void dispose() {
    _controller.stop();
    //  _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Column(
                  children: <Widget>[
                    LinearProgressIndicator(
                      value: _animation.value,
                    ),
                    Padding(
                      child: _controller.status != AnimationStatus.completed
                          ? null
                          : FloatingActionButton(
                              onPressed: startTimer,
                              tooltip: 'Increment',
                              child: Icon(Icons.add),
                            ),
                      padding: const EdgeInsets.all(5),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: null,
    );
  }
}
