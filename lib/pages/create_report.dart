import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:roadcare/pages/set_location.dart';

class CreateReport extends StatefulWidget {
  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  Location location = new Location();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  File? _image;
  String? _selectedSeverity;
  double? _selectedLatitude;
  double? _selectedLongitude;
  final _formKey = GlobalKey<FormState>();

  pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _fetchCurrentLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();  // Fetch location when the widget is initialized
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Report Pothole"),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // Wrap your Column in a SingleChildScrollView for better usability
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(20),
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _image != null ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover, // This will cover the box, maintaining aspect ratio
                    ),
                  ) : Center(child: Text('No Image Selected', style: TextStyle(color: Colors.grey[500]))),
                ),
                // Row for camera and gallery icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Camera Icon
                    IconButton(
                      icon: CircleAvatar(
                        radius: 25.0,
                        child: Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed:(){
                        pickImage(ImageSource.camera);
                      },
                    ),
                    // Gallery Icon
                    IconButton(
                      icon: CircleAvatar(
                        radius: 25.0,
                        child: Icon(
                          Icons.photo_library,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed:(){
                        pickImage(ImageSource.gallery);
                      } ,
                    ),
                  ],
                ),
                
                // Location display
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MaterialButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => setLocation()),
                      );

                      if (result != null) {
                        setState(() {
                          _selectedLatitude = result['latitude'];
                          _selectedLongitude = result['longitude'];
                          // Update the button's text to show the selected location
                        });
                      }
                    },
                    color: Colors.blue,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15.0),
                    minWidth: double.infinity, // This will make the button width the same as TextFormField
                    child: Text(
                      _selectedLatitude != null && _selectedLongitude != null
                          ? 'Location: $_selectedLatitude, $_selectedLongitude'
                          : 'Set Location',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
          
                // Severity dropdown
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Severity',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedSeverity,
                    items: ['Low', 'Medium', 'High'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSeverity = newValue;
                      });
                    },
                    validator: (value) => value == null ? 'Please select severity' : null,
                  ),
                ),
          
                // Description TextFormField
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3, // Allow multiple lines for description
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                ),
          
                // Submit Button
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Implement the submit functionality
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Success'),
                            content: Text('Report has been submitted successfully'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue), // Set the background color here
                      foregroundColor: MaterialStateProperty.all(Colors.white), // Set the text color here
                    ),
                    child: Text('Submit Report'),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}