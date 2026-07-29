import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:unec_assistant/routing/main_scaffold.dart';
import 'package:unec_assistant/screens/feed/feed_main_screen.dart';
import 'package:unec_assistant/screens/feed/post1_screen.dart';
import 'package:unec_assistant/screens/functions/current_class_screen.dart';
import 'package:unec_assistant/screens/functions/notes_screen.dart';
import 'package:unec_assistant/screens/functions/schedule_screen.dart';
import 'package:unec_assistant/screens/functions/functions_main_screen.dart';
import 'package:unec_assistant/screens/home/home_screen.dart';
import 'package:unec_assistant/screens/profile/change_pass_screen.dart';
import 'package:unec_assistant/screens/profile/profile_info_screen.dart';
import 'package:unec_assistant/screens/profile/profile_screen.dart';
import 'package:unec_assistant/screens/profile/about_app_screen.dart';
import 'package:unec_assistant/screens/functions/attendance_screen.dart';
import 'package:unec_assistant/screens/functions/subjects_screen.dart';
import 'package:unec_assistant/screens/functions/teaching_materials_screen.dart';
import 'package:unec_assistant/screens/functions/grades_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/subject1_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/subject2_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/subject3_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/subject4_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/subject5_screen.dart';
import 'package:unec_assistant/screens/functions/subjects/subject6_screen.dart';


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
                GoRoute(
                  path: 'post1',
                  builder: (context, state) => const Post1Screen(),
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
                  path: 'notes_function',
                  builder: (context, state) => const NotesScreen(),
                ),
                GoRoute(
                  path: 'subjects',
                  builder: (context, state) => const SubjectsScreen(),
                  routes: [
                    GoRoute(
                      path: '1',
                      builder: (context, state) => const Subject1Screen(),
                    ),
                    GoRoute(
                      path: '2',
                      builder: (context, state) => const Subject2Screen(),
                    ),
                    GoRoute(
                      path: '3',
                      builder: (context, state) => const Subject3Screen(),
                    ),
                    GoRoute(
                      path: '4',
                      builder: (context, state) => const Subject4Screen(),
                    ),
                    GoRoute(
                      path: '5',
                      builder: (context, state) => const Subject5Screen(),
                    ),
                    GoRoute(
                      path: '6',
                      builder: (context, state) => const Subject6Screen(),
                    ),
                  ],
                ),
                GoRoute(
                  path: 'teaching-materials',
                  builder: (context, state) => const TeachingMaterialsScreen(),
                ),
                GoRoute(
                  path: 'grades',
                  builder: (context, state) => const GradesScreen(),
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
                  path: 'post1',
                  builder: (context, state) => const Post1Screen(),
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
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
