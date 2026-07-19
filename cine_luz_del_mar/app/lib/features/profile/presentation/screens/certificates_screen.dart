import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../shared/widgets/app_shimmer.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/certificate_pdf.dart';
import '../../data/certificates_repository.dart';

/// Certificados del usuario con descarga en PDF elegante.
class CertificatesScreen extends ConsumerWidget {
  const CertificatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final certificates = ref.watch(myCertificatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mis certificados')),
      body: certificates.when(
        loading: () => const ShimmerList(itemHeight: 72),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(myCertificatesProvider),
        ),
        data: (list) => list.isEmpty
            ? const EmptyState(
                icon: Icons.workspace_premium_outlined,
                title: 'Todavía no tienes certificados',
                message:
                    'Cuando completes un taller o curso, la asociación '
                    'emitirá aquí tu certificado.',
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: list.length,
                separatorBuilder: (_, _) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final cert = list[i];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.workspace_premium_outlined),
                      title: Text(cert.title, maxLines: 2),
                      subtitle: cert.issuedAt == null
                          ? null
                          : Text(Formatters.fullDate.format(cert.issuedAt!)),
                      trailing: FilledButton.tonalIcon(
                        onPressed: () => shareCertificatePdf(
                          certificate: cert,
                          userName: user?.displayName ?? '',
                        ),
                        icon: const Icon(Icons.picture_as_pdf_outlined),
                        label: const Text('PDF'),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
