import 'package:flutter/material.dart';
import 'package:form_submit_app/view/widgets/info_card_widget.dart';

class TamisForm extends StatefulWidget {
  const TamisForm({super.key});

  @override
  State<TamisForm> createState() => _TamisFormState();
}

class _TamisFormState extends State<TamisForm> {
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: mediaquery.width * 0.04,
            vertical: mediaquery.height * 0.02,
          ),
          child: Column(
            children: [
              SizedBox(height: mediaquery.height * 0.05),
              Container(
                // height: mediaquery.height * 0.4,
                width: mediaquery.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaquery.width * 0.04,
                    vertical: mediaquery.height * 0.02,
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: mediaquery.height * 0.02),
                      Text(
                        'ACCIDENT FORM - TAMIS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: mediaquery.height * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: mediaquery.width * 0.04,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '1. General Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: mediaquery.height * 0.02),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          //horizontal: mediaquery.width * 0.01,
                          vertical: mediaquery.height * 0.02,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Source of Information',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: mediaquery.width,
                        height: mediaquery.height * 0.07,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            'Please Select',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Icon(Icons.keyboard_arrow_down_rounded),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          //horizontal: mediaquery.width * 0.01,
                          vertical: mediaquery.height * 0.02,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Report Number',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: mediaquery.width,
                        height: mediaquery.height * 0.07,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            '123456789',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          //horizontal: mediaquery.width * 0.01,
                          vertical: mediaquery.height * 0.02,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Date of Accident',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: mediaquery.width,
                        height: mediaquery.height * 0.07,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            '10/23/2025',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: mediaquery.height * 0.02),
              InfoCard(titleText: 'Time of Accident', valueText: '----------'),

              InfoCard(
                titleText: 'Initial Notification Time',
                valueText: '----------',
              ),

              InfoCard(
                titleText: 'Land Marks',
                valueText: 'Full Address of Accident',
              ),
              InfoCard(
                titleText: 'Time Patrol Reached the Scene',
                valueText: '----------',
              ),
              InfoCard(
                titleText: 'Place of Accident',
                valueText: 'Accident Place',
              ),

              InfoCard(
                titleText: 'Land Marks',
                valueText: 'Full Address of Accident',
              ),
              InfoCard(
                titleText: 'Exact Location of Accident',
                valueText: 'Lat, Long will appear here',
              ),
              InfoCard(
                titleText: 'Tehsil',
                valueText: 'Name of Concerned Tehsil',
              ),
              InfoCard(titleText: 'Town', valueText: 'Name of Concerned Town'),
              InfoCard(
                titleText: 'Concerned Police Station',
                valueText: 'Name of Concerned Police Station',
              ),
              InfoCard(
                titleText: 'Distance from Accident Spot(KMs)',
                valueText: 'Enter distance in Kilometers',
              ),
              InfoCard(titleText: 'Department', valueText: 'Select department'),
              InfoCard(titleText: 'Select Road Name', valueText: 'Select Road'),
              SizedBox(height: mediaquery.height * 0.02),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '2. Nature and Type of Accident',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: mediaquery.height * 0.02),
              
            ],
          ),
        ),
      ),
    );
  }
}
