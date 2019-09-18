import 'package:flutter/material.dart';

void main() => runApp(App());

abstract class AbstractListItem {}

class HeadingItem implements AbstractListItem {
  final String heading;

  HeadingItem(this.heading);
}

class SampleItem implements AbstractListItem {
  final String name;
  final String description;
  final Widget widget;

  SampleItem(this.name, this.description, this.widget);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Flutter Samples';

    final samples = [];

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: samples.length,
          itemBuilder: (context, index) {
            final item = samples[index];

            if (item is HeadingItem) {
              return ListTile(
                title: Text(
                  item.heading,
                  style: Theme.of(context).textTheme.headline,
                ),
              );
            }

            if (item is SampleItem) {
              return ListTile(
                title: Text(item.name),
                subtitle: Text(item.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => item.widget,
                    ),
                  );
                },
              );
            }

            return null;
          },
        )
      ),
    );
  }
}
