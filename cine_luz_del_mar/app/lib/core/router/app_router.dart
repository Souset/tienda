import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../features/admin/presentation/screens/admin_screen.dart';
import '../../features/agenda/presentation/screens/agenda_screen.dart';
import '../../features/agenda/presentation/screens/event_detail_screen.dart';
import '../../features/assistant/presentation/screens/assistant_screen.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/verify_email_screen.dart';
import '../../features/chat/presentation/screens/chat_list_screen.dart';
import '../../features/community/presentation/screens/community_screen.dart';
import '../../features/films/presentation/screens/film_detail_screen.dart';
import '../../features/films/presentation/screens/films_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/library/presentation/screens/library_screen.dart';
import '../../features/map/presentation/screens/map_screen.dart';
import '../../features/members/presentation/screens/become_member_screen.dart';
import '../../features/members/presentation/screens/member_card_screen.dart';
import '../../features/news/presentation/screens/news_detail_screen.dart';
import '../../features/news/presentation/screens/news_list_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/search/presentation/screens/search_screen.dart';
import 'app_shell.dart';
import 'router_refresh.dart';

/// Nombres de ruta centralizados para navegación tipada por nombre.
abstract final class AppRoutes {
  static const home = '/';
  static const agenda = '/agenda';
  static const community = '/comunidad';
  static const library = '/biblioteca';
  static const profile = '/perfil';
  static const login = '/acceso';
  static const news = '/noticias';
  static const films = '/peliculas';
  static const memberCard = '/carne';
  static const becomeMember = '/socio';
  static const paymentOk = '/socio/pago-ok';
  static const paymentCancelled = '/socio/pago-cancelado';
  static const notifications = '/notificaciones';
  static const chat = '/chat';
  static const search = '/buscar';
  static const map = '/mapa';
  static const assistant = '/asistente';
  static const admin = '/admin';
  static const register = '/acceso/registro';
  static const forgotPassword = '/acceso/recuperar';
  static const verifyEmail = '/acceso/verificar';
}

/// Rutas que exigen sesión iniciada.
const _protectedRoutes = <String>{
  AppRoutes.memberCard,
  AppRoutes.becomeMember,
  AppRoutes.paymentOk,
  AppRoutes.paymentCancelled,
  AppRoutes.chat,
  AppRoutes.notifications,
  AppRoutes.assistant,
};

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = GoRouterRefreshStream();
  ref.onDispose(refresh.dispose);
  // El redirect debe re-evaluarse también cuando termina de cargar el perfil
  // de Firestore (rol incluido), no solo con authStateChanges.
  ref.listen(sessionProvider, (_, _) => refresh.notify());

  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: false,
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final user = session.value;
      final loggedIn = user != null;
      final location = state.matchedLocation;

      // Mientras la sesión se restaura (recarga en web), no expulsar de las
      // rutas protegidas: cada pantalla gestiona su propio estado de carga.
      if (session.isLoading && !session.hasValue) return null;

      final isVerifyEmail = location == AppRoutes.verifyEmail;
      // El grupo /acceso (login, registro, recuperar) es solo para invitados;
      // /acceso/verificar es la excepción: requiere sesión.
      final isAuthGroup =
          location.startsWith(AppRoutes.login) && !isVerifyEmail;

      // La verificación de correo solo tiene sentido con sesión activa.
      if (isVerifyEmail && !loggedIn) return AppRoutes.login;

      // Con sesión, las pantallas de acceso redirigen al inicio.
      if (loggedIn && isAuthGroup) return AppRoutes.home;

      // Rutas protegidas: exigen sesión.
      if (!loggedIn && _protectedRoutes.contains(location)) {
        return AppRoutes.login;
      }

      // Panel de administración: sesión + rol coordinador o superior. Si la
      // sesión aún está cargando dejamos pasar y la propia pantalla valida.
      if (location == AppRoutes.admin) {
        if (!loggedIn) return AppRoutes.login;
        if (session.hasValue && !user.userRole.canManageContent) {
          return AppRoutes.home;
        }
      }

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (context, state) =>
                    _fade(state, const HomeScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.agenda,
                pageBuilder: (context, state) =>
                    _fade(state, const AgendaScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.community,
                pageBuilder: (context, state) =>
                    _fade(state, const CommunityScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.library,
                pageBuilder: (context, state) =>
                    _fade(state, const LibraryScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (context, state) =>
                    _fade(state, const ProfileScreen()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.verifyEmail,
        builder: (context, state) => const VerifyEmailScreen(),
      ),
      GoRoute(
        path: AppRoutes.news,
        builder: (context, state) => const NewsListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) =>
                NewsDetailScreen(newsId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.films,
        builder: (context, state) => const FilmsScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) =>
                FilmDetailScreen(filmId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.agenda}/:id',
        builder: (context, state) =>
            EventDetailScreen(eventId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.memberCard,
        builder: (context, state) => const MemberCardScreen(),
      ),
      GoRoute(
        path: AppRoutes.becomeMember,
        builder: (context, state) => const BecomeMemberScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentOk,
        builder: (context, state) => const PaymentResultScreen(success: true),
      ),
      GoRoute(
        path: AppRoutes.paymentCancelled,
        builder: (context, state) => const PaymentResultScreen(success: false),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.chat,
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: AppRoutes.map,
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: AppRoutes.assistant,
        builder: (context, state) => const AssistantScreen(),
      ),
      GoRoute(
        path: AppRoutes.admin,
        builder: (context, state) => const AdminScreen(),
      ),
    ],
  );
});

CustomTransitionPage<void> _fade(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(
          opacity: CurveTween(curve: Curves.easeOut).animate(animation),
          child: child,
        ),
  );
}
