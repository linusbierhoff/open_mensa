import 'package:flutter/material.dart';
import 'package:open_mensa/backend/mensa_api.dart';

import 'backend/line_model.dart';

void main() async {
  MensaApi mensa = MensaApi(date: DateTime.now());
  mensa.getMeals().then((value) => print(value.toString()));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'KIT Mensa',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MealStream mealStream = MealStream();

  @override
  void initState() {
    mealStream.newData(MensaApi(date: DateTime.now()).meal);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KIT Mensa"),
      ),
      body: StreamBuilder(
        stream: mealStream.stream,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          if (snapshot.data == null) return Container();
          List<Line> lines = snapshot.data!;
          lines.sort((a, b) => a.category.compareTo(b.category.toLowerCase()));
          return ListView.builder(
              itemCount: lines.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lines[i].category,
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: getMeals(lines[i]),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }

  getMeals(Line line) {
    List<Widget> children = [];
    for (var element in line.meals) {
      children.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(element.toString()),
      ));
    }
    return children;
  }
}
