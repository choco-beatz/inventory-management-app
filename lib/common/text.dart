import 'package:flutter/material.dart';
import 'package:inventory_management_app/common/colors.dart';

class Text28 extends StatelessWidget {
  const Text28({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 28,
        ));
  }
}

class Text30 extends StatelessWidget {
  final String text;
  const Text30({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      overflow: TextOverflow.ellipsis,
      text,
      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
    );
  }
}

class TextW22 extends StatelessWidget {
  final String text;
  const TextW22({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
          fontSize: 22, color: white, fontWeight: FontWeight.w600),
    );
  }
}

class Text22 extends StatelessWidget {
  final String text;
  const Text22({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    );
  }
}

class Text16 extends StatelessWidget {
  final String text;
  const Text16({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: const TextStyle(fontSize: 16),
    );
  }
}

class Text14 extends StatelessWidget {
  final String text;
  const Text14({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      overflow: TextOverflow.visible,
      style: const TextStyle(fontSize: 14),
    );
  }
}

class TextW16 extends StatelessWidget {
  final String text;
  const TextW16({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 16, color: offWhite),
    );
  }
}

class TextM16 extends StatelessWidget {
  final String text;
  const TextM16({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 16,
          color: mainColor,
          fontWeight: FontWeight.bold),
    );
  }
}

class TextM18 extends StatelessWidget {
  final String text;
  const TextM18({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 18,
          color: mainColor,
          fontWeight: FontWeight.bold),
    );
  }
}
