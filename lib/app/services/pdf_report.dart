// ignore_for_file: deprecated_member_use

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:uth_task/app/models/expense.dart';
import 'package:uth_task/app/models/income.dart';

Future<void> generatePdfReport(List<Income> incomes, List<Expense> expenses) async {
  final pdf = pw.Document();

  final totalIncome = incomes.fold(0.0, (sum, item) => sum + item.amount);
  final totalExpenses = expenses.fold(0.0, (sum, item) => sum + item.amount);
  final balance = totalIncome - totalExpenses;

  pdf.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => [
        pw.Header(level: 0, child: pw.Text('Financial Report', style: pw.TextStyle(fontSize: 24))),
        pw.Header(level: 1, child: pw.Text('Income')),
        pw.Table.fromTextArray(
          data: [
            ['Date', 'Source', 'Amount'],
            ...incomes.map((income) => [
              income.date.toLocal().toString().split(' ')[0],
              income.source,
              '\$${income.amount.toStringAsFixed(2)}',
            ]),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Header(level: 1, child: pw.Text('Expenses')),
        pw.Table.fromTextArray(
          data: [
            ['Date', 'Description', 'Amount'],
            ...expenses.map((expense) => [
              expense.date.toLocal().toString().split(' ')[0],
              expense.description,
              '\$${expense.amount.toStringAsFixed(2)}',
            ]),
          ],
        ),
        pw.SizedBox(height: 20),
        pw.Header(level: 1, child: pw.Text('Summary')),
        pw.Text('Total Income: \$${totalIncome.toStringAsFixed(2)}'),
        pw.Text('Total Expenses: \$${totalExpenses.toStringAsFixed(2)}'),
        pw.Text('Balance: \$${balance.toStringAsFixed(2)}'),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
}
