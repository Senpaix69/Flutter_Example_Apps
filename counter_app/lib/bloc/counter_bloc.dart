import 'package:counter_app/bloc/counter_actions.dart';
import 'package:counter_app/bloc/counter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterActions, CounterState> {
  CounterBloc() : super(const CounterState(counter: 0)) {
    on<IncrementCounter>((event, emit) {
      emit(CounterState(counter: state.counter + 1));
    });
    on<DecrementCounter>((event, emit) {
      emit(CounterState(counter: state.counter - 1));
    });
  }
}
