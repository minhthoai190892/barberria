
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homepage extends ConsumerWidget{
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(body: Center(
      child: Text('Home page'),
    ),);
  }
  
}