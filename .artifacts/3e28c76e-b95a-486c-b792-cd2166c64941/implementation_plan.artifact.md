# Implementation Plan - News Feed Bug Fixes & UI Polish

Address functional issues with filtering, interactivity, and navigation, while refining the UI to be pixel-perfect and consistent with the project's background theme.

## User Review Required

> [!IMPORTANT]
> - **ID Alignment**: I will synchronize post and channel IDs across `dashboard_provider.dart` and `mock_feed_repository.dart` to fix the "Post not found" error when navigating from the Home screen.
> - **Background Reset**: Reverting the feed and post detail screens to the canonical `#F8F9FC` background color.
> - **Rich Interactivity**: Implementing the "Subscribe" toggle and full comment interactivity (likes and threaded replies).

## Proposed Changes

### 1. Data & Logic Synchronization
#### [MODIFY] [dashboard_provider.dart](file:///C:/src/unec_assistant/lib/providers/dashboard_provider.dart)
- Update mock post IDs to `'p1'`, `'p2'` to match the repository identifiers.
#### [MODIFY] [mock_feed_repository.dart](file:///C:/src/unec_assistant/lib/data/mock_feed_repository.dart)
- Add more mock replies to demonstrate threaded comments.
- Ensure unique author IDs are mapped to diverse user accounts.

### 2. Provider Improvements
#### [MODIFY] [feed_provider.dart](file:///C:/src/unec_assistant/lib/providers/feed_provider.dart)
- Fix `setFilter` logic to allow resetting to "Discover" correctly.
#### [MODIFY] [post_detail_provider.dart](file:///C:/src/unec_assistant/lib/providers/post_detail_provider.dart)
- Implement `toggleCommentLike` logic with state updates.
- Refine reply loading and submission logic.

### 3. Component Refinement
#### [MODIFY] [post_card.dart](file:///C:/src/unec_assistant/lib/presentation/components/cards/post_card.dart)
- Ensure the entire card surface is tappable for navigation.
- Match visual spacing and background colors to the reference images.
#### [MODIFY] [comment_tile.dart](file:///C:/src/unec_assistant/lib/presentation/components/cards/comment_tile.dart)
- Correctly resolve author names and initials from the provided user map.
- Improve spacing and indenting for replies.

### 4. Screen Overhaul
#### [MODIFY] [feed_main_screen.dart](file:///C:/src/unec_assistant/lib/screens/feed/feed_main_screen.dart)
- Update background to `#F8F9FC`.
- Match filter tab active/inactive states exactly to the mockup.
#### [MODIFY] [post_detail_screen.dart](file:///C:/src/unec_assistant/lib/screens/feed/post_detail_screen.dart)
- Update background to `#F8F9FC`.
- **Header**: Add a functional "Subscribe" pill button and "3 dots" overflow menu.
- **Engagement**: Fully wire Like, Comment (scroll to section), and Share actions.
- **Comment Section**: Implement a real `PopupMenuButton` for the sort dropdown.

## Verification Plan

### Manual Verification
- **Home -> Feed**: Tap the post card on the Home screen and confirm it loads successfully.
- **Filtering**: Tap "Clubs", then tap "Discover". Verify the list resets to show all posts.
- **Interactions**: Like a comment and verify the heart turns red and count increments.
- **Replies**: Tap "View replies" on a comment and verify nested tiles appear.
- **Visuals**: Confirm the background color matches the rest of the app's functions.
