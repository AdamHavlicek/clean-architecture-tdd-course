import 'package:clean_architecture_tdd_course/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_info_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<InternetConnectionChecker>(),
])
void main() {
  late NetworkInfoImpl tNetworkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();

    tNetworkInfoImpl =
        NetworkInfoImpl(connectionChecker: mockInternetConnectionChecker);
  });

  group('isConnected', () {

    test('should forward the call to [DataConnectionChecker.hasConnection]', () async {
      // Arrange
      final Future<bool> expectedResult = Future.value(true);

      // Mock
      when(
        mockInternetConnectionChecker.hasConnection
      ).thenAnswer((_) => expectedResult);
      
      // Act
      final result = tNetworkInfoImpl.isConnected;
      
      // Assert
      verify(mockInternetConnectionChecker.hasConnection).called(1);
      expect(result, expectedResult);
    });

  },);
}
