import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:piecotrack/module/profile_screen.dart';

import 'package:piecotrack/shared/component/contasnt.dart';

import 'layout/cubit/cubit.dart';
import 'module/activity_screen.dart';
import 'module/add_activity_screen.dart';
import 'module/chart_screen.dart';
import 'module/rewardes_screen.dart';
import 'module/splash_screen.dart';

void main() {
  runApp(PiEcoTrackApp());
}

class PiEcoTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ActivityCubit()..loadActivities()),
      ],
      child: ScreenUtilInit(
        designSize: Size(360, 690), // تصميم أساسي للشاشات
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Pi EcoTrack',
            theme: ThemeData(
              primaryColor: AppColors.primaryBlue,
              scaffoldBackgroundColor: AppColors.background,

              pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: FadeTransitionBuilder(),
                  TargetPlatform.iOS: FadeTransitionBuilder(),
                },
              ),
            ),
            initialRoute: '/splash',
            routes: {
              '/splash': (context) => SplashScreen(),
              // '/login': (context) => LoginScreen(),
              '/home': (context) => HomeScreen(),
              '/add_activity': (context) => AddActivityScreen(),
            },
          );
        },
      ),
    );
  }
}

class FadeTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    ActivityScreen(),
    RewardsScreen(),
    ReportScreen(),
    ProfileScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Activities'),
          BottomNavigationBarItem(icon: Icon(Icons.currency_bitcoin), label: 'Rewards'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Report'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ).animate().scale(duration: 300.ms),
    );
  }
}