import 'package:dog_breed_recognition/src/models/geometry.dart';

class Place {
  final Geometry geometry;
  final String? name;
  final String? vicinity;
  final String? realName;


  Place({required this.geometry,required this.name,required this.vicinity,required this.realName});

  factory Place.fromJson(Map<String,dynamic> json){
    return Place(
        geometry:  Geometry.fromJson(json['geometry']),
        name: json['formatted_address'],
        vicinity: json['vicinity'],
        realName: json['name'],
    );
  }
}