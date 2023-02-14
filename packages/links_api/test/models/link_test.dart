// ignore_for_file: avoid_redundant_argument_values
import 'package:test/test.dart';
import 'package:links_api/links_api.dart';

void main() {
  group('Link', () {
    Link createSubject({
      int id = 1,
      String title = 'title',
      String link = 'https://google.com',
      int isPrivate = 0,
    }) {
      return Link(
        id: id,
        title: title,
        link: link,
        isPrivate: isPrivate,
      );
    }

    group('constructor', () {
      test('works correctly', () {
        expect(
          createSubject,
          returnsNormally,
        );
      });

      // test('throws AssertionError when id is empty', () {
      //   expect(
      //     () => createSubject(id: null),
      //     throwsA(isA<AssertionError>()),
      //   );
      // });

      // test('sets id if not provided', () {
      //   expect(
      //     createSubject(id: null).id,
      //     isNotEmpty,
      //   );
      // });
    });

    test('supports value equality', () {
      expect(
        createSubject(),
        equals(createSubject()),
      );
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          '1', // id
          'title', // title
          'https://google.com', // link
          false,
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            id: null,
            title: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            id: 2,
            title: 'new title',
          ),
          equals(
            createSubject(
              id: 2,
              title: 'new title',
              link: 'https://google.com',
            ),
          ),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          Link.fromJson(<String, dynamic>{
            'id': '1',
            'title': 'title',
            'link': 'https://google.com',
            'isPrivate': false,
          }),
          equals(createSubject()),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{
            'id': '1',
            'title': 'title',
            'link': 'https://google.com',
            'isPrivate': false,
          }),
        );
      });
    });
  });
}
