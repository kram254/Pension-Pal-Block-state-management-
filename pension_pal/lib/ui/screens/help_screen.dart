    // Start Generation Here
    import 'package:flutter/material.dart';

    class HelpScreen extends StatelessWidget {
      const HelpScreen({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Help'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: const [
                Text(
                  'Welcome to the Pension Pal Help Screen!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Here you can find information on how to use the app, manage your pensions, and more.',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                ExpansionTile(
                  title: Text('How do I add a new pension?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('To add a new pension, navigate to the Add Pension screen and fill out the required form fields.'),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text('How can I view my pension details?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('You can view your pension details on the Home screen by selecting the specific pension from the list.'),
                    ),
                  ],
                ),
                ExpansionTile(
                  title: Text('How do I update my pension information?'),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('To update your pension information, go to the respective pension’s detail page and tap on the edit icon.'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Contact Support',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'If you have any other questions or need further assistance, please contact our support team at support@pensionpal.com.',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        );
      }
    }
