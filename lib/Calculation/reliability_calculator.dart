class ReliabilityCalculator {
  final double operationalTime;
  final double maintenanceTime;
  final int totalRepairs;

  ReliabilityCalculator({
    required this.operationalTime,
    required this.maintenanceTime,
    required this.totalRepairs,
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
}
