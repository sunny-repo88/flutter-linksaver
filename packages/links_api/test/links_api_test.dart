import 'package:test/test.dart';
import 'package:links_api/links_api.dart';

class TestLinksApi extends LinksApi {
  TestLinksApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('LinksApi', () {
    test('can be constructed', () {
      expect(TestLinksApi.new, returnsNormally);
    });
  });
}
