import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _display = '0';
  String _expression = '';
  double? _firstNum;
  String? _operator;
  bool _isNewNumber = true;

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'CE') {
        _display = '0';
        _expression = '';
        _firstNum = null;
        _operator = null;
        _isNewNumber = true;
      } else if (value == 'C') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
          _isNewNumber = true;
        }
      } else if (value == '+/-') {
        if (_display != '0' && _display != 'Error') {
          if (_display.startsWith('-')) {
            _display = _display.substring(1);
          } else {
            _display = '-$_display';
          }
        }
      } else if (value == '%') {
        if (_display != 'Error') {
          double num = double.tryParse(_display) ?? 0;
          _display = (num / 100).toString();
          _isNewNumber = true;
        }
      } else if (value == '+' || value == '-' || value == '×' || value == '÷') {
        if (_display != 'Error') {
          _firstNum = double.tryParse(_display);
          _operator = value;
          _expression = '$_display $value';
          _isNewNumber = true;
        }
      } else if (value == '=') {
        if (_firstNum != null && _operator != null && _display != 'Error') {
          double secondNum = double.tryParse(_display) ?? 0;
          _expression = '$_expression $_display =';
          _calculateResult(_firstNum!, secondNum, _operator!);
          _firstNum = null;
          _operator = null;
          _isNewNumber = true;
        }
      } else {
        if (_isNewNumber) {
          if (value == '.') {
            _display = '0.';
          } else {
            _display = value;
          }
          _isNewNumber = false;
        } else {
          if (value == '.') {
            if (!_display.contains('.')) {
              _display += value;
            }
          } else {
            if (_display == '0') {
              _display = value;
            } else {
              _display += value;
            }
          }
        }
      }
    });
  }

  void _calculateResult(double first, double second, String op) {
    double result = 0;
    if (op == '+') {
      result = first + second;
    } else if (op == '-') {
      result = first - second;
    } else if (op == '×') {
      result = first * second;
    } else if (op == '÷') {
      if (second == 0) {
        _display = 'Error';
        return;
      }
      result = first / second;
    }

    if (result % 1 == 0) {
      _display = result.toInt().toString();
    } else {
      _display = result.toString();
    }
  }

  Widget _buildButton(
    String text, {
    Color? color,
    Color textColor = Colors.white,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? Colors.grey[850],
            foregroundColor: textColor,
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          onPressed: () => _onButtonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/info');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 20.0, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _display,
                    style: const TextStyle(
                      fontSize: 48.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  _buildButton('CE', color: Colors.redAccent),
                  _buildButton('C', color: Colors.orangeAccent),
                  _buildButton('%', color: Colors.grey[700]),
                  _buildButton('÷', color: Colors.blueAccent),
                ],
              ),
              Row(
                children: [
                  _buildButton('7'),
                  _buildButton('8'),
                  _buildButton('9'),
                  _buildButton('×', color: Colors.blueAccent),
                ],
              ),
              Row(
                children: [
                  _buildButton('4'),
                  _buildButton('5'),
                  _buildButton('6'),
                  _buildButton('-', color: Colors.blueAccent),
                ],
              ),
              Row(
                children: [
                  _buildButton('1'),
                  _buildButton('2'),
                  _buildButton('3'),
                  _buildButton('+', color: Colors.blueAccent),
                ],
              ),
              Row(
                children: [
                  _buildButton('+/-'),
                  _buildButton('0'),
                  _buildButton('.'),
                  _buildButton('=', color: Colors.green),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
