import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/post_request.dart';

class PostRequestState {
  final List<PostRequest> requests;
  final bool isLoading;

  const PostRequestState({
    this.requests = const [],
    this.isLoading = false,
  });

  PostRequestState copyWith({
    List<PostRequest>? requests,
    bool? isLoading,
  }) {
    return PostRequestState(
      requests: requests ?? this.requests,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PostRequestNotifier extends Notifier<PostRequestState> {
  @override
  PostRequestState build() {
    return const PostRequestState();
  }

  void addRequest(PostRequest request) {
    state = state.copyWith(
      requests: [request, ...state.requests],
    );
  }
}

final postRequestProvider = NotifierProvider<PostRequestNotifier, PostRequestState>(PostRequestNotifier.new);

final pendingRequestsProvider = Provider<List<PostRequest>>((ref) {
  final requests = ref.watch(postRequestProvider).requests;
  return requests.where((r) => r.status == PostRequestStatus.pending).toList();
});

final approvedRequestsProvider = Provider<List<PostRequest>>((ref) {
  final requests = ref.watch(postRequestProvider).requests;
  return requests.where((r) => r.status == PostRequestStatus.approved).toList();
});
