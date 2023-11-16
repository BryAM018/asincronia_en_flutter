import 'package:flutter/material.dart';
import 'package:asincronia_en_flutter/service/mockapi.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Practica asincronia en flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Practica asincronia en flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, bool> buttonStates = {
    'Ferrari': false,
    'Hyundai': false,
    'FisherPrice': false,
  };

  Map<String, int> buttonData = {
    'Ferrari': 0,
    'Hyundai': 0,
    'FisherPrice': 0,
  };
  Future<void> _fetchDataAndUpdateState(String buttonName) async {
    int result = 0;
    if (buttonName == 'Ferrari') {
      result = await MockApi().getFerrariInteger();
    } else if (buttonName == 'Hyundai') {
      result = await MockApi().getHyundaiInteger();
    } else if (buttonName == 'FisherPrice') {
      result = await MockApi().getFisherPriceInteger();
    }
    setState(() {
      buttonData[buttonName] = result;
      buttonStates[buttonName] = false;
    });
  }

  // Método para expandir o contraer el botón según el estado
  void _updateButtonState(String buttonName, bool newState) {
    setState(() {
      buttonStates[buttonName] = newState;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    int counter = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildButton('Ferrari'),
            SizedBox(height: 20),
            _buildButton('Hyundai'),
            SizedBox(height: 20),
            _buildButton('FisherPrice'),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String buttonName) {
    bool isExpanded = buttonStates[buttonName] ?? false;
    Color buttonColor = Colors.orange; // Color por defecto

    // Asignar colores a cada botón
    if (buttonName == 'Ferrari') {
      buttonColor = Colors.green;
    } else if (buttonName == 'Hyundai') {
      buttonColor = Colors.amber;
    } else if (buttonName == 'FisherPrice') {
      buttonColor = Colors.red;
    }

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      width: isExpanded ? 200 : 150,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: buttonColor, // Aplicar el color al botón
        ),
        onPressed: () async {
          _updateButtonState(buttonName, true);
          await _fetchDataAndUpdateState(buttonName);
        },
        child: Text(
          '$buttonName: ${buttonData[buttonName]}',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
