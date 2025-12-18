import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:restokin/core/theme/app_theme.dart";
import "package:restokin/data/models/invoice_model.dart";
import "package:restokin/features/invoices/invoice_detail_page.dart";
import "package:restokin/state/auth_provider.dart";
import "package:restokin/state/invoice_provider.dart";

class InvoicesTabPage extends StatelessWidget {
  const InvoicesTabPage({super.key});

  @override
  InvoicesTabPageState createState() => InvoicesTabPageState();
}

class InvoicesTabPageState extends State<InvoicesTabPage> {
  late List<InvoiceModel> incomingInvoices;
  late List<InvoiceModel> outgoingInvoices;

  @override
  void initState() {
    super.initState();
    incomingInvoices = InvoiceService.getIncomingInvoices();
    outgoingInvoices = InvoiceService.getOutgoingInvoices();
  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Invoices"),
          bottom: const TabBar(
            indicatorColor: AppColors.surface,
            labelColor: AppColors.surface,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: "Incoming"),
              Tab(text: "Outgoing"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _InvoiceListSection(mode: _InvoiceListMode.incoming),
            _InvoiceListSection(mode: _InvoiceListMode.outgoing),
          ],
        ),
      ),
    );
  }
}

class _InvoiceListSection extends StatelessWidget {
  const _InvoiceListSection({required this.mode});

  final _InvoiceListMode mode;

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, _) {
        final invoices = mode == _InvoiceListMode.incoming
            ? provider.incomingInvoices
            : provider.outgoingInvoices;

        Widget child;
        if (provider.isLoading) {
          child = const _LoadingState();
        } else if (provider.errorMessage != null) {
          child = _ErrorState(
            message: provider.errorMessage!,
            onRetry: provider.refresh,
          );
        } else if (invoices.isEmpty) {
          child = _EmptyState(mode: mode);
        } else {
          child = ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return _InvoiceCard(invoice: invoice, mode: mode);
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: invoices.length,
          );
        }

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: provider.refresh,
          child: child,
        );
      },
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({
    required this.invoice,
    required this.mode,
  });

  final InvoiceModel invoice;
  final _InvoiceListMode mode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPaid = invoice.paymentStatus.toLowerCase().contains("paid");
    final statusLabel = isPaid ? "Paid" : "Waiting Payment";
    final statusColor = isPaid ? AppColors.success : AppColors.danger;
    final proofUrl = _resolveProofImage(invoice);

    return InkWell(
      onTap: () => _openDetail(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProofThumbnail(proofUrl: proofUrl),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    invoice.invoiceNumber,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.background,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    invoice.storeName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.background.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 14, color: Colors.black54),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          invoice.date,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.payments_rounded, size: 16, color: Colors.black54),
                      const SizedBox(width: 6),
                      Text(
                        "Rp${invoice.totalAmount.toStringAsFixed(2)}",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.background,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _StatusChip(label: statusLabel, color: statusColor),
                const SizedBox(height: 12),
                Icon(
                  mode == _InvoiceListMode.incoming
                      ? Icons.call_received_rounded
                      : Icons.call_made_rounded,
                  color: AppColors.background.withOpacity(0.7),
                  size: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => InvoiceDetailPage(
          invoiceId: invoice.invoiceNumber,
          mode: mode.name,
          roleHint: mode == _InvoiceListMode.outgoing ? "restocker" : "storeOwner",
        ),
        settings: RouteSettings(
          arguments: {
            "invoiceId": invoice.invoiceNumber,
            "mode": mode.name,
          },
        ),
      ),
    );
  }

  String? _resolveProofImage(InvoiceModel invoice) {
    // TODO: Map to invoice.proofImageUrl (or similar) once the field exists in InvoiceModel.
    return null;
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _ProofThumbnail extends StatelessWidget {
  const _ProofThumbnail({this.proofUrl});

  final String? proofUrl;

  @override
  Widget build(BuildContext context) {
    const size = 56.0;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: size,
        height: size,
        color: proofUrl == null
            ? Colors.white.withOpacity(0.25)
            : Colors.grey.shade200,
        child: proofUrl == null
            ? const Icon(Icons.receipt_long_rounded, color: AppColors.background)
            : Image.network(
                proofUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image_outlined,
                  color: AppColors.background,
                ),
              ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.mode});

  final _InvoiceListMode mode;

  @override
  Widget build(BuildContext context) {
    final text = mode == _InvoiceListMode.incoming
        ? "No incoming invoices yet"
        : "No outgoing invoices yet";
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.receipt_outlined, color: AppColors.surface, size: 40),
              const SizedBox(height: 12),
              Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 160),
      children: const [
        Center(
          child: CircularProgressIndicator(color: AppColors.surface),
        ),
      ],
    );
  }
}

enum _InvoiceListMode { incoming, outgoing }
