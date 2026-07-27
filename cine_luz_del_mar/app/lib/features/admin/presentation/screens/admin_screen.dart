import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/widgets/empty_state.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../tabs/content_tabs.dart';
import '../tabs/people_tabs.dart';
import '../tabs/plans_tab.dart';
import '../tabs/push_tab.dart';
import '../tabs/resumen_tab.dart';

/// Panel de administración con pestañas según el rol.
class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentRoleProvider);

    if (!role.canManageContent) {
      return Scaffold(
        appBar: AppBar(title: const Text('Administración')),
        body: const EmptyState(
          icon: Icons.lock_outline,
          title: 'Acceso restringido',
          message: 'Este panel es solo para el equipo de la asociación.',
        ),
      );
    }

    final tabs = <(Tab, Widget)>[
      (const Tab(text: 'Resumen'), const ResumenTab()),
      (const Tab(text: 'Noticias'), const NewsTab()),
      (const Tab(text: 'Eventos'), const EventsTab()),
      (const Tab(text: 'Películas'), const FilmsTab()),
      (const Tab(text: 'Biblioteca'), const LibraryTab()),
      if (role.canManageMembers)
        (const Tab(text: 'Socios'), const MembersTab()),
      if (role.canManageMembers) (const Tab(text: 'Packs'), const PlansTab()),
      if (role.canManageUsers) (const Tab(text: 'Usuarios'), const UsersTab()),
      (const Tab(text: 'Push'), const PushTab()),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Administración'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [for (final (tab, _) in tabs) tab],
          ),
        ),
        body: TabBarView(children: [for (final (_, view) in tabs) view]),
      ),
    );
  }
}
