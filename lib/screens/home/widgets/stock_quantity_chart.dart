import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class StockQuantityChart extends StatelessWidget {
  final List<int> stockInData;
  final List<int> stockOutData;

  const StockQuantityChart({
    super.key,
    required this.stockInData,
    required this.stockOutData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text("Stock quantity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const Text("The quantity of the stock"),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              borderData: FlBorderData(show: false),
              barGroups: List.generate(stockInData.length, (index) {
                return BarChartGroupData(x: index, barRods: [
                  BarChartRodData(
                    toY: stockOutData[index].toDouble(),
                    color: Colors.red,
                    width: 8,
                    borderRadius: BorderRadius.zero,
                  ),
                  BarChartRodData(
                    toY: stockInData[index].toDouble(),
                    color: Colors.deepPurple,
                    width: 8,
                    borderRadius: BorderRadius.zero,
                  ),
                ]);
              }),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text("Stock ${value.toInt() + 1}", style: const TextStyle(fontSize: 10)),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: true, interval: 10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
