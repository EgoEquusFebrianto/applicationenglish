import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:applicationenglish/fitur/Challanges/Sentences/_services.dart';
import 'package:applicationenglish/fitur/login_and_regist/auth_firebase.dart';

// Mock Firebase Authentication
class MockAuthFirebase extends Mock implements MyauthFirebase {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Login Integration Tests', () {
    late ClickedButtonListProvider provider;

    setUp(() {
      provider = ClickedButtonListProvider();
    });


    test('setLevel should update the level and clear data', () {
      provider.setLevel(2);

      expect(provider.level, 2);
      expect(provider.elementList.isEmpty, true);
      expect(provider.element.isEmpty, true);
      expect(provider.firstContainer.isEmpty, true);
      expect(provider.answer.isEmpty, true);
    });


    test('updateFirstContainer should add or remove item from firstContainer', () {
      final testItem = {'id': 1, 'name': 'Test Item'};

      // Add item to firstContainer
      provider.updateFirstContainer(false, testItem);
      expect(provider.firstContainer.length, 1);
      expect(provider.firstContainer.first, testItem);

      // Remove item from firstContainer
      provider.updateFirstContainer(true, testItem);
      expect(provider.firstContainer.isEmpty, true);
    });
  });
}
