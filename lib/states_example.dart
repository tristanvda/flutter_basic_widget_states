import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_basic_widget_states/constants.dart';
import 'package:provider/provider.dart';

class StatesExamplePage extends StatelessWidget {
  const StatesExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider(
        create: (context) => ValueNotifier<String>("Red"),
        builder: (context, _) {
          return SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800.0),
                child: NestedScrollView(
                  headerSliverBuilder: (context, _) => [
                    Consumer<ValueNotifier<String>>(
                      builder: (context, colorName, _) => SliverAppBar(
                        backgroundColor: Colors.grey.shade300,
                        pinned: true,
                        title: SizedBox(
                          height: 54.0,
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 16.0,
                              ),
                              Text(
                                "Select color:",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              DropdownButton<String>(
                                value: colorName.value,
                                onChanged: (name) {
                                  if (name == null) return;
                                  Provider.of<ValueNotifier<String>>(context, listen: false).value = name;
                                },
                                elevation: 16,
                                underline: Container(
                                  height: 2,
                                  color: colorsWithName[colorName.value],
                                ),
                                items: colorsWithName.keys
                                    .map((value) => DropdownMenuItem<String>(
                                          value: value,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                                            child: Row(
                                              children: [
                                                Container(
                                                  color: colorsWithName[value],
                                                  width: 40.0,
                                                  height: 20.0,
                                                ),
                                                const SizedBox(width: 16.0),
                                                Text(
                                                  value,
                                                  style: Theme.of(context).textTheme.bodyMedium,
                                                )
                                              ],
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  body: ListView(
                    children: [
                      _space(),
                      //StatelessWidget
                      const StatelessColorWidget(
                        color: Colors.green,
                        title: "Stateless Widget",
                      ),
                      _space(),
                      //StatefulWidget
                      const StatefulColorWidget(
                        keepAlive: false,
                        title: "Stateful Widget",
                      ),
                      _space(),
                      //StatefulWidget with keepAlive
                      const StatefulColorWidget(
                        keepAlive: true,
                        title: "Stateful Widget with keepAlive=true",
                      ),
                      _space(),
                      //StatelessWidget with consumer
                      const ChangeNotifiedColorWidget(
                        title: "Change notifier widget",
                      ),
                      const SizedBox(height: 2000.0), //Add enough space so items can be scrolled out of viewport
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _space() {
    return const SizedBox(height: 24.0);
  }
}

//A stateless widget that doesn't hold a state and only gets rebuild when it's configuration is changed by the parent
class StatelessColorWidget extends StatelessWidget {
  final String title;
  final Color color;

  const StatelessColorWidget({
    Key? key,
    required this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColorCard(
      color: color,
      title: title,
    );
  }
}

//A stateful widget that generates a new color every time it's tapped
class StatefulColorWidget extends StatefulWidget {
  final bool keepAlive;
  final String title;

  const StatefulColorWidget({
    Key? key,
    required this.keepAlive,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulColorWidget> createState() => _StatefulColorWidgetState();
}

class _StatefulColorWidgetState extends State<StatefulColorWidget> with AutomaticKeepAliveClientMixin {
  final _random = Random();
  late Color _randomColor;

  @override
  void initState() {
    super.initState();
    _randomColor = _generateRandomColor(null);
  }

  Color _generateRandomColor(Color? prevColor) {
    final colorList = colors.toList()..remove(prevColor);
    return colorList[_random.nextInt(colorList.length)];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () {
        setState(() {
          _randomColor = _generateRandomColor(_randomColor);
        });
      },
      child: ColorCard(
        color: _randomColor,
        title: widget.title,
      ),
    );
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;
}

//A stateless widget that receives it's color from a change notifier from a parent inherited widget
class ChangeNotifiedColorWidget extends StatelessWidget {
  final String title;

  const ChangeNotifiedColorWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ValueNotifier<String>>(builder: (context, colorName, _) {
      return ColorCard(
        color: colorsWithName[colorName.value]!,
        title: title,
      );
    });
  }
}

class ColorCard extends StatelessWidget {
  const ColorCard({
    super.key,
    required this.color,
    required this.title,
  });

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: color,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
