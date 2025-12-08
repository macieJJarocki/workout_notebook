import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'form_validator_state.dart';

class FormValidatorCubit extends Cubit<FormValidatorState> {
  // TODO delete this??
  FormValidatorCubit() : super(FormValidatorState());

  void _updateNameField(String? value) {
    emit(state.copyWith(name: value));
  }

  void _updateWeightField(String? value) {
    emit(state.copyWith(weight: value));
  }

  void _updateRepetitionsFirld(String? value) {
    emit(state.copyWith(repetitions: value));
  }

  void _updateSetsField(String? value) {
    emit(state.copyWith(sets: value));
  }

  void _updateValidationMode(AutovalidateMode value) {
    emit(state.copyWith(mode: value));
  }
}
