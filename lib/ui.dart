import 'package:flutter/material.dart';
import 'package:infinite_scrollview/model.dart';
import 'package:infinite_scrollview/provider.dart';
import 'package:infinite_scrollview/widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final controller = ScrollController();
  // bool _isLoading = false;
  // Future<Paginated<Data>> _future;

  // @override
  // void initState() {
  //   super.initState();
  //   controller.addListener(watchScroll);
  //   _future = context.read<DataProvider>().loadItems();
  // }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DataProvider>();

    return Scaffold(
      appBar: AppBar(),
      body: InfiniteScroll<Data>(
        initialData: provider.paginatedData,
        future: Provider.of<DataProvider>(context, listen: false).loadItems(),
        itemBuilder: (context, index, data) {
          return ListTile(
            title: Text("${data.name}"),
          );
        },
      ),
    );
  }
}
