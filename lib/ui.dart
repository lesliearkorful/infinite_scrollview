import 'package:flutter/material.dart';
import 'package:infinite_scrollview/model.dart';
import 'package:infinite_scrollview/provider.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = ScrollController();
  bool loadMore = false;
  bool endOfContent = false;

  @override
  void initState() {
    context.read<DataProvider>().initialize();
    controller.addListener(watchScroll);
    super.initState();
  }

  void watchScroll() {
    if (!(controller?.hasClients ?? false)) return;
    final end = controller.position.maxScrollExtent;
    final current = controller.offset;
    if (current > end || loadMore) return;
    if ((current >= end - 60) && !endOfContent) {
      loadMoreFunction();
    }
  }

  void loadMoreFunction() async {
    setState(() => loadMore = true);
    await context.read<DataProvider>().loadMore();
    setState(() => loadMore = false);
  }

  List<Widget> displayedList(List<Data> original) {
    final _inner = original.map((e) => ListTile(title: Text(e.name)));
    return [
      ..._inner,
      if (loadMore)
        SafeArea(
          top: false,
          child: Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final paginated = context.watch<DataProvider>().paginatedData;
    if (paginated.data.length == paginated.totalDataCount) endOfContent = true;
    final list = displayedList(paginated.data);

    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        controller: controller,
        itemCount: list.length,
        itemBuilder: (context, index) => list[index],
      ),
    );
  }
}
