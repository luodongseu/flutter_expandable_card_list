import 'package:flutter/material.dart';
import 'package:flutter_expand_cards/flutter_expand_cards.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have s the buttxxon this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            ExpandableCards(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

///
/// 可扩展的卡片列表，效果参考iPhone的提醒事项APP
///
/// @author luodongseu@github.com
///
class ExpandableCards extends StatefulWidget {
  @override
  _ExpandableCardsState createState() => _ExpandableCardsState();
}

class _ExpandableCardsState extends State<ExpandableCards>
    with TickerProviderStateMixin {
  bool _lockScroll = false;
  double _currentValue = 0.0;
  double _currentPos = 0.0;
  double _swiperWidth;
  double _swiperHeight;
  Animation<double> _animation;
  AnimationController _animationController;

  @override
  void initState() {
    print('xxxxx');
    _animationController = new AnimationController(vsync: this, value: 0.0);
    Tween<double> tween = new Tween(begin: 0.0, end: 1.0);
    _animation = tween.animate(_animationController);
    super.initState();
  }

  @override
  void dispose() {
//    widget.controller.removeListener(_onController);
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(_getSize);
    super.didChangeDependencies();
  }

  void _getSize(_) {
    afterRender();
  }

  @mustCallSuper
  void afterRender() {
    RenderObject renderObject = context.findRenderObject();
    Size size = renderObject.paintBounds.size;
    _swiperWidth = size.width;
    _swiperHeight = size.height;
    setState(() {});
  }

  void _onPanEnd(DragEndDetails details) {
    if (_lockScroll) return;

    double velocity = details.velocity.pixelsPerSecond.dy;
  }

  void _onPanStart(DragStartDetails details) {
    if (_lockScroll) return;
    _currentValue = _animationController.value;
    _currentPos = details.globalPosition.dy;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_lockScroll) return;
    double value = _currentValue +
        (details.globalPosition.dy - _currentPos) / _swiperWidth / 2;
    _animationController.value = value;
  }

  buildItem(int index, double animationValue) {
    double offset = index * 30.0 + 10 * animationValue;
    print('offset $offset');
    return new Opacity(
      opacity: 1.0,
      child: new Transform.rotate(
        angle: 0.0,
        child: new Transform.translate(
          // key: new ValueKey<int>(index + i),
          offset: new Offset(0, offset),
          child: new Transform.scale(
            scale: 1.0,
            // alignment: Alignment.centerLeft,
            child: new SizedBox(
              width: 300,
              height: 220,
              child: new Container(
                padding: EdgeInsets.all(32.0),
                height: 60,
                color: Colors.purple.withOpacity(index / 8),
                child: new SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Text('''
                  x
                  x
                  x
                  x
                  x
                  x
                  x
                  '''),
                )
              ),
            ),
          ),
        ),
      ),
    );
    // return Container();
  }

  @override
  Widget build(BuildContext context) {
    print(_animation);
    if (_animation == null) {
      return new Container();
    }
    double animationValue = _animation?.value ?? 0;
    return Container(
      width: 200,
      height: 400,
      color: Colors.red.withOpacity(0.2),
      child: new SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: new GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: _onPanStart,
          onPanEnd: _onPanEnd,
          onPanUpdate: _onPanUpdate,
          child: new Container(
            height: 400 + 100.0,
            child: new AnimatedBuilder(
              animation: _animationController,
              builder: (BuildContext c, Widget w) => new Container(
                    child: Stack(
                      // overflow: Overflow.clip,
                      fit: StackFit.expand,
                      children: <Widget>[
                        buildItem(0, animationValue),
                        buildItem(1, animationValue),
                        buildItem(2, animationValue),
                        buildItem(3, animationValue),
                        buildItem(4, animationValue),
                        buildItem(5, animationValue),
                      ],
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
