import 'package:flutter/material.dart';

class PiCalculatorWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PiCalculatorState();
  }
}

class PiCalculatorState extends State<PiCalculatorWidget> {
  @override
  void dispose() {
    _digitsTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = "Pi Calculator";

    return /*MaterialApp(
      title: title,
      home: */Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Enter digits count (up to " + _maxDigits().toString() + "):"),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _digitsTextController,
                  validator: (value) => _validate(value),
                  keyboardType: TextInputType.number,
                )
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
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
      );/*,
    );*/
  }

  _validate(String value) {
    if (value.isEmpty) {
      return 'Digits must be not empty';
    }

    final parsed = int.tryParse(value);
    if (parsed == null) {
      return 'Digits must be an integer number';
    }

    if (parsed < 1 || parsed > _maxDigits()) {
      return 'Digits must be in range [1, ${_maxDigits()}]';
    }
    
    return null;
  }

  _maxDigits() {
    return (_pi.length - _pi.indexOf('.') - 1);
  }

  _tryCalculate() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      final parsed = int.tryParse(_digitsTextController.text);
      assert(parsed != null);
      _calculated = _pi.substring(0, 2 + parsed);
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _pi = "3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679821480865132823066470938446095505822317253594081284811174502841027019385211055596446229489549303819644288109756659334461284756482337867831652712019091456485669234603486104543266482133936072602491412737245870066063155881748815209209628292540917153643678925903600113305305488204665213841469519415116094330572703657595919530921861173819326117931051185480744623799627495673518857527248912279381830119491298336733624406566430860213949463952247371907021798609437027705392171762931767523846748184676694051320005681271452635608277857713427577896091736371787214684409012249534301465495853710507922796892589235420199561121290219608640344181598136297747713099605187072113499999983729780499510597317328160963185950244594553469083026425223082533446850352619311881710100031378387528865875332083814206171776691473035982534904287554687311595628638823537875937519577818577805321712268066130019278766111959092164201989";
  final _digitsTextController = TextEditingController();
  String _calculated = "";
}