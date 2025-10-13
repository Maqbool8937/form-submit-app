// lib/controllers/help_form_controller.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:form_submit_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class HelpFormController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final cnicController = TextEditingController();
  final placeController = TextEditingController();
  final nameAddressContactController = TextEditingController();
  final vehicleRegNoController = TextEditingController();
  final actionController = TextEditingController();
  final policeStationController = TextEditingController();
  final descriptionController = TextEditingController();
  final notesController = TextEditingController();

  // Dropdown reactive values
  final sourceOfInfo = '1124'.obs;
  final typeOfHelp = 'Mechanical'.obs;
  final vehicleType = 'Car'.obs;
  final firstResponder = 'PHP'.obs;
  final responseTime = 'Less than 10 Min'.obs;

  // Hierarchy selections (region -> district -> post -> incharge)
  final selectedRegion = RxnString();
  final selectedDistrict = RxnString();
  final selectedPost = RxnString();
  final selectedShiftIncharge = RxnString();

  // GPS
  final gpsLocation = RxnString();
  final isFetchingLocation = false.obs;

  // Firestore submission state
  final isSubmitting = false.obs;

  // FULL region → district → post map (kept exactly as provided)
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

  // Shift incharge map (post -> list of incharges)
  final Map<String, List<String>> shiftInchargeData = {
    "KHANPUR": ["Insp. Ali"],
    "MANGA MANDI": ["Insp. Bilal"],
    "PAINSRA": ["Insp. Asghar"],
    "ROJHAN TOWER": ["Insp. Umar"],
    "HEAD PUNJNAD": ["Insp. Saleem"],
    // add more mapping as needed...
  };

  // Start listening to location stream
  StreamSubscription<Position>? _positionSubscription;

  Future<void> getCurrentLocation() async {
    isFetchingLocation.value = true;
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar("Location Error", "Location services are disabled.");
        isFetchingLocation.value = false;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar("Permission Denied", "Location permission denied.");
        isFetchingLocation.value = false;
        return;
      }

      // cancel an existing subscription if any
      await _positionSubscription?.cancel();

      _positionSubscription =
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
        "Please select Region, District, Post and Incharge.",
      );
      return;
    }

    isSubmitting.value = true;
    try {
      await FirebaseFirestore.instance.collection('help_forms').add({
        'date': DateTime.now().toIso8601String(),
        'time': TimeOfDay.now().format(context),
        'region': selectedRegion.value,
        'district': selectedDistrict.value,
        'php_post': selectedPost.value,
        'shift_incharge': selectedShiftIncharge.value,
        'cnic': cnicController.text,
        'source_of_info': sourceOfInfo.value,
        'place': placeController.text,
        'gps_location': gpsLocation.value,
        'police_station': policeStationController.text,
        'type_of_help': typeOfHelp.value,
        'name_address_contact': nameAddressContactController.text,
        'vehicle_type': vehicleType.value,
        'vehicle_registration': vehicleRegNoController.text,
        'action_taken': actionController.text,
        'first_responder': firstResponder.value,
        'response_time': responseTime.value,
        'brief_description': descriptionController.text,
        'notes': notesController.text,
      });

      Get.snackbar("Success", "Help Form Submitted ✅");
      // navigate back to dashboard (keep your original behavior)
      Get.off(
        () => DashboardScreen(userData: {}),
      ); // placeholder; replace with Dashboard if needed
      resetForm();
    } catch (e) {
      Get.snackbar("Error", "Failed to submit form: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    formKey.currentState?.reset();

    gpsLocation.value = null;
    selectedRegion.value = null;
    selectedDistrict.value = null;
    selectedPost.value = null;
    selectedShiftIncharge.value = null;

    sourceOfInfo.value = "1124";
    typeOfHelp.value = "Mechanical";
    vehicleType.value = "Car";
    firstResponder.value = "PHP";
    responseTime.value = "Less than 10 Min";

    cnicController.clear();
    placeController.clear();
    nameAddressContactController.clear();
    vehicleRegNoController.clear();
    actionController.clear();
    policeStationController.clear();
    descriptionController.clear();
    notesController.clear();
  }

  @override
  void onClose() {
    cnicController.dispose();
    placeController.dispose();
    nameAddressContactController.dispose();
    vehicleRegNoController.dispose();
    actionController.dispose();
    policeStationController.dispose();
    descriptionController.dispose();
    notesController.dispose();
    _positionSubscription?.cancel();
    super.onClose();
  }
}
