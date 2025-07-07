import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDark ? ThemeData.dark() : ThemeData.light(),
      home: Calculator(
        isDark: isDark,
        toggleTheme: () => setState(() => isDark = !isDark),
      ),
    );
  }
}

class Calculator extends StatefulWidget {
  final bool isDark;
  final VoidCallback toggleTheme;
  const Calculator({super.key, required this.isDark, required this.toggleTheme});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  String expr = '', res = '';

  void onTap(String value) {
    setState(() {
      if (value == 'C') {
        expr = '';
        res = '';
      } else if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expr);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          res = eval.toString();
        } catch (e) {
          res = 'Error';
        }
      } else {
        expr += value;
      }
    });
  }

  Color get bgColor => widget.isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get buttonBg => widget.isDark ? const Color(0xFF2D2D2D) : const Color(0xFFF1F2F6);
  Color get txtColor => widget.isDark ? Colors.white : Colors.black87;

  @override
  Widget build(BuildContext context) {
    List<String> buttons = [
      'C', '(', ')', '/',
      '7', '8', '9', '*',
      '4', '5', '6', '-',
      '1', '2', '3', '+',
      '0', '00', '.', '='
    ];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        title: Text(
          'Calculator',
          style: TextStyle(color: txtColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode, color: txtColor),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: buttonBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      expr,
                      style: TextStyle(fontSize: 28, color: txtColor),
                    ),
                    Text(
                      res,
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: txtColor),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              flex: 5,
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: (context, index) {
                  final isOperator = ['/', '*', '-', '+', '='].contains(buttons[index]);

                  return GestureDetector(
                    onTap: () => onTap(buttons[index]),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isOperator ? Colors.white : buttonBg,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: widget.isDark ? Colors.black45 : Colors.grey.shade300,
                            offset: const Offset(2, 2),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          buttons[index],
                          style: TextStyle(
                            fontSize: 24,
                            color: isOperator ? Colors.black : txtColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
