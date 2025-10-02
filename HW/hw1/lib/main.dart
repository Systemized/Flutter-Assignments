import 'package:flutter/material.dart';

void main() => runApp(const CalculatorApp());

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SimpleCalculator(),
    );
  }
}

class SimpleCalculator extends StatefulWidget {
  const SimpleCalculator({super.key});

  @override
  State<SimpleCalculator> createState() => _SimpleCalculatorState();
}

class _SimpleCalculatorState extends State<SimpleCalculator> {
  String output = "0";
  String _currentInput = "0";
  double _num1 = 0.0;
  double _num2 = 0.0;
  String _operand = "";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "CLEAR") {
        _currentInput = "0";
        _num1 = 0.0;
        _num2 = 0.0;
        _operand = "";
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "/" ||
          buttonText == "*") {
        _num1 = double.parse(_currentInput);
        _operand = buttonText;
        _currentInput = "0";
      } else if (buttonText == "=") {
        _num2 = double.parse(_currentInput);

        if (_operand == "+") {
          _currentInput = (_num1 + _num2).toString();
        }
        if (_operand == "-") {
          _currentInput = (_num1 - _num2).toString();
        }
        if (_operand == "*") {
          _currentInput = (_num1 * _num2).toString();
        }
        if (_operand == "/") {
          if (_num2 == 0) {
            _currentInput = "Error";
          } else {
            _currentInput = (_num1 / _num2).toString();
          }
        }

        _num1 = 0.0;
        _num2 = 0.0;
        _operand = "";
      } else {
        if (_currentInput == "0" || _currentInput == "Error") {
          _currentInput = buttonText;
        } else {
          _currentInput = _currentInput + buttonText;
        }
      }

      if (_currentInput.contains('.') && _currentInput.endsWith('0')) {
        var temp = double.parse(_currentInput);
        if (temp == temp.toInt()) {
          output = temp.toInt().toString();
        } else {
          output = temp.toString();
        }
      } else if (_currentInput != "Error") {
        var temp = double.parse(_currentInput);
        if (temp == temp.toInt()) {
          output = temp.toInt().toString();
        } else {
          output = temp.toString();
        }
      } else {
        output = _currentInput;
      }
    });
  }

  Widget buildButton(String buttonText, {Color color = Colors.black54}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              padding: const EdgeInsets.all(24.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0))),
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
        backgroundColor: Colors.blueGrey[800],
      ),
      body: Container(
        color: Colors.blueGrey[900],
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(
                vertical: 24.0,
                horizontal: 12.0,
              ),
              child: Text(
                output,
                style: const TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const Expanded(
              child: Divider(
                color: Colors.white24,
              ),
            ),
            Column(
              children: [
                Row(children: [
                  buildButton("7"),
                  buildButton("8"),
                  buildButton("9"),
                  buildButton("/", color: Colors.orange),
                ]),
                Row(children: [
                  buildButton("4"),
                  buildButton("5"),
                  buildButton("6"),
                  buildButton("*", color: Colors.orange),
                ]),
                Row(children: [
                  buildButton("1"),
                  buildButton("2"),
                  buildButton("3"),
                  buildButton("-", color: Colors.orange),
                ]),
                Row(children: [
                  buildButton("0"),
                  buildButton("CLEAR", color: Colors.redAccent),
                  buildButton("=", color: Colors.green),
                  buildButton("+", color: Colors.orange),
                ]),
                const SizedBox(height: 10),
              ],
            )
          ],
        ),
      ),
    );
  }
}