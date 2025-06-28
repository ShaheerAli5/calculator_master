import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Calculator(
        isDarkMode: isDarkMode,
        onThemeChanged: (value) {
          setState(() {
            isDarkMode = value;
          });
        },
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  Calculator({required this.isDarkMode, required this.onThemeChanged});

  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expression = '';
  String result = '';

  void _numClick(String text) {
    setState(() {
      expression += text;
    });
  }

  void _clear(String text) {
    setState(() {
      expression = '';
      result = '';
    });
  }

  void _evaluate(String text) {
    Parser p = Parser();
    ContextModel cm = ContextModel();
    try {
      Expression exp = p.parse(expression);
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        result = eval.toString();
      });
    } catch (e) {
      setState(() {
        result = 'Error';
      });
    }
  }

  void _newChatPressed() {
    setState(() {
      expression = '';
      result = ''; // Clear all previous chat/input/result
    });
  }

  Widget _buildButton(String text, {Color? color, double fontSize = 24}) {
    return ElevatedButton(
      onPressed: () {
        if (text == 'C') {
          _clear(text);
        } else if (text == '=') {
          _evaluate(text);
        } else {
          _numClick(text);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Theme.of(context).colorScheme.secondary,
        padding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: widget.isDarkMode ? Colors.black : Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = widget.isDarkMode ? Colors.white : Colors.black;
    final newChatTextColor = Colors.purple;

    return Scaffold(
      appBar: AppBar(
        title: const Text(' Smart Calculator'),
        actions: [
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
            activeColor: Colors.yellow,
            inactiveThumbColor: Colors.black,
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDarkMode
                ? [Colors.black, Colors.grey.shade800]
                : [Colors.white, Colors.grey.shade200],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Display input expression
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  expression,
                  style: TextStyle(fontSize: 32, color: textColor),
                ),
              ),

              // Display result
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  result,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),

              // "New Chat" button - small, left aligned, attractive
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: _newChatPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(color: newChatTextColor, width: 2),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    "New Chat",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: newChatTextColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Calculator buttons grid
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  '7', '8', '9', '/',
                  '4', '5', '6', '*',
                  '1', '2', '3', '-',
                  'C', '0', '=', '+',
                ].map((e) => _buildButton(e, color: Colors.white)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
