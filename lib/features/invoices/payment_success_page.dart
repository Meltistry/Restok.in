import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:restokin/core/theme/app_theme.dart";
import "package:restokin/features/invoices/invoice_detail_page.dart";
import "package:restokin/state/invoice_provider.dart";

class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({
    super.key,
    required this.invoiceId,
    this.paidAt,
    this.totalAmount,
  });

  final String invoiceId;
  final DateTime? paidAt;
  final double? totalAmount;

  @override
  Widget build(BuildContext context) {
    final provider = context.read<InvoiceProvider?>();
    final invoice = provider?.getInvoiceById(invoiceId);
    final total = totalAmount ?? invoice?.totalAmount ?? 0;
    final paidTime = paidAt ?? DateTime.now();
    final formattedDate =
        "${paidTime.hour.toString().padLeft(2, "0")}:${paidTime.minute.toString().padLeft(2, "0")}, ${paidTime.day} ${_monthName(paidTime.month)} ${paidTime.year}";

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              const SizedBox(height: 12),
              _SuccessIcon(),
              const SizedBox(height: 16),
              Text(
                "Invoice paid successfully",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.surface.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 20),
              _SummaryCard(
                invoiceId: invoiceId,
                total: total,
              ),
              const Spacer(),
              _PrimaryButton(
                label: "Back to Invoices",
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
              const SizedBox(height: 10),
              _SecondaryButton(
                label: "View Invoice",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InvoiceDetailPage(
                        invoiceId: invoiceId,
                        mode: invoice == null ? null : "incoming",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE0F8FF),
      ),
      child: const Icon(Icons.check_circle, size: 64, color: AppColors.primary),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.invoiceId, required this.total});

  final String invoiceId;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Total Amount",
            style: TextStyle(
              color: AppColors.background,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Rp${total.toStringAsFixed(2)}",
            style: const TextStyle(
              color: AppColors.background,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Text(
                "Ref No.",
                style: TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                "#$invoiceId",
                style: const TextStyle(
                  color: AppColors.background,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.surface,
          side: const BorderSide(color: AppColors.surface, width: 1.2),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}
