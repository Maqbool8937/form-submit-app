import 'package:flutter/material.dart';
import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class CrimeReportController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // 🔹 Text Controllers
  final cnicController = TextEditingController();
  final placeController = TextEditingController();
  final informerController = TextEditingController();
  final stolenSnatchedController = TextEditingController();
  final accusedCountController = TextEditingController();
  final accusedArrestedController = TextEditingController();
  final descriptionController = TextEditingController();
  final actionController = TextEditingController();
  final firNoController = TextEditingController();
  final firDateController = TextEditingController();
  final firSectionsController = TextEditingController();
  final policeStationController = TextEditingController();

  // 🔹 Dropdown reactive values
  final sourceInfo = "1124".obs;
  final crimeHead = "Murder".obs;
  final victimStatus = "Safe".obs;
  final weapon = "Pistol".obs;
  final vehicle = "Car".obs;
  final firstResponder = "PHP".obs;
  final responseTime = "Less than 10 Min".obs;

  // 🔹 Region → District → Post → Shift Incharge selections
  final selectedRegion = RxnString();
  final selectedDistrict = RxnString();
  final selectedPost = RxnString();
  final selectedShiftIncharge = RxnString();

  // 🔹 GPS Location
  final gpsLocation = RxnString();
  final isFetchingLocation = false.obs;

  // 🔹 Firestore loading state
  final isSubmitting = false.obs;

  // 🔹 Region → District → Post mapping
  final Map<String, Map<String, List<String>>> regionData = {
    'LHR': {
      'SKP': [
        'KHANPUR',
        'HERDEV',
        'SAIKHUM',
        'SAOMORIA',
        'FAROOQABAD',
        'BHIKHI',
        'KALASHAHKAKU',
        'BHAGODIAL',
        'KAKKARGILL',
      ],
      'NNK': ['ALIABAD', 'JAAT NAGAR', 'MALIKPUR'],
      'LHR': ['JIA BAGGA', 'MANGA MANDI', 'WAHGRAIN'],
      'KSR': [
        'NOOR PUR',
        'KOREY SIAL',
        'BHEO ASAL',
        'BHEEM KH.UR.RASHEED',
        'MALIK MEHBOOB',
        'KARANI WALA',
        'SABIR SHAHEED',
        'CHAK DEDA',
        'MUHAMMAD MALAK',
      ],
      'OKR': [
        '48/2.L',
        '48/3.R',
        'SUKHPUR',
        'QILA SONDA SING',
        'MIRAN SHAH',
        'BHUMAN SHAH',
        'HASAN GELAN',
        'BONGA SALEH',
        'KHOKAR KOTHI',
      ],
    },
    'BWP': {
      'BWP': [
        'RAMAN',
        'PUL BALOUCHAN',
        'KHAIRPUR DAHA',
        'TAHIR WALI',
        'JABBAR SHAHEED',
        'TAIL WALI',
        'KUD WALA',
        '82 MORR',
        'MALSI LINK KHAIRPUR',
        'PULL PHATIAN WALI',
        'LAL SOHANRA',
        'JHANGI WALA',
        'FATTO WALI',
        '69 SOLING',
        'ABBASI MORE',
        'FARHAN SHAHEED(CHAK 23 DNB )',
        'BASTI MALKANI',
      ],
      'RYK': [
        'MUHAMMAD PUR LAMMA',
        'LUNDA PATHAK',
        'PULL SMOOKA',
        'THULL HAMZA',
        'MAQBOOL MORR',
        'MANTHAR TOWN',
        'PULL DAGA',
        'NAWAN KOTT',
        'KALAYWALI',
        'BAUDIPUR MACHIAN',
        '173/P',
        'PUL QADIR WALI',
        'GHULAM MUHUDIN SHAHEED',
        'DINO SHAH',
        'GARHI IKHTYAR KHAN',
        'TAHLI MORR',
        'FAZAL ABAD',
        'CHOWK METLA',
        'CHAK NO.88/A',
        'MOUZA BHARA',
      ],
      'BWN': [
        'BUXIN KHAN',
        'SHAHEED CHOWK',
        '138/6-R DHARI',
        'BARIKA',
        'ADDA LATIF ABAD',
        'SUNNATIKA MORR',
        'PIR SIKANDAR',
        'LOHARKA',
        'ADDA PUL GAGIANI',
        'CHAK 117/M',
        'SAHI WALA',
        '206 MURAD',
        'DHAK PATTAN',
        'SAHOOKA PATTAN',
        '340/HR MAROT',
      ],
    },
    'DGK': {
      'DGK': [
        'RIND ADA',
        'TRIMIN',
        'KOT MOR',
        'BOHAR',
        'SHADAN LOUND',
        'TOMI MOR',
        'SAKHI SARWAR',
        'CHOTI BALA',
        'ADA HAIDERABAD',
        'MANA BANGLA',
      ],
      'LYA': [
        'LADHANA MOR',
        'RAFIQ ABAD',
        'KAPOORI',
        'NAWAN KOT',
        'GHAZI GHAT',
        'QADIRABAD',
        'SHADAD KOT',
        'KOT SULTAN',
        'PEER JAGO',
        'BASTI KOTLA',
        'MAIRA',
        'JALLI WALI',
        'PULL BINDRA',
        'JAGMAL WALA',
      ],
      'MGR': [
        'HEAD BAKAINI',
        'HAMZAYWALI',
        'HEAD PUNJNAD',
        'KHANDER MERANI',
        'MIR HAJI',
        'KHANPUR BUGA SHER',
        'GHAZI GHAT',
        'HEAD TOUNSA',
        'GABER AREIN',
        'RIAZABAD',
        'H.M.WALA',
        'LANGER WAH',
        'JAWANA BANGLA',
      ],
      'RJP': [
        'BANGLA DHENGAN',
        'BANGLA HIDAYAT',
        'ROJHAN TOWER',
        'KHAKHAR MOR',
        'SHAHWALI',
        'KOTLA ANDROON',
        'MOSA SHAHEED',
        'NAWAZ SHAHEED',
        'TIBBI SOLGI',
        'MAZHAR SHAHEED',
      ],
    },
    'FSD': {
      'FSD': [
        'KAMALPUR',
        'AMINPUR BYPASS',
        'PAINSRA',
        'ROSHEN WALI JHAL',
        'JALLAH CHOWK',
        'JASUANA BUNGALOW',
        'BUCHAKI',
        'ALIPUR BANGLOW',
        'ASGHRABAD',
        'PULL PROPIAN',
        'SENSRA',
        'SAHINWALA',
        'VAC KHURRANWALA',
        'MAKUANA',
        '96 GB',
        'KHIDERWALA',
        'PULL KAHANA',
        'BURREWAL',
        'JHAMRA',
        'KANJWANI BUNGALOW',
        'KANIAN BUNGALOW',
        'KHAI BUNGALOW',
      ],
      'FSD DIST 2': ['POST Z'],
    },
    'GRW': {
      'GRW DIST 1': ['POST 1', 'POST 2'],
    },
    'MLN': {
      'MLN DIST 1': ['POST 1'],
    },
    'SGD': {
      'SGD DIST 1': ['POST 1', 'POST 2'],
    },
    'RWP': {
      'RWP DIST 1': ['POST 1', 'POST 2'],
    },
  };

  // 🔹 Shift Incharge data
  final Map<String, List<String>> shiftInchargeData = {
    "KHAIRPUR DAHA": ["Ahsan"],
    "KHANPUR": ["Insp. Ali"],
    "MANGA MANDI": ["Insp. Bilal"],
    "PAINSRA": ["Insp. Asghar"],
    "ROJHAN TOWER": ["Insp. Umar"],
    "HEAD PUNJNAD": ["Insp. Saleem"],
    // add more mapping as needed...
  };

  // 📍 Fetch GPS location
  Future<void> getCurrentLocation() async {
    isFetchingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location Error", "Location services are disabled.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar("Permission Denied", "Location access denied.");
        return;
      }

      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((Position position) {
        gpsLocation.value =
            "${position.latitude.toStringAsFixed(5)}, ${position.longitude.toStringAsFixed(5)}";
      });
    } catch (e) {
      Get.snackbar("Error", "Error getting location: $e");
    } finally {
      isFetchingLocation.value = false;
    }
  }

  // 📤 Submit to Firestore
  Future<void> submitForm(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    if (gpsLocation.value == null) {
      Get.snackbar("Error", "Please set GPS location first 📍");
      return;
    }
    if (selectedRegion.value == null ||
        selectedDistrict.value == null ||
        selectedPost.value == null ||
        selectedShiftIncharge.value == null) {
      Get.snackbar(
        "Error",
        "Please select Region, District, Post, and Shift Incharge.",
      );
      return;
    }

    isSubmitting.value = true;
    try {
      await FirebaseFirestore.instance.collection("crime_reports").add({
        "date": DateTime.now().toIso8601String(),
        "time": TimeOfDay.now().format(context),
        "region": selectedRegion.value,
        "district": selectedDistrict.value,
        "php_post": selectedPost.value,
        "shift_incharge": selectedShiftIncharge.value,
        "cnic": cnicController.text,
        "source_info": sourceInfo.value,
        "crime_head": crimeHead.value,
        "place": placeController.text,
        "gps_location": gpsLocation.value,
        "informer": informerController.text,
        "stolen_snatched": stolenSnatchedController.text,
        "victim_status": victimStatus.value,
        "number_of_accused": accusedCountController.text,
        "accused_arrested": accusedArrestedController.text,
        "weapon": weapon.value,
        "vehicle": vehicle.value,
        "first_responder": firstResponder.value,
        "response_time": responseTime.value,
        "description": descriptionController.text,
        "action_taken": actionController.text,
        "fir_no": firNoController.text,
        "fir_date": firDateController.text,
        "fir_sections": firSectionsController.text,
        "police_station": policeStationController.text,
      });

      Get.snackbar("Success", "Crime Report Submitted ✅");
      Get.off(() => DashboardScreen(userData: {}));
      clearForm();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearForm() {
    formKey.currentState?.reset();
    gpsLocation.value = null;
    selectedRegion.value = null;
    selectedDistrict.value = null;
    selectedPost.value = null;
    selectedShiftIncharge.value = null;

    cnicController.clear();
    placeController.clear();
    informerController.clear();
    stolenSnatchedController.clear();
    accusedCountController.clear();
    accusedArrestedController.clear();
    descriptionController.clear();
    actionController.clear();
    firNoController.clear();
    firDateController.clear();
    firSectionsController.clear();
    policeStationController.clear();
  }

  @override
  void onClose() {
    cnicController.dispose();
    placeController.dispose();
    informerController.dispose();
    stolenSnatchedController.dispose();
    accusedCountController.dispose();
    accusedArrestedController.dispose();
    descriptionController.dispose();
    actionController.dispose();
    firNoController.dispose();
    firDateController.dispose();
    firSectionsController.dispose();
    policeStationController.dispose();
    super.onClose();
  }
}
