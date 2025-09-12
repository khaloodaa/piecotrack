import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../shared/component/contasnt.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data
    final String userName = "Khaled Elroby";
    final int totalActivities = 5;
    final List<String> badges = ["Eco Beginner", "Walker", "Recycler"];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        flexibleSpace: Container(

          decoration: const BoxDecoration(

            gradient: LinearGradient(

              colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)], // أخضر فاتح وداكن

              begin: Alignment.topLeft,

              end: Alignment.bottomRight,

            ),

          ),

        ),
        centerTitle: true,
      ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40.h),
              CircleAvatar(
                radius: 50.r,
                backgroundColor: AppColors.accentGreen,
                child: Icon(Icons.person, size: 60.w, color: Colors.white),
              ).animate().scale(duration: 800.ms).fadeIn(),
              SizedBox(height: 20.h),
              Text(
                userName,
                style: TextStyle(
                  fontSize: AppSizes.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryBlue,
                ),
              ).animate().fadeIn(duration: 800.ms),
              SizedBox(height: 10.h),
              Text(
                'Total Activities: $totalActivities',
                style: TextStyle(fontSize: AppSizes.fontSizeBody, color: AppColors.grey),
              ).animate().fadeIn(duration: 900.ms),
              SizedBox(height: 20.h),
              Text(
                'Badges',
                style: TextStyle(
                  fontSize: AppSizes.fontSizeTitle,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentGreen,
                ),
              ).animate().fadeIn(duration: 1000.ms),
              SizedBox(height: 10.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: badges.map((badge) {
                  return Chip(
                    label: Text(badge, style: TextStyle(fontSize: AppSizes.fontSizeBody - 2.sp)),
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                  ).animate().scale(duration: 500.ms);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}