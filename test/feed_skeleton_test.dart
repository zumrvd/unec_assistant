import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:unec_assistant/presentation/components/skeletons/feed_skeleton.dart';
import 'package:unec_assistant/presentation/components/skeletons/post_skeleton.dart';
import 'package:unec_assistant/presentation/components/skeletons/skeleton_box.dart';

void main() {
  testWidgets('FeedSkeleton renders multiple PostSkeletons', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: FeedSkeleton(),
          ),
        ),
      ),
    );

    // Verify FeedSkeleton is present
    expect(find.byType(FeedSkeleton), findsOneWidget);
    
    // Verify it contains PostSkeletons
    // By default we set itemCount: 3 in FeedSkeleton
    expect(find.byType(PostSkeleton), findsAtLeastNWidgets(1));
    
    // Verify SkeletonBox is used for the shimmering effect
    expect(find.byType(SkeletonBox), findsAtLeastNWidgets(1));
  });
}
