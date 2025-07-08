import 'package:flutter/material.dart';

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  late int abc;
  @override
  void initState() {
    super.initState();
    abc = 10; // Initialize the variable here
    // This method is called when the widget is first created.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This method is called when the widget's dependencies change.
  }

  @override
  void didUpdateWidget(covariant MyStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // This method is called when the widget is updated.
  }

  @override
  void dispose() {
    // This method is called when the widget is removed from the widget tree.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Wrap(
                    children: [
                      ListTile(
                        leading: Icon(Icons.share),
                        title: Text('Share'),
                      ),
                      ListTile(
                        leading: Icon(Icons.copy),
                        title: Text('Copy'),
                        
                      ),
                      ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      ),
                    ],
                  );
                },
              );
            },
            child: Text(
              'Hello World',
              style: TextStyle(fontSize: 24, color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }
}
