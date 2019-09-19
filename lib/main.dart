import 'package:flutter/material.dart';
import 'SamplesList.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final title = 'Flutter Samples';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          itemCount: samplesList.length,
          itemBuilder: (context, index) {
            final item = samplesList[index];

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
      theme: ThemeData(
        textTheme: TextTheme(
          subhead: TextStyle(fontSize: 18.4),
          body1: TextStyle(fontSize: 18.4),
          button: TextStyle(fontSize: 16.0),
        ),
      )
    );
  }
}
