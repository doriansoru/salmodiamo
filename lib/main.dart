import 'dart:convert';
import 'package:Salmodiamo/router/router.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import 'globals.dart' as globals;

enum ToneType { PSALM, TONE }

final routerDelegate = Get.put(MyRouterDelegate());

class ToneArguments {
  final ToneType type;
  final int number;

  ToneArguments(this.type, this.number);
}

class ScoreArguments {
  final ToneType type;
  final int number;
  final String url;

  ScoreArguments(this.type, this.number, this.url);
}

void main() async {
  runApp(Salmodiamo());
}

class Salmodiamo extends StatelessWidget {
  static const _AppTitle = 'Salmodiamo';

  Salmodiamo({Key? key}) : super(key: key) {
    routerDelegate.pushPage(name: '/');
  }

  // This widget is the   ot of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Salmodiamo._AppTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Router(
        routerDelegate: routerDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
    );
  }
}

class SalmodiamoMain extends StatefulWidget {
  SalmodiamoMain({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SalmodiamoMain> createState() => _SalmodiamoMainState();
}

class _SalmodiamoMainState extends State<SalmodiamoMain> {
  late String _psalmsValue = globals.psalm + '1';
  @override
  Widget build(BuildContext context) {
    var psalms = <String>[];
    for (int i = 0; i < 150; i++) {
      psalms.add('Salmo ${(i + 1).toString()}');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 500 / 30,
                  child: Image(
                    image: new AssetImage('assets/images/png/notes.png'),
                    alignment: Alignment.center,
                    fit: BoxFit.fitWidth,
                    repeat: ImageRepeat.repeatX,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headline4,
                ),
                SizedBox(height: 20),
                Text(
                  'Seleziona una delle opzioni seguenti per visualizzare i toni corrispondenti.',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      DropdownButton<String>(
                        value: _psalmsValue,
                        icon: const Icon(Icons.arrow_downward_rounded),
                        elevation: 16,
                        onChanged: (String? newValue) {
                          _psalmsValue = newValue!;
                          setState(() {
                            _psalmsValue;
                          });
                        },
                        items: psalms
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text('Visualizza'),
                        onPressed: () {
                          ToneArguments args = ToneArguments(
                              ToneType.PSALM,
                              int.parse(
                                  _psalmsValue.replaceAll(globals.psalm, '')));
                          routerDelegate.pushPage(
                            name: '/playtone',
                            arguments: args,
                          );
                        },
                      ),
                    ]),
                SizedBox(height: 50),
                Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(globals.tones + '2'),
                        onPressed: () {
                          ToneArguments args = ToneArguments(ToneType.TONE, 2);
                          routerDelegate.pushPage(
                            name: '/playtone',
                            arguments: args,
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text(globals.tones + '3'),
                        onPressed: () {
                          ToneArguments args = ToneArguments(ToneType.TONE, 3);
                          routerDelegate.pushPage(
                            name: '/playtone',
                            arguments: args,
                          );
                        },
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        child: Text(globals.tones + '4'),
                        onPressed: () {
                          ToneArguments args = ToneArguments(ToneType.TONE, 4);
                          routerDelegate.pushPage(
                            name: '/playtone',
                            arguments: args,
                          );
                        },
                      ),
                    ]),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Playtone extends StatelessWidget {
  static const _AppTitle = 'Toni';

  ToneType type;
  int number;

  Playtone({Key? key, required this.type, required this.number})
      : super(key: key);

  // This widget is the   ot of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: Playtone._AppTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PlaytoneMain(type: type, number: number));
  }
}

class PlaytoneMain extends StatefulWidget {
  final ToneType type;
  final int number;

  const PlaytoneMain({Key? key, required this.type, required this.number})
      : super(key: key);

  @override
  State<PlaytoneMain> createState() =>
      _PlaytoneMainState(type: type, number: number);
}

class _PlaytoneMainState extends State<PlaytoneMain> {
  late String title;
  late ToneType type;
  late int number;
  List<Widget> _audios = [];
  List<Widget> _scores = [];

  List<Widget> _content = [];

  _PlaytoneMainState({required this.type, required this.number}) {
    switch (type) {
      case ToneType.PSALM:
        title = 'Toni per il Salmo numero ${number.toString()}';
        break;
      case ToneType.TONE:
        title = 'Toni a ${number.toString()}';
        break;
    }
  }

  Future<int> getTones(BuildContext context) async {
    //_audios = [];
    //_scores = [];
    //Set two lists:
    //  list of _audios, list of _scores
    var assetsFile =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(assetsFile);
    Iterable<String> keys = [];
    switch (type) {
      case ToneType.PSALM:
        keys = manifestMap.keys
            .where((String key) => key.contains(globals.psalms_prefix +
                globals.separator +
                number.toString() +
                globals.separator))
            .toList();
        break;
      case ToneType.TONE:
        keys = manifestMap.keys
            .where((String key) => key.contains(globals.tones_prefix +
                globals.separator +
                number.toString() +
                globals.separator))
            .toList();
        break;
    }
    int i = 0;
    for (var key in keys) {
      if (key.contains(globals.scores_ext)) {
        _scores.add(Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    ScoreArguments args = ScoreArguments(type, number, key);
                    routerDelegate.pushPage(
                      name: '/tonescore',
                      arguments: args,
                    );
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tono numero ${(++i).toString()}'),
                        ExtendedImage.asset(
                          key,
                          fit: BoxFit.contain,
                          mode: ExtendedImageMode.gesture,
                          initGestureConfigHandler: (state) {
                            return GestureConfig(
                              minScale: 0.9,
                              animationMinScale: 0.7,
                              maxScale: 3.0,
                              animationMaxScale: 3.5,
                              speed: 1.0,
                              inertialSpeed: 100.0,
                              initialScale: 1.0,
                              inPageView: false,
                              initialAlignment: InitialAlignment.center,
                            );
                          },
                        )
                      ])),
              ElevatedButton(
                  child: Text('Ascolta'),
                  onPressed: () {
                    AssetsAudioPlayer.newPlayer().open(
                      Audio(key.replaceAll(
                          globals.scores_ext, globals.audios_ext)),
                      autoStart: true,
                      showNotification: true,
                    );
                  }),
            ]));
      }
    }
    return 0;
  }

  void populatePage(BuildContext context) async {
    await getTones(context);
    _content.add(AspectRatio(
      aspectRatio: 500 / 30,
      child: Image(
        image: new AssetImage('assets/images/png/notes.png'),
        alignment: Alignment.center,
        fit: BoxFit.fitWidth,
        repeat: ImageRepeat.repeatX,
      ),
    ));
    _content.add(SizedBox(height: 10));
    _content.add(Text(
      title,
      style: Theme.of(context).textTheme.headline4,
    ));
    _content.add(SizedBox(height: 20));
    _content.add(Text(
      'Tocca lo spartito del tono per ingrandirlo o il pulsante sottostante per ascoltarlo.',
      style: Theme.of(context).textTheme.bodyText1,
    ));
    _content.add(SizedBox(height: 20));
    for (Widget score in _scores) {
      _content.add(score as Widget);
      _content.add(SizedBox(height: 20));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    populatePage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _content,
                    )))));
  }
}

class ToneScore extends StatelessWidget {
  String _appTitle = 'Spartito';

  ToneType type;
  int number;
  String url;

  late BuildContext _context;

  ToneScore(
      {Key? key, required this.type, required this.number, required this.url})
      : super(key: key) {
    switch (type) {
      case ToneType.PSALM:
        _appTitle += ' del Salmo numero $number';
        break;
      case ToneType.TONE:
        _appTitle += ' del tono a $number';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(_appTitle),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExtendedImage.asset(
                            url,
                            fit: BoxFit.contain,
                            mode: ExtendedImageMode.gesture,
                            initGestureConfigHandler: (state) {
                              return GestureConfig(
                                minScale: 0.9,
                                animationMinScale: 0.7,
                                maxScale: 3.0,
                                animationMaxScale: 3.5,
                                speed: 1.0,
                                inertialSpeed: 100.0,
                                initialScale: 1.0,
                                inPageView: false,
                                initialAlignment: InitialAlignment.center,
                              );
                            },
                          )
                        ])))));
  }
}
