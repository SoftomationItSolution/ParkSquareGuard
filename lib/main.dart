import 'package:Park360/localization/localization_const.dart';
import 'package:Park360/screens/guestEntry/guest_search.dart';
import 'package:Park360/screens/screens.dart';
import 'package:Park360/theme/theme.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:page_transition/page_transition.dart';

// import 'firebase_options.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';
import 'localization/localization.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(locale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    getIntLanguageValue();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      title: 'Park360 Guard',
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
        ),
        primaryColor: primaryColor,
        scaffoldBackgroundColor: whiteColor,
        fontFamily: 'Inter',
      ),
      home: const SplashScreen(),
      onGenerateRoute: routes,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('id'),
        Locale('zh'),
        Locale('ar'),
      ],
      localizationsDelegates: [
        DemoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (deviceLocale, supportedLocale) {
        for (var locale in supportedLocale) {
          if (locale.languageCode != deviceLocale?.languageCode) {
            return deviceLocale;
          }
        }
        return supportedLocale.first;
      },
    );
  }

  Route<dynamic>? routes(settings) {
    switch (settings.name) {
      case '/':
        return PageTransition(
            child: const SplashScreen(),
            type: PageTransitionType.fade,
            settings: settings);
      case '/login':
        return PageTransition(
            child: const LoginScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/register':
        return PageTransition(
            child: const RegisterScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/otp':
        return PageTransition(
            child: const OTPScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/bottombar':
  return PageTransition(
      child: BottomBar(userData: settings.arguments as Map<String, dynamic>?),
      type: PageTransitionType.rightToLeft,
      settings: settings);
      case '/home':
        return PageTransition(
            child: const HomeScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/confirm':
  return PageTransition(
    child: ConfirmScreen(guestData: settings.arguments as Map<String, dynamic>),
    type: PageTransitionType.rightToLeft,
    settings: settings
  );
      case '/guestEntry':
        return PageTransition(
            child: const GuestEntryScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/guestREntry':
        return PageTransition(
            child: const GuestSearchScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      // case '/selectEntryAddress':
      //   return PageTransition(
      //       child: const SelectEntryAddressScreen(),
      //       type: PageTransitionType.rightToLeft,
      //       settings: settings);
      // case '/confirmAndSendNotification':
      //   return PageTransition(
      //       child: const ConfirmAndSendNotificationScreen(),
      //       type: PageTransitionType.rightToLeft,
      //       settings: settings);
      case '/ringing':
        return PageTransition(
            child: const RingingScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);

      // case '/ringing':
      //   return PageTransition(
      //     child: RingingScreen(
      //       permit: (settings.arguments as Map<String, dynamic>?)?['permit'] ?? 0,
      //     ),
      //     type: PageTransitionType.rightToLeft,
      //     settings: settings,
      //   );
      case '/allowed':
        return PageTransition(
            child: const AllowedScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/deliveryEntry':
        return PageTransition(
            child: const DeliveryEntryScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/cabEntry':
        return PageTransition(
            child: const CabEntryScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/serviceEntry':
        return PageTransition(
            child: const ServiceEntry(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/inOut':
        return PageTransition(
            child: const InOutScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/messages':
        return PageTransition(
            child: const MessagesScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/chat':
        return PageTransition(
            child: const ChatScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/settings':
        return PageTransition(
            child: const SettingsScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/editProfile':
        return PageTransition(
            child: const EditProfileScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/call':
        return PageTransition(
            child: const CallScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/language':
        return PageTransition(
            child: const LanguageScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/getSupport':
        return PageTransition(
            child: const GetSupportScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/termsAndConditions':
        return PageTransition(
            child: const TermsAndConditionScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);
      case '/privacyPolicy':
        return PageTransition(
            child: const PrivacyPolicyScreen(),
            type: PageTransitionType.rightToLeft,
            settings: settings);

       case '/selectEntryAddress':
      return PageTransition(
        child: SelectEntryAddressScreen(
          visitorData: (settings.arguments as Map?)?.map(
                (key, value) => MapEntry(key as String, value as String),
              ) ?? {},
        ),
        type: PageTransitionType.rightToLeft,
        settings: settings,
      );
    case '/confirmAndSendNotification':
      return PageTransition(
        child: ConfirmAndSendNotificationScreen(
          visitorData: (settings.arguments as Map?)?.map(
                (key, value) => MapEntry(key as String, value as String),
              ) ?? {},
        ),
        type: PageTransitionType.rightToLeft,
        settings: settings,
      );

            
      default:
        return null;
    }
  }
}
