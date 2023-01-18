import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_first_portfolio/model/food_model.dart';

class GetInfo {
  GetInfo._();

  static Future<FoodModel?> getInformation({required String text}) async {
    try {
      final url = Uri.parse(
          "https://edamam-recipe-search.p.rapidapi.com/search?q=$text");
      final res = await http.get(url, headers: {
        'X-RapidAPI-Key': 'c0c7e90f22msh58e90645143bb07p175cbcjsn21fd2a2197df',
        'X-RapidAPI-Host': 'edamam-recipe-search.p.rapidapi.com'
      });

      print(res.statusCode);
      print(res.body);

      return foodModelFromJson(res.body);
    } catch (e) {
      print('error: $e');
    }
    return null;
  }
}
