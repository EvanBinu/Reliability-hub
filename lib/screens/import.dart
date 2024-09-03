import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:reliability_hub/screens/result.dart'; // Adjust the import path as needed
import 'package:reliability_hub/Calculation/reliability_calculator.dart'; // Adjust the import path as needed

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
  bool parallel = false; // To be set based on user choice
  bool series = false; // To be set based on user choice

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
            content: Container(
              width: double
                  .maxFinite, // Ensures the content takes up the available width
              child: ListView(
                shrinkWrap: true,
                children: options.map((option) {
                  return ListTile(
                    title: Text(option),
                    onTap: () {
                      setState(() {
                        selectedRowIndex = options.indexOf(option) + 1;
                      });
                      Navigator.pop(context);
                      _processData();
                    },
                  );
                }).toList(),
              ),
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

  void _processFullData() {
    // Example flags, set these according to your logic
    parallel = true;
    // series = true;  // Assuming you're using the 'series' configuration for this example.

    if (_data.isEmpty || numberOfRows == null || numberOfRows! < 2) {
      print('No data or insufficient rows available.');
      return;
    }

    double mtbfParallelSum = 0;
    double mttrParallelSum = 0;
    double availabilityParallelProduct = 1;

    double mtbfSeriesSum = 0;
    double mttrSeriesSum = 0;
    double availabilitySeriesProduct = 1;

    for (int i = 1; i < numberOfRows!; i++) {
      List<dynamic> row = _data[i];
      print('Processing row $i: $row');

      double operationalTime = double.tryParse(row[1].toString()) ?? 0;
      double maintenanceTime = double.tryParse(row[2].toString()) ?? 0;
      int totalRepairs = int.tryParse(row[3].toString()) ?? 0;

      if (operationalTime == 0 || totalRepairs == 0) {
        print('Skipping row $i due to invalid data.');
        continue;
      }

      ReliabilityCalculator calculator = ReliabilityCalculator(
        operationalTime: operationalTime,
        maintenanceTime: maintenanceTime,
        totalRepairs: totalRepairs,
      );

      final double mtbf = calculator.calculateMTBF();
      final double mttr = calculator.calculateMTTR();
      final double availability = calculator.calculateAvailability();

      print('Row $i - MTBF: $mtbf, MTTR: $mttr, Availability: $availability');

      if (parallel == true) {
        mtbfParallelSum += 1 / mtbf; // Parallel MTBF calculation
        mttrParallelSum += mttr; // Parallel MTTR calculation
        availabilityParallelProduct *= (1 - availability); // Parallel Availability calculation
      } else if (series == true) {
        mtbfSeriesSum += mtbf; // Series MTBF calculation
        mttrSeriesSum += mttr; // Series MTTR calculation
        availabilitySeriesProduct *= availability; // Series Availability calculation
      }
    }

    if (parallel == true && mtbfParallelSum != 0) {
      final double systemMTBF = 1 / mtbfParallelSum;
      final double systemMTTR = mttrParallelSum / (numberOfRows! - 1);
      final double systemAvailability = 1 - availabilityParallelProduct;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            mtbf: double.parse(systemMTBF.toStringAsFixed(2)),
            mttr: double.parse(systemMTTR.toStringAsFixed(2)),
            availability: double.parse((systemAvailability * 100).toStringAsFixed(2)),
          ),
        ),
      );
    } else if (series == true) {
      final double systemMTBF = mtbfSeriesSum;
      final double systemMTTR = mttrSeriesSum;
      final double systemAvailability = availabilitySeriesProduct;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            mtbf: double.parse(systemMTBF.toStringAsFixed(2)),
            mttr: double.parse(systemMTTR.toStringAsFixed(2)),
            availability: double.parse((systemAvailability * 100).toStringAsFixed(2)),
          ),
        ),
      );
    } else {
      print('Neither parallel nor series was selected.');
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
            child: const Text('Import CSV/Excel',
                style: TextStyle(fontSize: 18, color: Colors.white)),
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
            child: const Text('Select Row and Process Data',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
          SizedBox.fromSize(
            size: Size.fromHeight(20),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF135D66),
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            ),
            onPressed: _processFullData,
            child: const Text('Process Data',
                style: TextStyle(fontSize: 18, color: Colors.white)),
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
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: _data.isNotEmpty
                            ? _data.first
                                .map((col) =>
                                    DataColumn(label: Text(col.toString())))
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
          ),
        ],
      ),
    );
  }
}
