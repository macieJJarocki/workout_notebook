part of 'form_validator_cubit.dart';

@immutable
// TODO delete this??
class FormValidatorState {
  final AutovalidateMode? mode;
  final String? name;
  final String? weight;
  final String? repetitions;
  final String? sets;

  const FormValidatorState({
    this.mode = AutovalidateMode.always,
    this.name = '',
    this.weight = '',
    this.repetitions = '',
    this.sets = '',
  });

  FormValidatorState copyWith({
    AutovalidateMode? mode,
    String? name,
    String? weight,
    String? repetitions,
    String? sets,
  }) {
    return FormValidatorState(
      mode: mode ?? this.mode,
      name: name ?? this.name,
      weight: weight ?? this.weight,
      repetitions: repetitions ?? this.repetitions,
      sets: sets ?? this.sets,
    );
  }
}
