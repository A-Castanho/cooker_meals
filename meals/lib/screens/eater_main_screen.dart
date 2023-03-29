import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:meals/domain/models/meal.dart';
import 'package:meals/screens/create_suggestion_screen.dart';

class EaterMainScreen extends StatelessWidget {
  const EaterMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SuggestionsListScreen();
  }
}

class SuggestionsListScreen extends StatelessWidget {
  SuggestionsListScreen({super.key});
  final dumbMeals = [
    Meal(0,
        name: 'name',
        imagePath:
            'https://www.createwithnestle.ph/sites/default/files/srh_recipes/e71566dada523db52dc177bf0d0038a9.jpg',
        description: 'eggs')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateSuggestionScreen(),
                    ));
                  },
                  icon: Icon(Icons.add))
            ],
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dumbMeals.length,
              itemBuilder: (context, index) {
                final meal = dumbMeals[index];
                return SizedBox(
                  height: 100,
                  child: Card(
                    child: Row(
                      children: [
                        Image.network(meal.imagePath!, height: 100),
                        Column(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(offset: Offset(0, 10))
                                ]),
                                child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(meal.name)),
                              ),
                            ),
                            Expanded(
                                child: meal.description == null
                                    ? SizedBox.shrink()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Colors.orange,
                                            width: 10,
                                          ),
                                          Text(meal.description ?? ''),
                                        ],
                                      )),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
