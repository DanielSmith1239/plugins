// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of firebase_performance;

/// The Firebase Performance API.
///
/// You can get an instance by calling [FirebasePerformance.instance].
class FirebasePerformance {
  FirebasePerformance._();

  static int _traceCount = 0;

  @visibleForTesting
  static const MethodChannel channel =
      const MethodChannel('plugins.flutter.io/firebase_performance');

  /// Singleton of [FirebasePerformance].
  static final FirebasePerformance instance = new FirebasePerformance._();

  /// Determines whether performance monitoring is enabled or disabled.
  ///
  /// true if performance monitoring is enabled and false if performance
  /// monitoring is disabled. This is for dynamic enable/disable state. This
  /// does not reflect whether instrumentation is enabled/disabled.
  Future<bool> isPerformanceCollectionEnabled() async {
    final bool isEnabled = await channel
        .invokeMethod('FirebasePerformance#isPerformanceCollectionEnabled');
    return isEnabled;
  }

  /// Enables or disables performance monitoring.
  ///
  /// Enables or disables performance monitoring. This setting is persisted and
  /// applied on future invocations of your application. By default, performance
  /// monitoring is enabled.
  Future<void> setPerformanceCollectionEnabled(bool enable) async {
    await channel.invokeMethod(
        'FirebasePerformance#setPerformanceCollectionEnabled', enable);
  }

  /// Creates a [Trace] object with given [name].
  ///
  /// [name]: name of the trace. Requires no leading or trailing whitespace, no
  /// leading underscore _ character, max length of [Trace.maxTraceNameLength]
  /// characters.
  Trace newTrace(String name) {
    return new Trace._(_traceCount++, name);
  }

  /// Creates a [Trace] object with given [name] and start the trace.
  ///
  /// [name]: name of the trace. Requires no leading or trailing whitespace, no
  /// leading underscore _ character, max length of [Trace.maxTraceNameLength]
  /// characters.
  static Future<Trace> startTrace(String name) async {
    final Trace trace = instance.newTrace(name);
    await trace.start();
    return trace;
  }
}
