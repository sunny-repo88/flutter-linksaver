// // ignore_for_file: prefer_const_constructors
// import 'package:mocktail/mocktail.dart';
// import 'package:test/test.dart';
// import 'package:links_api/links_api.dart';
// import 'package:links_repository/links_repository.dart';

// class MockLinksApi extends Mock implements LinksApi {}

// class FakeLink extends Fake implements Link {}

// void main() {
//   group('LinksRepository', () {
//     late LinksApi api;

//     final links = [
//       Link(
//         id: 1,
//         title: 'title 1',
//       ),
//       Link(
//         id: 2,
//         title: 'title 2',
//       ),
//       Link(
//         id: 3,
//         title: 'title 3',
//       ),
//     ];

//     setUpAll(() {
//       registerFallbackValue(FakeLink());
//     });

//     setUp(() {
//       api = MockLinksApi();
//       // when(() => api.getLinks()).thenAnswer((_) => Stream.value(links));
//       when(() => api.saveLink(any())).thenAnswer((_) async {});
//       when(() => api.deleteLink(any())).thenAnswer((_) async {});
//     });

//     LinksRepository createSubject() => LinksRepository(linksApi: api);

//     group('constructor', () {
//       test('works properly', () {
//         expect(
//           createSubject,
//           returnsNormally,
//         );
//       });
//     });

//     group('getLinks', () {
//       test('makes correct api request', () {
//         final subject = createSubject();

//         expect(
//           subject.getLinks(),
//           isNot(throwsA(anything)),
//         );

//         verify(() => api.getLinks()).called(1);
//       });

//       test('returns stream of current list links', () {
//         expect(
//           createSubject().getLinks(),
//           emits(links),
//         );
//       });
//     });

//     group('saveLink', () {
//       test('makes correct api request', () {
//         final newLink = Link(
//           id: 4,
//           title: 'title 4',
//         );

//         final subject = createSubject();

//         expect(subject.saveLink(newLink), completes);

//         verify(() => api.saveLink(newLink)).called(1);
//       });
//     });

//     group('deleteLink', () {
//       test('makes correct api request', () {
//         final subject = createSubject();

//         expect(subject.deleteLink(links[0].id), completes);

//         verify(() => api.deleteLink(links[0].id)).called(1);
//       });
//     });
//   });
// }
