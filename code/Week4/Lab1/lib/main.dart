import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String result = '0';

  Widget calculatorButton(String text, {bool blue = false}) {
    return Expanded(
      child: Container(
        height: 65,
        margin: const EdgeInsets.all(2),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: blue ? Colors.blue : Colors.grey.shade100,
            foregroundColor: blue ? Colors.white : Colors.black,
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          onPressed: () {
            setState(() {
              if (text == 'C' || text == 'CE') {
                result = '0';
              } else if (text == '=') {
                result = '0';
              } else if (text == '⌫') {
                if (result.length > 1) {
                  result = result.substring(0, result.length - 1);
                } else {
                  result = '0';
                }
              } else {
                if (result == '0') {
                  result = text;
                } else {
                  result += text;
                }
              }
            });
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: blue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget memoryButton(String text) {
    return Expanded(
      child: TextButton(
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // THANH TRÊN
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.grey),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        title: const Text(
          'Standard',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),

      // DRAWER
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 35),

            ListTile(
              leading: const Icon(Icons.calculate),
              title: const Text('Calculator'),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.calculate_outlined),
              title: const Text('Standard'),
              selected: true,
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(Icons.science_outlined),
              title: const Text('Scientific'),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Graphing'),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Programmer'),
              onTap: () {},
            ),

            ListTile(
              leading: const Icon(Icons.calendar_month),
              title: const Text('Date calculation'),
              onTap: () {},
            ),

            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Converter',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.currency_exchange),
              title: const Text('Currency'),
            ),

            ListTile(
              leading: const Icon(Icons.view_in_ar),
              title: const Text('Volume'),
            ),

            ListTile(
              leading: const Icon(Icons.straighten),
              title: const Text('Length'),
            ),

            ListTile(
              leading: const Icon(Icons.scale),
              title: const Text('Weight and mass'),
            ),

            ListTile(
              leading: const Icon(Icons.device_thermostat),
              title: const Text('Temperature'),
            ),

            ListTile(
              leading: const Icon(Icons.local_fire_department),
              title: const Text('Energy'),
            ),

            ListTile(
              leading: const Icon(Icons.grid_on),
              title: const Text('Area'),
            ),

            ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Speed'),
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),

      // NỘI DUNG CHÍNH
      body: Column(
        children: [
          // MÀN HÌNH HIỂN THỊ
          Expanded(
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.only(right: 15, bottom: 10),
              child: Text(
                result,
                style: const TextStyle(
                  fontSize: 50,
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),

          // THANH MEMORY
          SizedBox(
            height: 40,
            child: Row(
              children: [
                memoryButton('MC'),
                memoryButton('MR'),
                memoryButton('M+'),
                memoryButton('M-'),
                memoryButton('MS'),
                memoryButton('M▼'),
              ],
            ),
          ),

          // HÀNG 1
          Row(
            children: [
              calculatorButton('%'),
              calculatorButton('CE'),
              calculatorButton('C'),
              calculatorButton('⌫'),
            ],
          ),

          // HÀNG 2
          Row(
            children: [
              calculatorButton('1/x'),
              calculatorButton('x²'),
              calculatorButton('²√x'),
              calculatorButton('÷'),
            ],
          ),

          // HÀNG 3
          Row(
            children: [
              calculatorButton('7'),
              calculatorButton('8'),
              calculatorButton('9'),
              calculatorButton('×'),
            ],
          ),

          // HÀNG 4
          Row(
            children: [
              calculatorButton('4'),
              calculatorButton('5'),
              calculatorButton('6'),
              calculatorButton('−'),
            ],
          ),

          // HÀNG 5
          Row(
            children: [
              calculatorButton('1'),
              calculatorButton('2'),
              calculatorButton('3'),
              calculatorButton('+'),
            ],
          ),

          // HÀNG 6
          Row(
            children: [
              calculatorButton('+/-'),
              calculatorButton('0'),
              calculatorButton('.'),
              calculatorButton('=', blue: true),
            ],
          ),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
