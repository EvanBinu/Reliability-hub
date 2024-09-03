import 'package:flutter/material.dart';
import 'package:reliability_hub/screens/system_of_components_page.dart';
import 'package:reliability_hub/screens/import.dart';


class ReliabilityCalculator {
  final double operationalTime;
  final double maintenanceTime;
  final int totalRepairs;
  final bool parallel;
  final bool series;
  final int numberOfRows;

  ReliabilityCalculator({
    required this.operationalTime,
    required this.maintenanceTime,
    required this.totalRepairs,
     this.parallel =false,
     this.series = false,
     this.numberOfRows=0,
  });

  double calculateMTBF() {
    return totalRepairs > 0 ? operationalTime / totalRepairs : 0;
  }

  double calculateMTTR() {
    return totalRepairs > 0 ? maintenanceTime / totalRepairs : 0;
  }

  double calculateAvailability() {
    final mtbf = calculateMTBF();
    final mttr = calculateMTTR();
    return mtbf + mttr > 0 ? mtbf / (mtbf + mttr) : 0;
  }

  // Method to calculate reliability based on system type
  // double calculateReliability() {
  //   if (parallel) {
  //     return calculateParallel();
  //   } else {
  //     return calculateSeries();
  //   }
  // }
  //
  // // Placeholder for parallel reliability calculation
  // int calculateParallel() {
  //
  //
  // }
  //
  // // Placeholder for series reliability calculation
  // double calculateSeries() {
  //
  //   return calculateAvailability() * numberOfRows;
  // }
}
