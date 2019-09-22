import 'dart:math';

import 'package:flutter/material.dart';

class ExpCalculatorWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ExpCalculatorState();
  }
}

String truncateDigits(String value, int precision) {
  return value.substring(0,  value.indexOf('.') + 1 + precision);
}

int factorial(int n) {
  if (n < 0) {
    throw new ArgumentError('Argument less than 0');
  }

  int res = 1;
  for (int i = 1; i <= n; i++) {
    res *= i;
  }
  return res;
}

abstract class ICalculationAlgorithm {
  String calculate(int precision);
  int maxPrecision();
}

class BinomialExpansionAlgorithm implements ICalculationAlgorithm {
  @override
  String calculate(int precision) {
    assert(precision >= 0 && precision <= _maxPrecision);
    final steps = 100000;
    final value = pow(1 + 1 / steps, steps);
    return truncateDigits(value.toString(), precision);
  }

  @override
  int maxPrecision() {
    return _maxPrecision;
  }

  final _maxPrecision = 4;
}

class BrothersFormulaeAlgorithm implements ICalculationAlgorithm {
  @override
  String calculate(int precision) {
    assert(precision >= 0 && precision <= _maxPrecision);

    // Steps increase (up to 10) doesn't producing more precise value
    final steps = 9;

    double result = 0.0;
    for (int i = 0; i <= steps; ++i) {
      result += (2 * i + 2) / factorial(2 * i + 1);
    }

    return truncateDigits(result.toString(), precision);
  }

  @override
  int maxPrecision() {
    return _maxPrecision;
  }

  final _maxPrecision = 14;
}

class NewtonSeriesExpansionAlgorithm implements ICalculationAlgorithm {
  @override
  String calculate(int precision) {
    assert(precision >= 0 && precision <= _maxPrecision);

    // Steps increase (up to 20) doesn't producing more precise value
    final steps = 17;

    double result = 1.0;
    for (int i = 1; i <= steps; ++i) {
      result += (1 / factorial(i));
    }

    return truncateDigits(result.toString(), precision);
  }

  @override
  int maxPrecision() {
    return _maxPrecision;
  }

  final _maxPrecision = 15;
}

class HardcodedAlgorithm implements ICalculationAlgorithm {
  @override
  String calculate(int precision) {
    assert(precision >= 0 && precision <= maxPrecision());
    return truncateDigits(_value, precision);
  }

  @override
  int maxPrecision() {
    return _value.length - _value.indexOf('.') - 1;
  }

  final String _value = "2.7182818284590452353602874713526624977572470936999595749669676277240766303535475945713821785251664274274663919320030599218174135966290435729003342952605956307381323286279434907632338298807531952510190115738341879307021540891499348841675092447614606680822648001684774118537423454424371075390777449920695517027618386062613313845830007520449338265602976067371132007093287091274437470472306969772093101416928368190255151086574637721112523897844250569536967707854499699679468644549059879316368892300987931277361782154249992295763514822082698951936680331825288693984964651058209392398294887933203625094431173012381970684161403970198376793206832823764648042953118023287825098194558153017567173613320698112509961818815930416903515988885193458072738667385894228792284998920868058257492796104841984443634632449684875602336248270419786232090021609902353043699418491463140934317381436405462531520961836908887070167683964243781405927145635490613031072085103837505101157477041718986106873969655212671546889570350354";
}

class ExpCalculatorState extends State<ExpCalculatorWidget> {
  @protected
  @mustCallSuper
  void initState() {
    _selectedAlgorithm = _algorithms.keys.elementAt(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = "e calculator";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Select calculation algorithm:"),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: DropdownButton<String>(
                value: _selectedAlgorithm,
                onChanged: (String selectedAlgorithm) {
                  setState(() {
                    _selectedAlgorithm = selectedAlgorithm;
                    if (_digitsTextController.text.isNotEmpty) {
                      _formKey.currentState.validate();
                    }
                  });
                },
                items: _algorithms.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            Text("Enter digits count (up to " + _algorithms[_selectedAlgorithm].maxPrecision().toString() + "):"),
            Form(
                key: _formKey,
                child: TextFormField(
                  controller: _digitsTextController,
                  validator: (value) => _validate(value),
                  keyboardType: TextInputType.number,
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
              child: Text("Calculation result:"),
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Text(_calculated),
              ),
            ),
            Center(
              child: RaisedButton(
                onPressed: () => _tryCalculate(),
                child: Text('Calculate'),
              ),
            )
          ],
        ),
      )
    );
  }

  _validate(String value) {
    if (value.isEmpty) {
      return 'Digits must be not empty';
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      return 'Digits must be an integer number';
    }

    if (parsed < 1 || parsed > _algorithms[_selectedAlgorithm].maxPrecision()) {
      return 'Digits must be in range [1, ${_algorithms[_selectedAlgorithm].maxPrecision()}]';
    }

    return null;
  }

  _tryCalculate() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      final precision = int.tryParse(_digitsTextController.text);
      assert(precision != null);
      _calculated = _algorithms[_selectedAlgorithm].calculate(precision);
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _digitsTextController = TextEditingController();
  String _calculated = "";

  final Map<String, ICalculationAlgorithm> _algorithms = {
    "Binomial": BinomialExpansionAlgorithm(),
    "Brothers' Formulae": BrothersFormulaeAlgorithm(),
    "Newton's Series": NewtonSeriesExpansionAlgorithm(),
    "Hardcoded": HardcodedAlgorithm()
  };
  String _selectedAlgorithm;
}