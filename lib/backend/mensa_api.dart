import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_mensa/backend/line_model.dart';
import 'package:open_mensa/backend/meal_model.dart';

class MensaApi {
  final DateTime date;
  late String formattedDate;

  MensaApi({required this.date}) {
    formattedDate = DateFormat('yyyy-MM-dd').format(date);
  }

  Future getMeals() async {
    String canteenID = "1719";

    Uri url = Uri.https('openmensa.org',
        '/api/v2/canteens/$canteenID/days/$formattedDate/meals');
    var response = await http.get(url);

    return response;
  }

  Future<List<Line>> get meal async {
    http.Response mealsResponse = await getMeals();
    List mealJson = json.decode(mealsResponse.body);
    Map<String, List> mealMap = HashMap();

    for (var element in mealJson) {
      if (mealMap[element['category']] != null) {
        (mealMap[element['category']]?.add(element));
        continue;
      }
      mealMap[element['category']] = [element];
    }
    List<Line> lines = [];

    mealMap.forEach((key, value) {
      List<Meal> meals = [];
      for (var element in value) {
        meals.add(
            Meal(name: element['name'], price: element['prices']['students']));
      }
      lines.add(Line(category: key, meals: meals));
    });
    lines.forEach((element) {print(element);});
    return lines;
  }
}

class MealStream {
  final _mealStream = StreamController<List<Line>>();

  Stream<List<Line>> get stream {
    return _mealStream.stream;
  }

  Future<bool> newData(Future meal) async {
    _mealStream.sink.add(await meal);
    return true;
  }

  void dispose() => _mealStream.close();
}
