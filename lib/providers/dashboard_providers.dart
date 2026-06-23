import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unec_assistant/models/feed_post.dart';
import 'package:unec_assistant/models/used_function.dart';

final feedPostsProvider = Provider<List<FeedPost>>(
  (ref) => const [
    FeedPost(
      id: '1',
      title: 'YAZ semestri ara imtahan cədvəli',
      content:
          '2025/2026-ci tədris ilinin YAZ semestri üçün ara imtahan cədvəli açıqlanmışdır. Cədvəl ilə aşağıdakı linkə daxil olmaqla tanış ola bilərsiz.\n\nLink : https://unec.edu.az/bakalavriatura-seviyyesi-uzre-2025-2026-ci-tedris-ilinin-yaz-semestrinin-ara-qiymetlendirme-imtahani-cedveli/',
      category: 'Official',
      dateString: '2 hours ago',
      channelName: 'Rektorat Kanalı',
      likeCount: 122,
      commentCount: 6,
    ),
  ],
);

final recentPostProvider = Provider<FeedPost>(
  (ref) => ref.watch(feedPostsProvider).first,
);

final recentFunctionProvider = Provider<UsedFunction>(
  (ref) => const UsedFunction(
    id: '1',
    title: 'current_class_function',
    excerpt: 'Otaq 316',
  ),
);
