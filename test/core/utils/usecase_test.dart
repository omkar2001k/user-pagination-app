import 'package:flutter_test/flutter_test.dart';
import 'package:user_pagination_app/core/utils/usecase.dart';

void main() {
  test('NoParams equality and props', () {
    final params1 = NoParams();
    final params2 = NoParams();

    expect(params1, equals(params2));
    expect(params1.props, isEmpty);
  });
}
