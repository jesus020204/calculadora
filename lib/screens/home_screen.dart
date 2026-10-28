import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _output = "0";

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "CE") {
        _output = "0";
      } else if (buttonText == "C") {
        if (_output.length > 1) {
          _output = _output.substring(0, _output.length - 1);
        } else {
          _output = "0";
        }
      } else if (buttonText == "=") {
        _output = _calculateResult(_output);
      } else if (buttonText == "+/-") {
        // Resuelve la operación actual y le cambia el signo
        String current = _calculateResult(_output);
        if (current != "0" && current != "Error") {
          _output = current.startsWith("-")
              ? current.substring(1)
              : "-$current";
        }
      } else if (buttonText == "%") {
        // Resuelve la operación actual y la divide entre 100
        String current = _calculateResult(_output);
        if (current != "Error") {
          double val = (double.tryParse(current) ?? 0) / 100;
          _output = val.toString();
          if (_output.endsWith(".0"))
            _output = _output.substring(0, _output.length - 2);
        }
      } else if (buttonText == "+" ||
          buttonText == "-" ||
          buttonText == "×" ||
          buttonText == "÷") {
        if (!_output.endsWith("+") &&
            !_output.endsWith("-") &&
            !_output.endsWith("×") &&
            !_output.endsWith("÷")) {
          _output += buttonText;
        }
      } else {
        if (_output == "0") {
          _output = buttonText;
        } else {
          _output += buttonText;
        }
      }
    });
  }

  String _calculateResult(String expression) {
    try {
      String op = "";

      // Buscamos el operador, ignorando si el primer número es negativo
      for (int i = 1; i < expression.length; i++) {
        if (expression[i] == "+" ||
            expression[i] == "-" ||
            expression[i] == "×" ||
            expression[i] == "÷") {
          op = expression[i];
          break;
        }
      }

      if (op.isEmpty) return expression;

      int opIndex = expression.indexOf(op, 1);
      if (opIndex == -1) return expression;

      double n1 = double.tryParse(expression.substring(0, opIndex)) ?? 0;
      double n2 = double.tryParse(expression.substring(opIndex + 1)) ?? 0;
      double result = 0;

      if (op == "+") result = n1 + n2;
      if (op == "-") result = n1 - n2;
      if (op == "×") result = n1 * n2;
      if (op == "÷") {
        if (n2 == 0) return "Error";
        result = n1 / n2;
      }

      String finalResult = result.toString();
      if (finalResult.endsWith(".0")) {
        finalResult = finalResult.substring(0, finalResult.length - 2);
      }
      return finalResult;
    } catch (e) {
      return "Error";
    }
  }

  Widget _buildButton(String buttonText, Color color, Color textColor) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: const EdgeInsets.symmetric(vertical: 22.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24), // Diseño más premium
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Definimos los colores aquí para mantener el código limpio
    final Color numColor = Colors.grey[850]!;
    final Color opColor = Colors.deepOrangeAccent;
    final Color actionColor = Colors.grey[400]!;
    final Color textWhite = Colors.white;
    final Color textBlack = Colors.black87;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Calculadora'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, size: 28),
            tooltip: 'Información',
            onPressed: () => Navigator.pushNamed(context, '/info'),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Text(
                _output,
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.w300,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              bottom: 24.0,
              left: 12.0,
              right: 12.0,
              top: 16.0,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildButton("CE", actionColor, textBlack),
                    _buildButton("C", actionColor, textBlack),
                    _buildButton("%", actionColor, textBlack),
                    _buildButton("÷", opColor, textWhite),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("7", numColor, textWhite),
                    _buildButton("8", numColor, textWhite),
                    _buildButton("9", numColor, textWhite),
                    _buildButton("×", opColor, textWhite),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4", numColor, textWhite),
                    _buildButton("5", numColor, textWhite),
                    _buildButton("6", numColor, textWhite),
                    _buildButton("-", opColor, textWhite),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("1", numColor, textWhite),
                    _buildButton("2", numColor, textWhite),
                    _buildButton("3", numColor, textWhite),
                    _buildButton("+", opColor, textWhite),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("+/-", numColor, textWhite),
                    _buildButton("0", numColor, textWhite),
                    _buildButton(".", numColor, textWhite),
                    _buildButton("=", Colors.green[500]!, textWhite),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
