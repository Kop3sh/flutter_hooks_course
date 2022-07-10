import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

Stream<String> getTime() => Stream.periodic(
      const Duration(seconds: 1),
      (_) => DateTime.now().toIso8601String(),
    );

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final datetime = useStream(getTime());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          datetime.data ?? 'Home Page',
        ),
      ),
    );
  }
}
