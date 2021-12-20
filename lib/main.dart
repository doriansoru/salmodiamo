import 'dart:convert';
import 'dart:io';
import 'router/router.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:get/get.dart';
import 'globals.dart' as globals;
import 'package:easy_localization/easy_localization.dart';

final routerDelegate = Get.put(MyRouterDelegate());
final String _lang = Platform.localeName == 'it_IT'
    ? 'it_IT'
    : 'en_US'; // Returns locale string in the form 'en_US'
String _appTitle = tr('psamodiate');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en', 'US'), Locale('it', 'IT')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('it', 'IT'),
        child: Salmodiamo()),
  );
  //runApp(Salmodiamo());
}

class Salmodiamo extends StatelessWidget {
  Salmodiamo({Key? key}) : super(key: key) {
    routerDelegate.pushPage(name: '/');
  }

  // This widget is the   ot of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tr('psalmodiate'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: Locale(_lang),
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
  late String _psalmsValue = tr('psalm_number', args: ['1']);
  @override
  Widget build(BuildContext context) {
    var psalms = <String>[];
    for (int i = 0; i < 150; i++) {
      psalms.add(tr('psalm_number', args: [(i + 1).toString()]));
    }

    return MaterialApp(
        title: tr('psalmodiate'),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: Locale(_lang),
        home: Scaffold(
          appBar: AppBar(title: Text(tr('psalmodiate'))),
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
                      tr('psalmodiate'),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    SizedBox(height: 20),
                    Text(
                      tr('select_options'),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    SizedBox(height: 20),
                    /*Row(
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
                            child: Text(tr('show')),
                            onPressed: () {
                              //Extracts the number of the psalm
                              RegExp r = new RegExp(r"[^\d]*(\d)*[^\d]*");
                              String? psalm_number = r
                                  .firstMatch(_psalmsValue)
                                  ?.group(1)
                                  .toString();
                              String args =
                                  '${globals.psalms_prefix}${globals.field_separator}$psalm_number';
                              routerDelegate.pushPage(
                                name: '/playtone',
                                arguments: args,
                              );
                            },
                          ),
                        ]),
                    SizedBox(height: 50),*/
                    Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            child: Text(tr('tones_structure', args: ['2'])),
                            onPressed: () {
                              String args =
                                  '${globals.tones_prefix}${globals.field_separator}2';
                              routerDelegate.pushPage(
                                name: '/playtone',
                                arguments: args,
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text(tr('tones_structure', args: ['3'])),
                            onPressed: () {
                              String args =
                                  '${globals.tones_prefix}${globals.field_separator}3';
                              routerDelegate.pushPage(
                                name: '/playtone',
                                arguments: args,
                              );
                            },
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            child: Text(tr('tones_structure', args: ['4'])),
                            onPressed: () {
                              String args =
                                  '${globals.tones_prefix}${globals.field_separator}4';
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
        ));
  }
}

class Playtone extends StatelessWidget {
  String id;

  Playtone(this.id, {Key? key}) : super(key: key);

  // This widget is the   ot of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: tr('psalmodiate'),
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
    List<String> fields = _id.split(globals.field_separator);
    if (fields.length == 2) {
      _type = fields[0];
      _number = fields[1];
    } else {
      _type = '';
      _number = '';
    }
    switch (_type) {
      case globals.psalms_prefix:
        _title = tr('tones_for_psalm_number', args: [_number]);
        break;
      case globals.tones_prefix:
        _title = tr('tones_structure', args: [_number]);
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
                globals.filename_separator +
                _number +
                globals.filename_separator))
            .toList();
        break;
      case globals.tones_prefix:
        keys = manifestMap.keys
            .where((String key) => key.contains(globals.tones_prefix +
                globals.filename_separator +
                _number +
                globals.filename_separator))
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
                    String args = '$_id${globals.field_separator}$key';
                    routerDelegate.pushPage(
                      name: '/tonescore',
                      arguments: args,
                    );
                  },
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tr('tone_number', args: [(++i).toString()])),
                        Image.asset(
                          key,
                          fit: BoxFit.contain,
                        )
                      ])),
              ElevatedButton(
                  child: Text(tr('listen')),
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
      tr('tones_instructions'),
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
  String _title = tr('score');

  String id;
  late String type;
  late String number;
  late String assetname;

  late BuildContext _context;

  ToneScore(this.id, {Key? key}) : super(key: key) {
    List<String> fields = id.split(globals.field_separator);
    if (fields.length == 3) {
      type = fields[0];
      number = fields[1];
      assetname = fields[2]
          .replaceAll(globals.field_separator, globals.filename_separator);
    } else {
      type = '';
      number = '';
      assetname = '';
    }
    switch (type) {
      case globals.psalms_prefix:
        _title += tr('of_psalm_number', args: [number]);
        break;
      case globals.tones_prefix:
        _title += tr('of_tone_number', args: [number]);
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
                            assetname,
                            fit: BoxFit.contain,
                          )
                        ])))));
  }
}
