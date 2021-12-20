import 'dart:convert';
import 'package:Salmodiamo/router/router.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'globals.dart' as globals;

final routerDelegate = Get.put(MyRouterDelegate());
final _AppTitle = 'Salmodiamo';

void main() async {
  runApp(Salmodiamo());
}

class Salmodiamo extends StatelessWidget {
  Salmodiamo({Key? key}) : super(key: key) {
    routerDelegate.pushPage(name: '/');
  }

  // This widget is the   ot of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _AppTitle,
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
  SalmodiamoMain({Key? key}) : super(key: key);

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
        title: Text(_AppTitle),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50),
          child: InteractiveViewer(
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
                  _AppTitle,
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
                          String args =
                              '${globals.psalms_prefix}${globals.separator}${_psalmsValue.replaceAll(globals.psalm, '')}';
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
                          String args =
                              '${globals.tones_prefix}${globals.separator}2';
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
                          String args =
                              '${globals.tones_prefix}${globals.separator}3';
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
                          String args =
                              '${globals.tones_prefix}${globals.separator}4';
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
  String id;

  Playtone(this.id, {Key? key}) : super(key: key);

  // This widget is the   ot of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: _AppTitle,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: PlaytoneMain(id));
  }
}

class PlaytoneMain extends StatefulWidget {
  String id;
  PlaytoneMain(this.id, {Key? key}) : super(key: key);

  @override
  State<PlaytoneMain> createState() => _PlaytoneMainState(id);
}

class _PlaytoneMainState extends State<PlaytoneMain> {
  late String _title;
  late String _type;
  late String _number;
  String _id;

  List<Widget> _audios = [];
  List<Widget> _scores = [];

  List<Widget> _content = [];

  _PlaytoneMainState(this._id) {
    List<String> fields = _id.split(globals.separator);
    if (fields.length == 2) {
      _type = fields[0];
      _number = fields[1];
    } else {
      _type = '';
      _number = '';
    }
    switch (_type) {
      case globals.psalms_prefix:
        _title = 'Toni per il Salmo numero ${_number}';
        break;
      case globals.tones_prefix:
        _title = 'Toni a ${_number}';
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
    switch (_type) {
      case globals.psalms_prefix:
        keys = manifestMap.keys
            .where((String key) => key.contains(globals.psalms_prefix +
                globals.separator +
                _number +
                globals.separator))
            .toList();
        break;
      case globals.tones_prefix:
        keys = manifestMap.keys
            .where((String key) => key.contains(globals.tones_prefix +
                globals.separator +
                _number +
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
                    //ScoreArguments args = ScoreArguments(type, number, key);
                    String args =
                        '$_id${globals.separator}${key.replaceAll(globals.separator, globals.url_replacement)}';
                    print('args: $args');
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
                        Image.asset(
                          key,
                          fit: BoxFit.contain,
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
      _title,
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
          title: Text(_title),
        ),
        body: InteractiveViewer(
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
  String _title = 'Spartito';

  String id;
  late String type;
  late String number;
  late String url;

  late BuildContext _context;

  ToneScore(this.id, {Key? key}) : super(key: key) {
    List<String> fields = id.split(globals.separator);
    if (fields.length == 3) {
      type = fields[0];
      number = fields[1];
      url = fields[2].replaceAll(globals.url_replacement, globals.separator);
    } else {
      type = '';
      number = '';
      url = '';
    }
    print('url: $url');
    switch (type) {
      case globals.psalms_prefix:
        _title += ' del Salmo numero $number';
        break;
      case globals.tones_prefix:
        _title += ' del tono a $number';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
        appBar: AppBar(
          title: Text(_title),
        ),
        body: Center(
            child: InteractiveViewer(
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            url,
                            fit: BoxFit.contain,
                          )
                        ])))));
  }
}
