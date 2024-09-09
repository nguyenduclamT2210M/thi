import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List places = [];

  @override
  void initState() {
    super.initState();
    fetchPlaces();
  }

  // Phương thức gọi API từ backend
  fetchPlaces() async {
    try {
      final response = await http.get(
          Uri.parse('http://8081/api/places/getAll')); // Địa chỉ IP đúng
      if (response.statusCode == 200) {
        setState(() {
          places = json.decode(response.body);
        });
      } else {
        setState(() {
          places = []; // Gán giá trị rỗng khi không load được
        });
        print('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        places = []; // Gán giá trị rỗng khi có lỗi
      });
      print('Error: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Destinations'),
      ),
      body: places.isEmpty
          ? Center(
        child: places.isEmpty
            ? Text('No places available, please try again later.')
            : CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: places[index]['imageUrl'] != null
                  ? Image.network(places[index]['imageUrl'], width: 50,
                  height: 50,
                  fit: BoxFit.cover)
                  : Icon(Icons.image, size: 50),
              title: Text(places[index]['name']),
              subtitle: Text(places[index]['description']),
            ),
          );
        },
      ),
    );
  }
}