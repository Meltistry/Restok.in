import "package:flutter/material.dart";
import "package:restokin/data/models/invoice_model.dart";
import "package:restokin/data/services/invoice_service.dart";
import "package:restokin/features/invoices/invoice_detail_page.dart";

class InvoicesTabPage extends StatefulWidget {
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
          title: Text('Invoices'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Incoming'),
              Tab(text: 'Outgoing'),
            ],
            indicatorColor: Colors.blueAccent,
          ),
        ),
        body: TabBarView(
          children: [
            _buildInvoiceList(incomingInvoices),
            _buildInvoiceList(outgoingInvoices),
          ],
        ),
      ),
    );
  }

  Widget _buildInvoiceList(List<InvoiceModel> invoices) {
    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        final invoice = invoices[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(invoice.invoiceNumber, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('From: ${invoice.storeName} \nAmount: ${invoice.totalAmount.toStringAsFixed(2)}'),
            trailing: _buildInvoiceStatus(invoice.paymentStatus),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InvoiceDetailPage(invoice: invoice),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInvoiceStatus(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case 'Paid':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'Not Paid':
        statusColor = Colors.red;
        statusIcon = Icons.error;
        break;
      case 'Pending':
        statusColor = Colors.orange;
        statusIcon = Icons.access_time;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.help;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(statusIcon, color: statusColor),
        SizedBox(width: 8),
        Text(status, style: TextStyle(color: statusColor)),
      ],
    );
  }
}
