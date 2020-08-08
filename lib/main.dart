
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Calculateur de calorie'),
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
  int calorieBase;
  int calorieAvecActivite;
  int radioSelectionne;
  double poids;
  bool genre = false;
  double age;
  double taille = 170.0;
  Map mapActivite = {
    0: "Faible",
    1: "Modere",
    2: "Forte"
  };

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      print("Nous sommes sur IOS");

    } else {
      print("Nous ne sommes pas ssur ios");
    }
    return new GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(new FocusNode())),
      child: (Platform.isIOS)
        ? new CupertinoPageScaffold(
        navigationBar: new CupertinoNavigationBar(
          backgroundColor: setColor(),
          middle: textAvecStyle(widget.title),
        ),
          child: body())
          : new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: setColor(),
          ),
          body: body()
      ),
    );

  }

  Widget body() {
    return new SingleChildScrollView(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          padding(),
          textAvecStyle("Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
          padding(),
          new Card(
            elevation: 10.0,
            child: new Column(
              children: <Widget>[
                padding(),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    textAvecStyle("Femme", color: Colors.pink),
                    switchSelonPlatforme(),
                    textAvecStyle("Homme", color: Colors.blue)
                  ],

                ),
                padding(),
               ageButton(),
                padding(),
                textAvecStyle("Votre taille est de: ${taille.toInt()} cm.", color: setColor()),
                padding(),
                sliderSelonPlatform(),
                padding(),
                new TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (String string) {
                    setState(() {
                      poids = double.tryParse(string);

                    });
                  },
                  decoration: new InputDecoration(
                      labelText: "Entrez votre poids en Kilos."
                  ),
                ),
                padding(),
                textAvecStyle("Quelle est votre activité sportive ?", color: setColor()),
                padding(),
                rowRadio(),
                padding()
              ],
            ),
          ),
          padding(),
          calcButton(),
        ],
      ),
    );

  }

  Padding padding() {
    return new Padding(padding: EdgeInsets.only(top: 20.0));
  }

  Future<Null> montrerPicker() async {
    DateTime choix = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
      initialDatePickerMode: DatePickerMode.year
    );
        if (choix != null) {
          var difference = new DateTime.now().difference(choix);
          var jours = difference.inDays;
          var ans = (jours /365);
          setState(() {
            age = ans;

          });
    }

  }

  Color setColor () {
    if (genre) {
      return Colors.blue;
    } else {
      return Colors.pink;
    }
  }
  Widget calcButton() {
    if(Platform.isIOS) {
      return CupertinoButton(
        color: setColor(),
        child: textAvecStyle("Calculer", color: Colors.white),
        onPressed: calculerNombreDeCalorie,
      );

    } else {
      return new RaisedButton(
          color: setColor(),
          child: textAvecStyle("Calculer", color: Colors.white),
          onPressed: calculerNombreDeCalorie
      );

    }

  }
  Widget ageButton() {
    if(Platform.isIOS) {
      return new CupertinoButton(
          color: setColor(),
          child: textAvecStyle((age == null) ? "Entrer votre age" :  "Votre age est de : ${age.toInt()}",
              color: Colors.white
          ),
          onPressed: (() => montrerPicker())

      );

    } else {
      return  new RaisedButton(
          color: setColor(),
          child: textAvecStyle((age == null) ? "Appuyer pour entrer votre age" :  "Votre age est de : ${age.toInt()}",
              color: Colors.white
          ),
          onPressed: (() => montrerPicker())
      );

    }

  }
  Widget sliderSelonPlatform() {
    if(Platform.isIOS) {
      return new CupertinoSlider(
          value: taille,
          activeColor: setColor(),
          min: 100.0,
          max: 215.0,
          onChanged: (double d) {
            setState(() {
              taille = d;
            });
          }
      );

    } else {
      return new Slider(
          value: taille,
          activeColor: setColor(),
          onChanged: (double d ) {
            setState(() {
              taille = d;
            });
          },
          max: 215.0,
          min: 100.0
      );

    }

  }
  Widget switchSelonPlatforme() {
    if(Platform.isIOS) {
      return new CupertinoSwitch(
        value: genre,
        activeColor: Colors.blue,
        onChanged: (bool b) {
          setState(() {
            genre = b;
          },
          );

        }
      );
    } else {
      return new Switch(
          value: genre,
          inactiveTrackColor: Colors.pink,
          activeColor: Colors.blue,
          onChanged: (bool b) {
            setState(() {
              genre = b;
            });
          });

    }
  }

  Widget textAvecStyle(String data, {color: Colors.black, fontSize: 15.0}) {
    if(Platform.isIOS) {
      return new DefaultTextStyle(
          style: new TextStyle(
            color: color,
            fontSize: fontSize

          ),
          child: new Text(
              data,
            textAlign: TextAlign.center,
          )
      );

    } else {
      return new Text(
        data,
        textAlign: TextAlign.center,
        style: new TextStyle(
          color: color,
          fontSize: fontSize,
        ),
      );

    }

  }

  Row rowRadio() {
    List<Widget> l = [];
    mapActivite.forEach((key, value) {
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
            activeColor: setColor(),
              value: key,
              groupValue: radioSelectionne,
              onChanged: (Object i) {
              setState(() {
                radioSelectionne = i;
              });

              }),
          textAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l,

    );
  }

  void calculerNombreDeCalorie() {
    if (age != null && poids != null && radioSelectionne !=null) {
      if(genre) {
        calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age)).toInt();
      } else {
        calorieBase = (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt();
      }
      switch(radioSelectionne) {
        case 0:
          calorieAvecActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieAvecActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieAvecActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieAvecActivite = calorieBase;
          break;

      }
      setState(() {
        dialogue();
      });

    } else {
      alerte();

    }

  }

  Future<Null> dialogue() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        return SimpleDialog(
          title: textAvecStyle("Votre besoin en calories", color: setColor()),
          contentPadding: EdgeInsets.all(15.0),
          children: <Widget>[
            padding(),
            textAvecStyle("Votre besoin de base est de : $calorieBase"),
            padding(),
            textAvecStyle("Votre besoin avec activité sportive est de : $calorieAvecActivite"),
            new RaisedButton(
                onPressed: () {
                  Navigator.pop(buildContext);
                },
              child: textAvecStyle("ok", color: Colors.white),
              color: setColor(),
            ),
          ],
        );
      }

    );
  }

  Future<Null> alerte() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext buildContext) {
        if(Platform.isIOS) {
          return new CupertinoAlertDialog(
            title: textAvecStyle("Erreur"),
            content: textAvecStyle("Tous les champs ne sont remplis"),
            actions: <Widget>[
              new CupertinoButton(
                color:Colors.white,
                  child: textAvecStyle(
                      "Ok",
                      color: Colors.red
                  ),
                onPressed: () {
                  Navigator.pop(buildContext);

                })
            ],

          );

        } else {
          return new AlertDialog(
            title: textAvecStyle("Erreur"),
            content: textAvecStyle("Tous les champs ne sont remplis"),
            actions: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(buildContext);

                  },
                  child: textAvecStyle("Ok", color: Colors.red))
            ],

          );

        }

      }
    );

}
}
