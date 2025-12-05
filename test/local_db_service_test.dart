import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:workout_notebook/data/services/local_db_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workout_notebook/utils/const.dart';
import 'package:workout_notebook/utils/enums/hive_box_keys.dart';
import 'package:workout_notebook/utils/exceptions.dart';

import 'utils/fake_data.dart';

class MockHive extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box {}

class FakeBox extends Fake implements Box {
  @override
  String get name => 'App';

  Map<String, List<Map<String, dynamic>>> fakeBoxState = {
    HiveBoxKey.exercises.name: <Map<String, dynamic>>[],
    HiveBoxKey.workouts.name: <Map<String, dynamic>>[],
  };
  @override
  get(key, {defaultValue}) {
    if (key == HiveBoxKey.exercises.name || HiveBoxKey.workouts.name == key) {
      return fakeBoxState[key];
    }
    return null;
  }

  @override
  Future<void> put(key, value) async {
    fakeBoxState[key] = value;
  }
}

void main() {
  group('LocalDbService', () {
    late HiveInterface mockHive;
    late LocalDbService service;
    late MockBox mockBox;
    late final Directory localPath;
    late FakeBox fakeBox;
    setUpAll(
      () async {
        TestWidgetsFlutterBinding.ensureInitialized();
        const MethodChannel channel = MethodChannel(
          'plugins.flutter.io/path_provider',
        );
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
              return ".";
            });
        localPath = await getApplicationDocumentsDirectory();
      },
    );
    group(
      '.init',
      () {
        setUp(
          () async {
            mockHive = MockHive()..init(localPath.path);
            service = LocalDbService(mockHive);
          },
        );

        test(
          'Should return istance of opened Box',
          () async {
            when(
              () => mockHive.openBox(boxName),
            ).thenAnswer((_) => Future.value(MockBox()));
            verifyNever(
              () => mockHive.openBox(boxName),
            ).called(0);
            final result = await service.init(boxName);
            expect(result, isA<Box>());
            verify(
              () => mockHive.openBox(boxName),
            ).called(1);
          },
        );
        test(
          'Should throw error',
          () async {
            when(
              () => mockHive.openBox(boxName),
            ).thenThrow(DbException("Can't connect to the local db."));

            expect(
              () => service.init(boxName),
              throwsA(
                isA<DbException>().having(
                  (e) => e.message,
                  'error msg',
                  "Can't connect to the local db.",
                ),
              ),
            );
          },
        );
      },
    );
    group(
      '.read',
      () {
        setUp(
          () async {
            mockHive = MockHive()..init(localPath.path);
            service = LocalDbService(mockHive);
            mockBox = MockBox();
          },
        );

        test(
          'should throw error if there is no specyfic key in the box',
          () async {
            when(
              () => mockHive.openBox(boxName),
            ).thenAnswer((_) => Future.value(mockBox));

            when(
              () => mockBox.get(any(that: isA<String>())),
            ).thenThrow(DbException("Can't read from the local db."));

            await service.init(boxName);

            expect(
              () => service.read(HiveBoxKey.exercises),
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
          'should return data if there is specyfic keys in the box',
          () async {
            when(
              () => mockHive.openBox(boxName),
            ).thenAnswer((_) => Future.value(mockBox));

            when(
              () => mockBox.get(any()),
            ).thenReturn(<Map<String, dynamic>>[]);

            final data = await service.read(HiveBoxKey.exercises);
            final data2 = await service.read(HiveBoxKey.workouts);

            expect(data, isList);
            expect(data2, isList);
          },
        );
      },
    );

    group(
      '.write',
      () {
        setUp(
          () {
            mockHive = MockHive()..init(localPath.path);
            service = LocalDbService(mockHive);
            fakeBox = FakeBox();
            mockBox = MockBox();
          },
        );

        test(
          'Should add one element to the list specified by the key',
          () async {
            when(
              () => mockHive.openBox(any(that: isA<String>())),
            ).thenAnswer(
              (_) => Future.value(fakeBox),
            );

            final initExcersiceState = await service.read(HiveBoxKey.exercises);
            expect(initExcersiceState, isList);
            expect(initExcersiceState, isEmpty);
            await service.write(HiveBoxKey.exercises, [
              FakeData.getExerciseAsMap(),
            ]);
            final newExcersiceState = await service.read(HiveBoxKey.exercises);
            expect(newExcersiceState, isNotEmpty);
            expect(newExcersiceState, hasLength(1));
          },
        );
        test(
          'Should throw an error',
          () async {
            when(
              () => mockHive.openBox(boxName),
            ).thenAnswer(
              (_) => Future.value(mockBox),
            );

            when(
              () => mockBox.put(
                any(that: isA<String>()),
                any(that: isA<List<dynamic>>()),
              ),
            ).thenThrow(DbException("Can't put data into the local db."));

            expect(
              () => service.write(HiveBoxKey.exercises, []),
              throwsA(
                isA<DbException>().having(
                  (e) => e.message,
                  'error msg',
                  "Can't put data into the local db.",
                ),
              ),
            );
          },
        );
      },
    );
  });
}
