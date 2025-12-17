import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:restokin/core/theme/app_theme.dart";
import "package:restokin/features/invoices/invoice_detail_page.dart";
import "package:restokin/state/invoice_provider.dart";

class PaymentSuccessPage extends StatelessWidget {
<<<<<<< HEAD
  const PaymentSuccessPage({
    super.key,
    required this.invoiceId,
    this.paidAt,
    this.totalAmount,
=======
  final String invoiceNumber;
  final String paymentDate;
  final String totalAmount;
  final String sourceWalletName;
  final String sourceWalletNumber;
  final String receivingWalletName;
  final String receivingWalletNumber;

  const PaymentSuccessPage({
    super.key,
    required this.invoiceNumber,
    required this.paymentDate,
    required this.totalAmount,
    required this.sourceWalletName,
    required this.sourceWalletNumber,
    required this.receivingWalletName,
    required this.receivingWalletNumber,
>>>>>>> 57ed91b57323f8a666ab8bb54cc02f9b00fcaf79
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
<<<<<<< HEAD
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
=======
      appBar: AppBar(
        title: Text('Payment Successful'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Success Message and Payment Date
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              'Invoice has been successfully paid!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Payment Date: $paymentDate',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),

            // Payment Details
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount: $totalAmount',
                    style: TextStyle(
>>>>>>> 57ed91b57323f8a666ab8bb54cc02f9b00fcaf79
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
<<<<<<< HEAD
=======
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Done'),
>>>>>>> 57ed91b57323f8a666ab8bb54cc02f9b00fcaf79
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
<<<<<<< HEAD
      width: 90,
      height: 90,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFFE0F8FF),
=======
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
>>>>>>> 57ed91b57323f8a666ab8bb54cc02f9b00fcaf79
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
<<<<<<< HEAD
          const Text(
            "Total Amount",
            style: TextStyle(
              color: AppColors.background,
              fontWeight: FontWeight.w700,
=======
          const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.account_circle, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Phone: $number',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
>>>>>>> 57ed91b57323f8a666ab8bb54cc02f9b00fcaf79
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
