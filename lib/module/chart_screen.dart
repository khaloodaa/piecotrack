import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../shared/component/contasnt.dart';


class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data for the chart
    final mockActivities = [
      {'day': 'Mon', 'co2': 8.0},
      {'day': 'Tue', 'co2': 6.0},
      {'day': 'Wed', 'co2': 4.0},
      {'day': 'Thu', 'co2': 7.0},
      {'day': 'Fri', 'co2': 3.0},
    ];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primaryBlue.withOpacity(0.5), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppSizes.padding),
          child: Column(
            children: [
              Text(
                'Total CO2 Saved: ${mockActivities.map((a) => a['co2'] as double).reduce((a, b) => a + b).toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontSize: AppSizes.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentGreen,
                ),
              ).animate().fadeIn(duration: 700.ms),
              SizedBox(height: 20.h),
              Expanded(
                child: mockActivities.isNotEmpty
                    ? BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: mockActivities.map((a) => a['co2'] as double).reduce((a, b) => a > b ? a : b) * 1.2,
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < mockActivities.length) {
                              return Text(
                                mockActivities[index]['day'] as String,
                                style: TextStyle(color: AppColors.grey, fontSize: AppSizes.fontSizeBody - 2.sp),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    barGroups: mockActivities.asMap().entries.map((entry) {
                      final index = entry.key;
                      final co2 = entry.value['co2'] as double? ?? 0.0;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: co2,
                            color: AppColors.accentGreen,
                            width: 20.w,
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: mockActivities.map((a) => a['co2'] as double? ?? 0.0).reduce((a, b) => a > b ? a : b),
                              color: Colors.grey[300],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ).animate().fadeIn(duration: 800.ms)
                    : Center(
                  child: Text(
                    'No data to display',
                    style: TextStyle(fontSize: AppSizes.fontSizeBody, color: AppColors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                'Track your eco impact weekly!',
                style: TextStyle(fontSize: AppSizes.fontSizeBody, color: AppColors.grey),
              ).animate().slideX(begin: 0.3, end: 0, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }
}