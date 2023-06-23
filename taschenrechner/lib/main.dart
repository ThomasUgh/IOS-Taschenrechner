import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:intl/intl.dart';

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
  String _display = '0';
  String _history = '';

  void _handleKey(String key) {
    setState(() {
      if (_display == 'Fehler') {
        _display = '';
      }
      if (key == 'AC') {
        _display = '0';
        _history = '';
      } else if (key == '=') {
        _evaluateExpression();
      } else if (key == 'x²') {
        _squareNumber();
      } else if (_isOperator(key)) {
        _history += _display + key;
        _display = '';
      } else {
        if (_display == '0' && key != '.') {
          _display = key;
        } else {
          _display += key;
        }
      }
    });
  }

  String _reformatNumber(String number) {
    // Remove the existing comma.
    String numberWithoutComma = number.replaceAll(',', '');

    // Try parsing the number.
    int? parsedNumber = int.tryParse(numberWithoutComma);
    if (parsedNumber != null) {
      // Format the number with the comma as the thousands separator.
      return NumberFormat('#,##0').format(parsedNumber);
    } else {
      // If it's not a number, return the original string.
      return number;
    }
  }

  bool _isDigit(String key) {
    return int.tryParse(key) != null;
  }


void _evaluateExpression() {
    try {
      String expression = _prepareExpression(_display);
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _display = NumberFormat('#,###').format(eval);
    } catch (e) {
      _display = 'Fehler';
    }
  }

void _squareNumber() {
    try {
      String expression = _prepareExpression(_display);
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      _display = NumberFormat('#,###').format(eval * eval);
    } catch (e) {
      _display = 'Fehler';
    }
}

String _prepareExpression(String expression) {
    // Remove the comma from the number and replace the operators with their correct symbols.
    return expression
        .replaceAll(',', '')
        .replaceAll('x', '*')
        .replaceAll('÷', '/');
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
                padding: const EdgeInsets.all(30),
                child: Text(_display,
                    style: const TextStyle(fontSize: 52, color: Colors.white)),
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
                return CalculatorButton(
                  _buttonLabels[index],
                  _buttonColors[index],
                  Colors.white,
                  _handleKey,
                );
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
    'x²',
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
