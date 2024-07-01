import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_table/base_view.dart';
import 'package:my_table/my_table.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  MyTableType selectedType = MyTableType.values.first;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: Scaffold(
        body: BaseView(
          value: selectedType,
          onSelected: (type) {
            setState(() {
              selectedType = type;
            });
          },
          child: ListView(
            children: [
              const SizedBox(
                height: 150,
                child: Placeholder(
                  color: Colors.black12,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 4,
                        spreadRadius: 4,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: MyTable(
                    type: selectedType,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
