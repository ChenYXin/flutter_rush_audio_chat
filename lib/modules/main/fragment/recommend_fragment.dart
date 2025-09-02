import 'package:flutter/material.dart';

class RecommendFragment extends StatefulWidget {
  const RecommendFragment({super.key});

  @override
  State<RecommendFragment> createState() => _RecommendFragmentState();
}

class _RecommendFragmentState extends State<RecommendFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Recommend'),),
    );
  }
}
