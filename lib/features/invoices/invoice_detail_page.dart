import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:restokin/core/theme/app_theme.dart";
import "package:restokin/data/models/invoice_model.dart";
import "package:restokin/features/invoices/payment_success_page.dart";
import "package:restokin/state/auth_provider.dart";
import "package:restokin/state/invoice_provider.dart";

class InvoiceDetailPage extends StatefulWidget {
  const InvoiceDetailPage({
    super.key,
    required this.invoiceId,
    this.mode,
    this.roleHint,
  });

  final String invoiceId;
  final String? mode; // incoming / outgoing
  final String? roleHint; // storeOwner / restocker

  @override
  State<InvoiceDetailPage> createState() => _InvoiceDetailPageState();
}

class _InvoiceDetailPageState extends State<InvoiceDetailPage> {
  bool _initialized = false;
  late final InvoiceProvider _provider = InvoiceProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      _load();
    }
  }

  Future<void> _load() async {
    final auth = context.read<AuthProvider?>();
    final userId = auth?.user?.id;
    await _provider.loadInvoices(currentUserId: userId);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<InvoiceProvider>.value(
      value: _provider,
      child: Consumer<InvoiceProvider>(
        builder: (context, provider, _) {
          final invoice = provider.getInvoiceById(widget.invoiceId);
          final isLoading = provider.isLoading && invoice == null;
          final error = provider.errorMessage;

          return Scaffold(
            appBar: AppBar(
              title: Text("Invoice #${widget.invoiceId}"),
            ),
            body: RefreshIndicator(
              color: AppColors.primary,
              onRefresh: _load,
              child: isLoading
                  ? const _LoadingState()
                  : error != null
                      ? _ErrorState(message: error, onRetry: _load)
                      : invoice == null
                          ? _NotFound(onRetry: _load)
                          : _InvoiceDetailBody(
                              invoice: invoice,
                              mode: widget.mode,
                              roleHint: widget.roleHint,
                            ),
            ),
          );
        },
      ),
    );
  }
}

class _InvoiceDetailBody extends StatelessWidget {
  const _InvoiceDetailBody({
    required this.invoice,
    required this.mode,
    required this.roleHint,
  });

  final InvoiceModel invoice;
  final String? mode;
  final String? roleHint;

  bool get _isPaid => invoice.paymentStatus.toLowerCase().contains("paid");

  @override
  Widget build(BuildContext context) {
    final canPay = !_isPaid && (roleHint == "restocker" || mode == "outgoing" || roleHint == null);
    final statusColor = _isPaid ? AppColors.success : AppColors.danger;
    final proofUrl = _resolveProofUrl(invoice);

    return Container(
      color: AppColors.background,
      child: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: [
                  _Header(invoice: invoice),
                  const SizedBox(height: 16),
                  _ItemsCard(invoice: invoice),
                  const SizedBox(height: 16),
                  _ProofSection(
                    proofUrl: proofUrl,
                    isWaiting: !_isPaid,
                    roleHint: roleHint,
                  ),
                  const SizedBox(height: 16),
                  if (canPay) _PaymentMethodCard(total: invoice.totalAmount),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: canPay
                  ? _PayButton(invoice: invoice)
                  : _StatusFooter(
                      label: _isPaid
                          ? "Invoice Paid"
                          : "Waiting for Payment from ${invoice.storeName}",
                      color: statusColor,
                      isPaid: _isPaid,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String? _resolveProofUrl(InvoiceModel invoice) {
    // TODO: Map to invoice.proofImageUrl (or similar) when field exists.
    return null;
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.invoice});

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        "Invoice - #${invoice.invoiceNumber}",
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w800,
            ),
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.invoice});

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    final items = invoice.items;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: items.isEmpty
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 8),
                Text("No items available"),
                SizedBox(height: 4),
                Text(
                  "TODO: Map invoice items from backend fields.",
                  style: TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            )
          : Column(
              children: [
                ...items.map((item) => _ItemRow(item: item)).toList(),
                const Divider(height: 18, color: Color(0xFFB3E5F5)),
                _FooterRow(
                  label: "Total ${items.length} produk",
                  value: "Rp${invoice.totalAmount.toStringAsFixed(2)}",
                ),
              ],
            ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final InvoiceItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.name,
              style: const TextStyle(
                color: AppColors.background,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Rp${item.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "x${item.quantity}",
                style: const TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FooterRow extends StatelessWidget {
  const _FooterRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.background,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.background,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ProofSection extends StatelessWidget {
  const _ProofSection({
    required this.proofUrl,
    required this.isWaiting,
    required this.roleHint,
  });

  final String? proofUrl;
  final bool isWaiting;
  final String? roleHint;

  @override
  Widget build(BuildContext context) {
    if (proofUrl != null && proofUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Image.network(
            proofUrl!,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.black12,
              child: const Center(child: Icon(Icons.broken_image_outlined)),
            ),
          ),
        ),
      );
    }

    final showHint = isWaiting && (roleHint == "restocker" || roleHint == null);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              color: Colors.black12,
              height: 190,
              child: const Center(
                child: Icon(Icons.photo_size_select_actual_outlined, size: 48),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            showHint
                ? "No proof uploaded yet. Upload payment proof to complete."
                : "No proof available.",
            style: const TextStyle(color: AppColors.surface),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  const _PaymentMethodCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_balance_wallet_outlined, color: AppColors.surface),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              "Gopay",
              style: TextStyle(color: AppColors.surface, fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            "Rp${total.toStringAsFixed(2)}",
            style: const TextStyle(color: AppColors.surface, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.surface),
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  const _PayButton({required this.invoice});

  final InvoiceModel invoice;

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoiceProvider>(
      builder: (context, provider, _) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: provider.isPaying ? null : () => _handlePay(context, provider),
            child: provider.isPaying
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text("Pay Invoice"),
          ),
        );
      },
    );
  }

  Future<void> _handlePay(BuildContext context, InvoiceProvider provider) async {
    final success = await provider.payInvoice(invoice);
    if (!context.mounted) return;
    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: provider,
            child: PaymentSuccessPage(
              invoiceId: invoice.invoiceNumber,
              paidAt: DateTime.now(),
              totalAmount: invoice.totalAmount,
            ),
          ),
        ),
      );
    } else {
      final msg = provider.errorMessage ?? "Payment failed. Please try again.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}

class _StatusFooter extends StatelessWidget {
  const _StatusFooter({
    required this.label,
    required this.color,
    required this.isPaid,
  });

  final String label;
  final Color color;
  final bool isPaid;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isPaid ? AppColors.surface : color,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(width: 8),
          Icon(
            isPaid ? Icons.check_circle : Icons.hourglass_empty,
            color: isPaid ? AppColors.surface : color,
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.only(top: 120),
        child: CircularProgressIndicator(color: AppColors.surface),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Column(
            children: [
              const Icon(Icons.error_outline, color: AppColors.danger, size: 40),
              const SizedBox(height: 12),
              Text(
                message,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24),
      children: [
        Center(
          child: Column(
            children: [
              const Icon(Icons.receipt_long_outlined, color: AppColors.surface, size: 40),
              const SizedBox(height: 12),
              const Text(
                "Invoice not found",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRetry, child: const Text("Refresh")),
            ],
          ),
        ),
      ],
    );
  }
}
