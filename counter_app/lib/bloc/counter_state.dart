import 'package:flutter/material.dart' show immutable;

@immutable
class CounterState {
  final int counter;
  const CounterState({required this.counter});
}
