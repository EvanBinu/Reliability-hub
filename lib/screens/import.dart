import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:reliability_hub/Calculation/reliability_calculator.dart'; // Adjust the import path as needed
import 'package:reliability_hub/screens/result.dart'; // Adjust the import path as needed

class Import extends StatefulWidget {
  const Import({super.key});

  @override
  State<Import> createState() => _ImportState();
}

class _ImportState extends State<Import> {
  List<List<dynamic>> _data = [];
  String? filePath;
  int? selectedRowIndex;
  int? numberOfRows; // Variable to store the number of rows

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'xls', 'xlsx'],
    );

    if (result != null) {
      filePath = result.files.single.path;
      if (filePath != null) {
        if (filePath!.endsWith('.csv')) {
          _loadCSV(filePath!);
        } else if (filePath!.endsWith('.xls') || filePath!.endsWith('.xlsx')) {
          _loadExcel(filePath!);
        }
      }
    }
  }

  Future<void> _loadCSV(String path) async {
    final input = File(path).readAsStringSync();
    final fields = CsvToListConverter().convert(input);

    setState(() {
      _data = fields
          .map((row) => row.map((cell) => _extractValue(cell)).toList())
          .toList();
      numberOfRows = _data.length; // Store the number of rows
    });

    print('Number of rows: $numberOfRows'); // Print to terminal
  }

  Future<void> _loadExcel(String path) async {
    var bytes = File(path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    setState(() {
      _data = [];
      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet != null) {
          _data.addAll(
            sheet.rows
                .map((row) => row.map((cell) => _extractValue(cell)).toList())
                .toList(),
          );
        }
      }
      numberOfRows = _data.length; // Store the number of rows
    });

    print('Number of rows: $numberOfRows'); // Print to terminal
  }

  String _extractValue(dynamic cell) {
    String cellContent = cell.toString();

    if (cellContent.startsWith('Data(')) {
      cellContent = cellContent.substring(5); // Remove 'Data('
      int commaIndex = cellContent.indexOf(',');
      if (commaIndex != -1) {
        cellContent = cellContent.substring(
            0, commaIndex); // Keep only the value before the first comma
      }
    }

    return cellContent.trim(); // Return the cleaned value
  }

  void _showRowSelectionDialog() {
    if (_data.isNotEmpty) {
      List<String> options = List.generate(
        _data.length - 1,
            (index) => 'Row ${index + 1}: ${_data[index + 1].join(', ')}',
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Row'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((option) {
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    setState(() {
                      selectedRowIndex = options.indexOf(option) + 1; // Adding 1 because data rows start from index 1
                    });
                    Navigator.pop(context);
                    _processData();
                  },
                );
              }).toList(),
            ),
          );
        },
      );
    }
  }

  void _processData() {
    if (_data.isNotEmpty && selectedRowIndex != null) {
      List<dynamic> row = _data[selectedRowIndex!];

      double operationalTime = double.tryParse(row[1].toString()) ?? 0;
      double maintenanceTime = double.tryParse(row[2].toString()) ?? 0;
      int totalRepairs = int.tryParse(row[3].toString()) ?? 0;

      ReliabilityCalculator calculator = ReliabilityCalculator(
        operationalTime: operationalTime,
        maintenanceTime: maintenanceTime,
        totalRepairs: totalRepairs,
      );

      final double mtbf = calculator.calculateMTBF();
      final double mttr = calculator.calculateMTTR();
      final double availability = calculator.calculateAvailability();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            mtbf: double.parse(mtbf.toStringAsFixed(2)),
            mttr: double.parse(mttr.toStringAsFixed(2)),
            availability: double.parse((availability * 100).toStringAsFixed(2)),
            operationalTime: operationalTime,
            maintenanceTime: maintenanceTime,
            totalRepairs: totalRepairs,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3FEF7),
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: const Color(0xFF135D66),
        title: const Text(
          "Reliability Hub",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: Column(
        children: [
          SizedBox.fromSize(
            size: Size.fromHeight(20),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF135D66),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: _pickFile,
            child: const Text('Import CSV/Excel', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          SizedBox.fromSize(
            size: Size.fromHeight(20),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF135D66),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: _showRowSelectionDialog,
            child: const Text('Select Row and Process Data', style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          Expanded(
            child: _data.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'No data available',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10), // Space between the lines
                  const Text(
                    'Note: The data should be in the order: Operational Time, Maintenance Time, Total Repairs',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            )
                : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: _data.isNotEmpty
                    ? _data.first
                    .map((col) => DataColumn(label: Text(col.toString())))
                    .toList()
                    : [],
                rows: _data.length > 1
                    ? _data.skip(1).map((row) {
                  return DataRow(
                    cells: row.map((cell) {
                      return DataCell(Text(cell.toString()));
                    }).toList(),
                  );
                }).toList()
                    : [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
