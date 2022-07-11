import 'dart:async';
import 'dart:math';
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

enum Action {
  rotLeft,
  rotRight,
  moreVisible,
  lessVisible,
}

@immutable
class State {
  final double rotationDeg;
  final double alpha;

  const State({
    required this.rotationDeg,
    required this.alpha,
  });

  const State.zero()
      : rotationDeg = 0.0,
        alpha = 1.0;

  State rotRight() => State(
        rotationDeg: rotationDeg + 10.0,
        alpha: alpha,
      );
  State rotLeft() => State(
        rotationDeg: rotationDeg - 10.0,
        alpha: alpha,
      );
  State increaseAlpha() => State(
        rotationDeg: rotationDeg,
        alpha: min(alpha + 0.1, 1.0),
      );
  State decreaseAlpha() => State(
        rotationDeg: rotationDeg,
        alpha: max(alpha - 0.1, 0.0),
      );
}

State reducer(State oldState, Action? action) {
  switch (action) {
    case Action.rotLeft:
      return oldState.rotRight();
    case Action.rotRight:
      return oldState.rotLeft();
    case Action.moreVisible:
      return oldState.increaseAlpha();
    case Action.lessVisible:
      return oldState.decreaseAlpha();
    case null:
      return oldState;
  }
}

class HomePage extends HookWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = useReducer<State, Action?>(
      reducer,
      initialState: const State.zero(),
      initialAction: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: (() {
                  store.dispatch(Action.rotRight);
                }),
                child: const Text("Rotate Right"),
              ),
              TextButton(
                onPressed: (() {
                  store.dispatch(Action.rotLeft);
                }),
                child: const Text("Rotate Left"),
              ),
              TextButton(
                onPressed: (() {
                  store.dispatch(Action.moreVisible);
                }),
                child: const Text("+ Alpha"),
              ),
              TextButton(
                onPressed: (() {
                  store.dispatch(Action.lessVisible);
                }),
                child: const Text("- Alpha"),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          ),
          Opacity(
            opacity: store.state.alpha,
            child: RotationTransition(
                turns: AlwaysStoppedAnimation(store.state.rotationDeg / 360.0),
                child: Image.network(url)),
          ),
        ],
      ),
    );
  }
}
