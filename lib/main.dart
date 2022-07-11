import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

extension CompactMap<T> on Iterable<T?> {
  Iterable<T> compactMap<E>([
    E? Function(T?)? transform,
  ]) =>
      map(
        transform ?? (e) => e,
      ).where((e) => e != null).cast();
}

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

const url = 'https://bit.ly/3x7J5Qt';

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late final StreamController<double> controller;
    controller = useStreamController<double>(onListen: (() {
      controller.sink.add(0.0);
    }));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: StreamBuilder<double>(
        stream: controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          } else {
            final rotation = snapshot.data ?? 0.0;
            return GestureDetector(
              onTap: () {
                controller.sink.add(rotation + 10.0);
              },
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(rotation / 360),
                child: Center(
                  child: Image.network(url),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
