import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceX API Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SpaceXScreen(),
    );
  }
}

class SpaceXScreen extends StatefulWidget {
  @override
  _SpaceXScreenState createState() => _SpaceXScreenState();
}

class _SpaceXScreenState extends State<SpaceXScreen> {
  List<dynamic> rockets = [];
  List<dynamic> capsules = [];

  @override
  void initState() {
    super.initState();
    fetchRockets();
    fetchCapsules();
  }

  Future<void> fetchRockets() async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v4/rockets'));
    if (response.statusCode == 200) {
      setState(() {
        rockets = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch rockets');
    }
  }

  Future<void> fetchCapsules() async {
    final response =
        await http.get(Uri.parse('https://api.spacexdata.com/v4/capsules'));
    if (response.statusCode == 200) {
      setState(() {
        capsules = jsonDecode(response.body);
      });
    } else {
      print('Failed to fetch capsules');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SpaceX Rockets and Capsules'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rockets:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                itemCount: rockets.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final rocket = rockets[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(rocket['name']),
                      subtitle: Text(rocket['description']),
                    ),
                  );
                },
              ),
              SizedBox(height: 16),
              Text(
                'Capsules:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ListView.builder(
                itemCount: capsules.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  final capsule = capsules[index];
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: Text(capsule['serial']),
                      subtitle: Text(capsule['type']),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
