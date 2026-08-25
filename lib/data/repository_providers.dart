import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'academic_repository.dart';
import 'materials_repository.dart';
import 'mock_academic_repository.dart';
import 'mock_materials_repository.dart';
import 'mock_schedule_repository.dart';
import 'schedule_repository.dart';

// =============================================================================
// THIS IS THE ONLY FILE YOU NEED TO EDIT ON API INTEGRATION DAY.
//
// Replace each MockXxxRepository() with ApiXxxRepository(ref.read(...))
// and all three academic domains automatically use the real backend.
// No provider, notifier, or screen file needs to change.
// =============================================================================

/// The active semester used by all academic data fetches.
///
/// When authentication is implemented, derive this from the user's session
/// token or a dedicated `/v1/semesters/current` endpoint.
const kCurrentSemesterId = 'fall-2025';

/// Provides the [AcademicRepository] (subjects · grades · attendance).
///
/// To switch to the real API:
/// ```dart
/// final academicRepositoryProvider = Provider<AcademicRepository>(
///   (ref) => ApiAcademicRepository(httpClient: ref.read(httpClientProvider)),
/// );
/// ```
final academicRepositoryProvider = Provider<AcademicRepository>(
  (_) => MockAcademicRepository(),
);

/// Provides the [ScheduleRepository] (semester timetable · exam events).
///
/// To switch to the real API:
/// ```dart
/// final scheduleRepositoryProvider = Provider<ScheduleRepository>(
///   (ref) => ApiScheduleRepository(httpClient: ref.read(httpClientProvider)),
/// );
/// ```
final scheduleRepositoryProvider = Provider<ScheduleRepository>(
  (_) => MockScheduleRepository(),
);

/// Provides the [MaterialsRepository] (lecture files · presentations · quizzes).
///
/// To switch to the real API:
/// ```dart
/// final materialsRepositoryProvider = Provider<MaterialsRepository>(
///   (ref) => ApiMaterialsRepository(httpClient: ref.read(httpClientProvider)),
/// );
/// ```
final materialsRepositoryProvider = Provider<MaterialsRepository>(
  (_) => MockMaterialsRepository(),
);
