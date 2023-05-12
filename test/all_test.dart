import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/message.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/services/auth.dart';

import 'package:pinpoint/main.dart';

Future<void> main() async {
  setUpAll(() async {
    AuthService.testUser = User(name: 'jia', email: 'jx@aa.aa', avatar: '', id: 'ij9wetojeruiegr0i9g');
  });

  test('Can format a place', () {
    expect(formatPlaceType('bubble_tea_shop'), 'Bubble tea shop');
  });

  test('Can calculate distances', () {
    expect(distanceCalc(1, 1, 200, 200) > 3000000, true);
  });

  test('Can encode a message', () {
    expect(Message.encodeLocation('12345'), '__PINPOINT_LOCATION:{12345}__');
  });

  test('Can determine if encoded message', () {
    expect(Message.isEncodedLocation('__PINPOINT_LOCATION:{12345}__'), true);
  });

  test('Can decode a message', () {
    expect(Message.decodeLocation('__PINPOINT_LOCATION:{12345}__'), '12345');
  });
}
