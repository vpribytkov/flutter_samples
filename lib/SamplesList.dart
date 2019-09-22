import 'package:flutter/material.dart';
import 'PiCalculatorWidget.dart';
import 'ExpCalculatorWidget.dart';

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

final samplesList = [
	HeadingItem("Numbers"),
	SampleItem(
		"Find PI to the Nth Digit",
		"Enter a number and have the program generate PI up to that many decimal places. Keep a limit to how far the program will go.",
		PiCalculatorWidget()
	),
	SampleItem(
		"Find e to the Nth digit",
		"Enter a number and have the program generate e up to that many decimal places using different algorithms. Keep a limit to how far the program will go.",
		ExpCalculatorWidget()
	)
];