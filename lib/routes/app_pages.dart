import 'package:ausa/features/appointments/page/appointment_scheduling_page.dart';
import 'package:ausa/features/appointments/page/appointment_edit_page.dart';
import 'package:ausa/features/appointments/page/scheduled_appointments_page.dart';
import 'package:ausa/features/demo/page/demo_page.dart';
import 'package:ausa/features/health_schedule/page/health_schedule_page.dart';
import 'package:ausa/features/health_schedule/page/meal_times_page.dart';
// import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
// import 'package:ausa/features/profile/page/profile_page.dart';
// import 'package:ausa/features/settings/page/setting_page.dart';
import 'package:ausa/features/vitals_history/page/vitals_history_page.dart';
import 'package:ausa/features/vitals_history/page/media_test_history_page.dart';
import 'package:ausa/features/teleconsultation/page/base_teleconsultation_page.dart';
import 'package:ausa/features/tests/page/test_selection_page.dart';
import 'package:ausa/features/tests/page/test_execution_page.dart';
import 'package:ausa/features/tests/page/test_results_page.dart';
import 'package:ausa/features/home/page/home_page.dart';

// Onboarding imports
// import 'package:ausa/features/onboarding/view/splash_page.dart';
// import 'package:ausa/features/onboarding/view/onboarding_wrapper.dart';
// import 'package:ausa/features/onboarding/view/phone_input_modal.dart';
// import 'package:ausa/features/onboarding/view/otp_verification_view.dart';
// import 'package:ausa/features/onboarding/view/personal_detail_input_page.dart'; // File is commented out
// import 'package:ausa/features/onboarding/view/terms_condtion_page.dart';

// Profile imports
// import 'package:ausa/features/profile/page/profile_page.dart';
// import 'package:ausa/features/profile/page/edit_personal_page.dart';
// import 'package:ausa/features/profile/page/edit_contact_page.dart';
// import 'package:ausa/features/profile/page/add_photo_page.dart';
// import 'package:ausa/features/profile/page/family_page.dart';
// import 'package:ausa/features/profile/page/add_new_member.dart';
// import 'package:ausa/features/profile/page/family_input_page.dart';
// import 'package:ausa/features/profile/page/email_invite_page.dart';
// import 'package:ausa/features/profile/page/care_page.dart';
// import 'package:ausa/features/profile/page/condition_page.dart';
// import 'package:ausa/features/profile/page/ausa_connect.dart';

// Settings imports
// import 'package:ausa/features/settings/page/setting_page.dart';
// import 'package:ausa/features/settings/page/bluetooth_page.dart';
// import 'package:ausa/features/settings/page/call_settings_page.dart';
// import 'package:ausa/features/settings/page/display_setting_page.dart';
// import 'package:ausa/features/settings/page/notification_settings_page.dart';

import 'package:ausa/routes/app_routes.dart';
import 'package:get/get.dart';

abstract class AppPages {
  static const String initialRoute = AppRoutes.home;

  static final List<GetPage> pages = [
    // GetPage(name: AppRoutes.onboarding, page: () => OnboardingWrapper()),
    // GetPage(name: AppRoutes.settings, page: () => const SettingsPage()),
    // GetPage(name: AppRoutes.profile, page: () => const ProfilePage()),
    GetPage(name: AppRoutes.home, page: () => const HomePage()),
    GetPage(
      name: AppRoutes.demo,
      page: () => const DemoPage(),
      // DemoController is created in the page with Get.put()
    ),

    // Appointment routes
    GetPage(
      name: AppRoutes.appointmentSchedule,
      page: () => const AppointmentSchedulingPage(),
      // AppointmentSchedulingController is registered globally in AppBinding
    ),
    GetPage(
      name: AppRoutes.appointmentScheduled,
      page: () => const ScheduledAppointmentsPage(),
      // AppointmentsController is registered globally in AppBinding
    ),
    GetPage(
      name: AppRoutes.appointmentEdit,
      page: () => const AppointmentEditPage(),
      // AppointmentEditController is created in the page with the appointment argument
    ),

    // Health schedule routes
    GetPage(
      name: AppRoutes.healthSchedule,
      page: () => const HealthSchedulePage(),
      // HealthScheduleController is registered globally in AppBinding
    ),
    GetPage(
      name: AppRoutes.mealTimes,
      page: () => const MealTimesPage(),
      // MealTimesController is registered globally in AppBinding
    ),

    // Vitals history routes
    GetPage(
      name: AppRoutes.vitalsHistory,
      page: () => const VitalsHistoryPage(),
      // VitalsHistoryController is registered globally in AppBinding
    ),
    GetPage(
      name: AppRoutes.mediaTestHistory,
      page: () => const MediaTestHistoryPage(),
      // MediaTestHistoryController is registered globally in AppBinding
    ),

    // Test routes
    GetPage(
      name: AppRoutes.testSelection,
      page: () => TestSelectionPage(),
      // TestController is registered globally in AppBinding
    ),
    GetPage(
      name: AppRoutes.testExecution,
      page: () => TestExecutionPage(),
      // TestController is registered globally in AppBinding
    ),
    GetPage(
      name: AppRoutes.testResults,
      page: () => TestResultsPage(),
      // TestController is registered globally in AppBinding
    ),

    // Teleconsultation route
    GetPage(
      name: AppRoutes.teleconsultation,
      page: () => BaseTeleconsultationPage(),
      // TeleconsultationController is registered globally in AppBinding
    ),

    // Onboarding routes
    // GetPage(name: AppRoutes.splash, page: () => const SplashPage()),
    // GetPage(
    //   name: AppRoutes.onboardingWrapper,
    //   page: () => const OnboardingWrapper(),
    //   // OnboardingController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.phoneInput,
    //   page: () => const PhoneNumberInputModal(),
    //   // OnboardingController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.otpVerification,
    //   page: () => const OtpVerificationView(),
    //   // OnboardingController is registered globally in AppBinding
    // ),
    // Note: PersonalDetailInputPage is currently commented out in the source file
    // GetPage(
    //   name: AppRoutes.personalDetails,
    //   page: () => const PersonalDetailInputPage(),
    //   // OnboardingController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.termsConditions,
    //   page: () => const TermsConditionPage(),
    //   // OnboardingController is registered globally in AppBinding
    // ),

    // Profile routes
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => const ProfilePage(),
    //   // ProfileController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.editPersonal,
    //   page: () => const EditPersonalPage(),
    //   // ProfileController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.editContact,
    //   page: () => const EditContactPage(),
    //   // ProfileController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.addPhoto,
    //   page: () => const AddPhotoPage(),
    //   // ProfileController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.family,
    //   page: () => const FamilyPage(),
    //   // FamilyController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.addMember,
    //   page: () => const AddNewMember(),
    //   // FamilyController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.familyInput,
    //   page: () => const FamilyInputPage(),
    //   // FamilyController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.emailInvite,
    //   page: () => const EmailInvitePage(),
    //   // ProfileController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.care,
    //   page: () => const CarePage(),
    //   // ProfileController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.condition,
    //   page: () => const ConditionPage(),
    //   // ProfileController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.ausaConnect,
    //   page: () => const AusaConnect(),
    //   // ProfileController is registered globally in AppBinding
    // ),

    // // Settings routes
    // GetPage(
    //   name: AppRoutes.settings,
    //   page: () => const SettingsPage(),
    //   // SettingController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.bluetooth,
    //   page: () => const BluetoothPage(),
    //   // SettingController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.callSettings,
    //   page: () => const CallSettingsPage(),
    //   // SettingController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.displaySettings,
    //   page: () => const DisplaySettingPage(),
    //   // SettingController is registered globally in AppBinding
    // ),
    // GetPage(
    //   name: AppRoutes.notificationSettings,
    //   page: () => const NotificationSettingsPage(),
    //   // SettingController is registered globally in AppBinding
    // ),
  ];

  static final GetPage unknownRoute = GetPage(
    name: AppRoutes.notFound,
    page: () => const HomePage(),
  );
}
