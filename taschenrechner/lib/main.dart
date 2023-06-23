import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _display = '0';

  void _handleKey(String key) {
    setState(() {
      if (key == 'AC') {
        _display = '0';
      } else if (key == '=') {
        _evaluateExpression();
      } else {
        if (_display == '0' && key != '.' && !_isOperator(key)) {
          _display = key;
        } else {
          _display += key;
        }
      }
    });
  }

  void _evaluateExpression() {
    try {
      Parser p = Parser();
      Expression exp =
          p.parse(_display.replaceAll('x', '*').replaceAll('÷', '/'));
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      _display = eval.toStringAsFixed(eval.truncateToDouble() == eval ? 0 : 2);
    } catch (e) {
      _display = 'Error';
    }
  }

  bool _isOperator(String key) {
    return ['+', '-', 'x', '÷', '%'].contains(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(32),
                child: Text(_display,
                    style: const TextStyle(fontSize: 48, color: Colors.white)),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(20),
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if (_buttonLabels[index] == '0') {
                  return CalculatorDoubleButton(
                    _buttonLabels[index],
                    _buttonColors[index],
                    Colors.white,
                    _handleKey,
                  );
                } else {
                  return CalculatorButton(
                    _buttonLabels[index],
                    _buttonColors[index],
                    Colors.white,
                    _handleKey,
                  );
                }
              },
              itemCount: _buttonLabels.length,
            ),
          ],
        ),
      ),
    );
  }

  final _buttonLabels = [
    'AC',
    '+/-',
    '%',
    '/',
    '7',
    '8',
    '9',
    'x',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '=',
  ];
  final _buttonColors = [
    Colors.grey[500]!,
    Colors.grey[500]!,
    Colors.grey[500]!,
    Colors.orange,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.orange,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.orange,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.orange,
    Colors.grey[700]!,
    Colors.grey[700]!,
    Colors.orange,
  ];
}

class CalculatorButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final Function(String) onPressed;

  const CalculatorButton(this.label, this.color, this.textColor, this.onPressed,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        padding: const EdgeInsets.all(24),
      ),
      child: Text(label, style: TextStyle(fontSize: 24, color: textColor)),
      onPressed: () => onPressed(label),
    );
  }
}

class CalculatorDoubleButton extends CalculatorButton {
  const CalculatorDoubleButton(
      String label, Color color, Color textColor, Function(String) onPressed,
      {super.key})
      : super(label, color, textColor, onPressed);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.of(context).size.width - 60) / 2,
      child: super.build(context),
    );
  }
}
