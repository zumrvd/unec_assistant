# Implementation Plan - Dynamic File Count Synchronization

Synchronize the `fileCount` displayed in the materials list with the actual number of files defined in the materials provider.

## User Review Required

> [!IMPORTANT]
> This change will remove the hardcoded `fileCount` values from `subject_detail_provider.dart` and replace them with dynamically calculated values based on the contents of `materials_providers.dart`.

## Proposed Changes

### 1. Data Model Enhancement
#### [MODIFY] [subject_detail.dart](file:///C:/src/unec_assistant/lib/models/subject_detail.dart)
- Add a `copyWith` method to the `SubjectDetail` class to allow easy updating of individual fields (like `fileCount`) while keeping the rest of the object's state.

### 2. Materials Logic Consolidation
#### [MODIFY] [materials_providers.dart](file:///C:/src/unec_assistant/lib/providers/materials_providers.dart)
- Create a constant map `kSubjectLecturesMap` that associates subject IDs ('1', '2', etc.) with their respective lecture lists (`kProgLectures`, etc.).
- Add a helper function `calculateTotalFiles(List<LectureMaterial> lectures)` that sums up the length of the `files` list for each lecture.

### 3. Provider Synchronization
#### [MODIFY] [subject_detail_provider.dart](file:///C:/src/unec_assistant/lib/providers/subject_detail_provider.dart)
- Update `allSubjectsProvider` to:
    1. Reference the data from `materials_providers.dart`.
    2. Iterate through the base subject details (`kProgDetail`, etc.).
    3. Calculate the actual file count for each subject.
    4. Return a new list of `SubjectDetail` objects with the correct `fileCount` populated via `copyWith`.

## Verification Plan

### Automated Tests
- N/A (Project uses manual verification).

### Manual Verification
- Add or remove a `LectureFile` in `kProgLectures` inside `materials_providers.dart`.
- Restart the app or trigger a rebuild.
- Verify that the "X files" label in the Teaching Materials screen for "Programlaşdırmanın əsasları" updates correctly to match the new count.
- Repeat for other subjects to ensure the mapping is correct.
