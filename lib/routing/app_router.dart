import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unec_assistant/routing/main_scaffold.dart';
import 'package:unec_assistant/screens/feed/feed_main_screen.dart';
import 'package:unec_assistant/screens/functions/current%20class/current_class_screen.dart';
import 'package:unec_assistant/screens/functions/notes/notes_screen.dart';
import 'package:unec_assistant/screens/functions/schedule/schedule_screen.dart';
import 'package:unec_assistant/screens/functions/functions_main_screen.dart';
import 'package:unec_assistant/screens/home/home_screen.dart';
import 'package:unec_assistant/screens/profile/change_pass_screen.dart';
import 'package:unec_assistant/screens/profile/profile_info_screen.dart';
import 'package:unec_assistant/screens/profile/profile_screen.dart';
import 'package:unec_assistant/screens/profile/about_app_screen.dart';
import 'package:unec_assistant/screens/functions/attendance/attendance_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/subjects_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/teaching%20materials/teaching_materials_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/teaching%20materials/subject_materials_detail_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/teaching%20materials/smart_sync_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/grades/grades_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/grades/grade_calculator_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/grades/subject_grades_screen.dart';
import 'package:unec_assistant/providers/subject_detail_provider.dart';
import 'package:unec_assistant/screens/functions/subjects/subject_detail_screen.dart';

import 'package:unec_assistant/screens/functions/notes/note_files_screen.dart';
import 'package:unec_assistant/screens/functions/notes/note_editor_screen.dart';
import 'package:unec_assistant/screens/feed/post_detail_screen.dart';
import 'package:unec_assistant/screens/feed/manage_channels_screen.dart';
import 'package:unec_assistant/screens/feed/create_post_screen.dart';
import 'package:unec_assistant/screens/profile/academic_profile_screen.dart';
import 'package:unec_assistant/screens/profile/share_profile_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    if (state.uri.path == '/') {
      return '/home';
    }
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'current_class_function',
                  builder: (context, state) => const CurrentClassScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/functions',
              builder: (context, state) => const FunctionsMainScreen(),
              routes: [
                GoRoute(
                  path: 'current_class_function',
                  builder: (context, state) => const CurrentClassScreen(),
                ),
                GoRoute(
                  path: 'schedule_function',
                  builder: (context, state) => const ScheduleScreen(),
                ),
                GoRoute(
                  path: 'attendance_function',
                  builder: (context, state) => const AttendanceScreen(),
                ),
                GoRoute(
                  path: 'subjects',
                  builder: (context, state) => const SubjectsScreen(),
                  routes: [
                    GoRoute(
                      path: '1',
                      builder: (context, state) => const SubjectDetailScreen(data: kProgDetail),
                    ),
                    GoRoute(
                      path: '2',
                      builder: (context, state) => const SubjectDetailScreen(data: kFizikaDetail),
                    ),
                    GoRoute(
                      path: '3',
                      builder: (context, state) => const SubjectDetailScreen(data: kAzDetail),
                    ),
                    GoRoute(
                      path: '4',
                      builder: (context, state) => const SubjectDetailScreen(data: kXettiDetail),
                    ),
                    GoRoute(
                      path: '5',
                      builder: (context, state) => const SubjectDetailScreen(data: kInfoDetail),
                    ),
                    GoRoute(
                      path: '6',
                      builder: (context, state) => const SubjectDetailScreen(data: kXariciDetail),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'teaching-materials',
                  builder: (context, state) => const TeachingMaterialsScreen(),
                  routes: [
                    GoRoute(
                      path: 'smart-sync',
                      builder: (context, state) => const SmartSyncScreen(),
                    ),
                    GoRoute(
                      path: 'subject/:subjectId',
                      builder: (context, state) => SubjectMaterialsDetailScreen(
                        subjectId: state.pathParameters['subjectId']!,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'grades',
                  builder: (context, state) => const GradesScreen(),
                  routes: [
                    GoRoute(
                      path: 'calculator',
                      builder: (context, state) => const GradeCalculatorScreen(),
                    ),
                    GoRoute(
                      path: 'subject/1',
                      builder: (context, state) => const SubjectGradesScreen(data: kProgDetail),
                    ),
                    GoRoute(
                      path: 'subject/2',
                      builder: (context, state) => const SubjectGradesScreen(data: kFizikaDetail),
                    ),
                    GoRoute(
                      path: 'subject/3',
                      builder: (context, state) => const SubjectGradesScreen(data: kAzDetail),
                    ),
                    GoRoute(
                      path: 'subject/4',
                      builder: (context, state) => const SubjectGradesScreen(data: kXettiDetail),
                    ),
                    GoRoute(
                      path: 'subject/5',
                      builder: (context, state) => const SubjectGradesScreen(data: kInfoDetail),
                    ),
                    GoRoute(
                      path: 'subject/6',
                      builder: (context, state) => const SubjectGradesScreen(data: kXariciDetail),
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '/notes',
              builder: (context, state) => const NotesScreen(),
              routes: [
                GoRoute(
                  path: 'folder/:folderId',
                  builder: (context, state) => NoteFilesScreen(
                    folderId: state.pathParameters['folderId']!,
                  ),
                ),
                GoRoute(
                  path: 'editor/:noteId',
                  builder: (context, state) => NoteEditorScreen(
                    noteId: state.pathParameters['noteId']!,
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/feed',
              builder: (context, state) => const FeedMainScreen(),
              routes: [
                GoRoute(
                  path: 'post/:postId',
                  builder: (context, state) => PostDetailScreen(
                    postId: state.pathParameters['postId']!,
                  ),
                ),
                GoRoute(
                  path: 'manage-channels',
                  builder: (context, state) => const ManageChannelsScreen(),
                ),
                GoRoute(
                  path: 'create-post',
                  builder: (context, state) => const CreatePostScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'about',
                  builder: (context, state) => const AboutAppScreen(),
                ),
                GoRoute(
                  path: 'change_pass',
                  builder: (context, state) => const ChangePassScreen(),
                ),
                GoRoute(
                  path: 'unec_cabinet',
                  redirect: (context, state) async {
                    final Uri url = Uri.parse('http://kabinet.unec.edu.az/az/login');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                    return null;
                  },
                ),
                GoRoute(
                  path: 'profile_info',
                  builder: (context, state) => const ProfileInfoScreen(),
                ),
                GoRoute(
                  path: 'academic_profile',
                  builder: (context, state) => const AcademicProfileScreen(),
                ),
                GoRoute(
                  path: 'share_profile',
                  builder: (context, state) => const ShareProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
