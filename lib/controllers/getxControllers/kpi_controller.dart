import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KPIController extends GetxController {
  final formKey = GlobalKey<FormState>();

  // Reactive Dropdowns
  final selectedRegion = RxnString();
  final selectedDistrict = RxnString();
  final selectedPost = RxnString();
  final selectedRoad = RxnString();
  final selectedOfficer = RxnString();
  final selectedCategory = RxnString();
  final selectedViolationIndicator = RxnString();
  final selectedViolation = RxnString();

  // Text controllers
  final officerRank = TextEditingController();
  final officerBeltNo = TextEditingController();
  final officerCnic = TextEditingController();
  final roadUserName = TextEditingController();
  final roadUserCnic = TextEditingController();
  final mobileNo = TextEditingController();

  final selectedDateTime = Rx<DateTime>(DateTime.now());
  final isSubmitting = false.obs;

  // Dummy region data (replace with your live data)
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
  final Map<String, List<String>> officers = {
    "KHAIRPUR DAHA": ["Ahsan"],
    "KHANPUR": ["Insp. Ali"],
    "MANGA MANDI": ["Insp. Bilal"],
    "PAINSRA": ["Insp. Asghar"],
    "ROJHAN TOWER": ["Insp. Umar"],
    "HEAD PUNJNAD": ["Insp. Saleem"],
    // add more mapping as needed...
  };

  final roads = ["Road A", "Road B", "Road C"];
  // final officers = ["Officer A", "Officer B", "Officer C"];

  final categories = [
    "Public Transport",
    "Private Vehicle",
    "Commercial",
    "Other",
  ];
  final violationIndicators = ["Observed", "Not Observed"];
  final violations = [
    "Speeding",
    "Overloading",
    "Helmet Missing",
    "Wrong Side",
    "Other",
  ];

  // Firestore save
  Future<void> submitForm(BuildContext context) async {
    if (!(formKey.currentState?.validate() ?? false)) {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        backgroundColor: Colors.red.shade100,
      );
      return;
    }

    try {
      isSubmitting.value = true;

      await FirebaseFirestore.instance.collection("kpi_reports").add({
        "timestamp": FieldValue.serverTimestamp(),
        "date_time": selectedDateTime.value.toIso8601String(),
        "region": selectedRegion.value,
        "district": selectedDistrict.value,
        "php_post": selectedPost.value,
        "road": selectedRoad.value,
        "officer_observer": selectedOfficer.value,
        "officer_rank": officerRank.text.trim(),
        "officer_belt_no": officerBeltNo.text.trim(),
        "officer_cnic": officerCnic.text.trim(),
        "road_user_name": roadUserName.text.trim(),
        "road_user_cnic": roadUserCnic.text.trim(),
        "road_user_mobile": mobileNo.text.trim(),
        "category": selectedCategory.value,
        "violation_indicator": selectedViolationIndicator.value,
        "violation": selectedViolation.value,
      });

      Get.snackbar(
        "Success",
        "Form submitted successfully!",
        backgroundColor: Colors.green.shade100,
      );

      resetForm();
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to submit: $e",
        backgroundColor: Colors.red.shade100,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void resetForm() {
    selectedRegion.value = null;
    selectedDistrict.value = null;
    selectedPost.value = null;
    selectedRoad.value = null;
    selectedOfficer.value = null;
    selectedCategory.value = null;
    selectedViolationIndicator.value = null;
    selectedViolation.value = null;

    officerRank.clear();
    officerBeltNo.clear();
    officerCnic.clear();
    roadUserName.clear();
    roadUserCnic.clear();
    mobileNo.clear();

    selectedDateTime.value = DateTime.now();
  }
}
