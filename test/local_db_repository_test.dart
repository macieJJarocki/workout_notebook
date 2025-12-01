import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workout_notebook/data/models/exercise.dart';
import 'package:workout_notebook/data/models/model.dart';
import 'package:workout_notebook/data/repository/local_db_repository.dart';
import 'package:workout_notebook/data/services/local_db_service.dart';
import 'package:workout_notebook/utils/enums.dart';
import 'package:workout_notebook/utils/exceptions.dart';

import 'utils/fake_data.dart';

class MockService extends Mock implements LocalDbService {}

class FakeService extends Fake implements LocalDbService {
  final Map<String, dynamic> fakeState = {
    HiveBoxKey.exercises.name: <Map<String, dynamic>>[],
    HiveBoxKey.workouts.name: <Map<String, dynamic>>[],
  };

  @override
  Future<List<Map<String, dynamic>>> read(HiveBoxKey key) async {
    return fakeState[key.name];
  }

  @override
  Future<void> write(HiveBoxKey key, List<Map<String, dynamic>> list) async {
    fakeState[key.name] = list;
  }
}

void main() {
  late LocalDbService mockService;
  late LocalDbRepository fakeRepository;
  late LocalDbRepository repository;

  group(
    'LocalDbRepository',
    () {
      group(
        '.read',
        () {
          setUp(
            () {
              mockService = MockService();
              repository = LocalDbRepository(mockService);
            },
          );
          test(
            'should return list of models',
            () async {
              when(
                () => mockService.read(HiveBoxKey.exercises),
              ).thenAnswer(
                (_) => Future.value(<Map<String, dynamic>>[]),
              );
              final data = await repository.read(HiveBoxKey.exercises);
              verify(
                () => mockService.read(HiveBoxKey.exercises),
              ).called(1);
              expect(data, isA<List<Model>>());
            },
          );
          test(
            'should throw an error if the key does not occurred in the HiveBoxKey ',
            () async {
              when(
                () => mockService.read(HiveBoxKey.exercises),
              ).thenThrow(DbException("Can't read from the local db."));

              expect(
                () => repository.read(HiveBoxKey.exercises),
                throwsA(
                  isA<DbException>().having(
                    (e) => e.message,
                    'error msg',
                    "Can't read from the local db.",
                  ),
                ),
              );
            },
          );
        },
      );
      group(
        '.write',

        () {
          late FakeService fakeService;
          setUp(
            () {
              fakeService = FakeService();
              fakeRepository = LocalDbRepository(fakeService);
              mockService = MockService();
              repository = LocalDbRepository(mockService);
            },
          );
          test(
            'should add one element to the value returned from the LocalDbService',
            () async {
              final oldServiceState = await fakeRepository.read(
                HiveBoxKey.exercises,
              );
              expect(oldServiceState.length, 0);
              expect(oldServiceState, isEmpty);

              await fakeRepository.write(
                HiveBoxKey.exercises,
                FakeData.getExercise(),
              );

              final newServiceState = await fakeRepository.read(
                HiveBoxKey.exercises,
              );
              expect(newServiceState.length, 1);
              expect(newServiceState, isNotEmpty);
            },
          );
          test('should rethrow error from the LocalDbService.write', () async {
            when(
              () => mockService.read(HiveBoxKey.exercises),
            ).thenAnswer((_) async => [FakeData.getExerciseAsMap()]);

            when(
              () => mockService.write(HiveBoxKey.exercises, any()),
            ).thenThrow(DbException("Can't put data into the local db."));

            expect(
              () => repository.write(
                HiveBoxKey.exercises,
                FakeData.getExercise(),
              ),
              throwsA(
                isA<DbException>().having(
                  (e) => e.message,
                  'error msg',
                  "Can't put data into the local db.",
                ),
              ),
            );
          });
        },
      );
      group(
        '.update',
        () {
          setUp(
            () {
              mockService = MockService();
              repository = LocalDbRepository(mockService);
            },
          );
          test(
            'Should rethrow error from LocalDbService.read.',
            () {
              when(
                () => mockService.read(HiveBoxKey.exercises),
              ).thenThrow(DbException("Can't read from the local db."));
              expect(
                () => repository.update(
                  HiveBoxKey.exercises,
                  FakeData.getExercise(),
                ),
                throwsA(
                  isA<DbException>().having(
                    (e) => e.message,
                    'error msg',
                    "Can't read from the local db.",
                  ),
                ),
              );
            },
          );
          test('Should rethrow error from LocalDbService.write.', () {
            when(
              () => mockService.read(HiveBoxKey.exercises),
            ).thenAnswer(
              (_) async => [FakeData.getExerciseAsMap()],
            );

            when(
              () => mockService.write(HiveBoxKey.exercises, [
                FakeData.getExerciseAsMap(),
              ]),
            ).thenThrow(DbException("Can't put data into the local db."));

            expect(
              () => repository.update(
                HiveBoxKey.exercises,
                FakeData.getExercise(),
              ),
              throwsA(
                isA<DataException>().having(
                  (e) => e.message,
                  'error msg',
                  "Can't put data into the local db.",
                ),
              ),
            );
          }, skip: true);
          test(
            'Should update Exercise.repetitions based on the Exercise.id',
            () async {
              final LocalDbService fakeService = FakeService();
              final LocalDbRepository fakeRepository = LocalDbRepository(
                fakeService,
              );
              await fakeRepository.write(
                HiveBoxKey.exercises,
                FakeData.getExercise(),
              );
              final data = await fakeRepository.read(HiveBoxKey.exercises);
              await fakeRepository.update(
                HiveBoxKey.exercises,
                (Exercise(
                  id: 1,
                  name: 'hip thrust',
                  weight: 20.0,
                  repetitions: 2,
                  sets: 3,
                )),
              );

              final updatedData = await fakeRepository.read(
                HiveBoxKey.exercises,
              );

              final previousExercise = data[0] as Exercise;
              final updatedExercise = updatedData[0] as Exercise;
              expect(data[0].id, equals(updatedData[0].id));
              expect(
                previousExercise.repetitions,
                isNot(equals(updatedExercise.repetitions)),
              );
            },
          );
        },
      );
      group(
        '.delete',
        () {
          late FakeService fakeService;
          setUp(
            () {
              mockService = MockService();
              fakeService = FakeService();
              repository = LocalDbRepository(mockService);
            },
          );
          test(
            'should rethrow error from LocalDbService.read',
            () {
              when(
                () => mockService.read(HiveBoxKey.exercises),
              ).thenThrow(DbException("Can't read from the local db."));

              expect(
                () => repository.delete(
                  HiveBoxKey.exercises,
                  FakeData.getExercise(),
                ),
                throwsA(
                  isA<DbException>().having(
                    (e) => e.message,
                    'error msg',
                    "Can't read from the local db.",
                  ),
                ),
              );
            },
          );
          test(
            'should delete Exercise based on Exercise.id.',
            () async {
              repository = LocalDbRepository(fakeService);

              await repository.write(
                HiveBoxKey.exercises,
                Exercise(
                  id: 1,
                  name: 'test',
                  weight: 10,
                  repetitions: 10,
                  sets: 2,
                ),
              );
              await repository.write(
                HiveBoxKey.exercises,
                Exercise(
                  id: 2,
                  name: 'test',
                  weight: 10,
                  repetitions: 10,
                  sets: 2,
                ),
              );
              final data = await repository.read(HiveBoxKey.exercises);
              expect(data, hasLength(2));
              await repository.delete(
                HiveBoxKey.exercises,
                Exercise(
                  id: 1,
                  name: 'test',
                  weight: 10,
                  repetitions: 10,
                  sets: 2,
                ),
              );
              final newData = await repository.read(HiveBoxKey.exercises);
              expect(newData, hasLength(1));
            },
          );
        },
      );
    },
  );
}
