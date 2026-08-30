import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provide a custom "now" for the entire app.
/// This allows us to test time-dependent features like the schedule.
final nowProvider = Provider<DateTime>((ref) {
  // Set to Sep 24, 2026 as requested by the user.
  // This helps bypass the need to change system time for testing schedules.
  return DateTime(2026, 9, 24, 9, 0);
});

/// A ticker that emits the "current" time relative to [nowProvider].
final nowTickerProvider = StreamProvider<DateTime>((ref) async* {
  final baseNow = ref.watch(nowProvider);

  // Emit the base time immediately
  yield baseNow;

  // Track when we started so we can provide a relative "tick"
  final systemStartTime = DateTime.now();

  await for (final _ in Stream.periodic(const Duration(minutes: 1))) {
    final elapsed = DateTime.now().difference(systemStartTime);
    yield baseNow.add(elapsed);
  }
});
