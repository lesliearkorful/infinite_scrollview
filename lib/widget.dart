import 'package:flutter/material.dart';
import 'package:infinite_scrollview/model.dart';

typedef InfiniteScrollBuilder<T> = Widget Function(
  BuildContext context,
  int index,
  T data,
);

class InfiniteScroll<T> extends StatefulWidget {
  final Future<Paginated<T>> future;
  final Paginated<T> initialData;
  final Widget firstChild;
  final Widget Function(BuildContext context, int index) divider;
  final InfiniteScrollBuilder<T> itemBuilder;
  const InfiniteScroll({
    Key key,
    this.divider,
    this.firstChild,
    this.future,
    this.itemBuilder,
    this.initialData,
  });

  @override
  _InfiniteScrollState<T> createState() => _InfiniteScrollState<T>();
}

class _InfiniteScrollState<T> extends State<InfiniteScroll<T>> {
  final _controller = ScrollController();
  bool _isLoading = false;
  Future<Paginated<T>> _future;

  @override
  void initState() {
    super.initState();
    _controller.addListener(watchScroll);
    _future = widget.future;
  }

  void watchScroll() {
    if (!(_controller?.hasClients ?? false)) return;
    final end = _controller.position.maxScrollExtent;
    final current = _controller.offset;
    if (current > end || _isLoading) return;
    if ((current >= end - 200)) {
      setState(() => _isLoading = true);
      _future = widget.future;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Paginated<T>>(
      initialData: widget.initialData ?? Paginated<T>(data: []),
      future: _future,
      builder: (context, snapshot) {
        final _paginated = snapshot.data;

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            _isLoading = true;
            break;
          default:
            _isLoading = false;
        }

        if (_isLoading && _paginated.data.isEmpty) {
          return Center(
            child: CircularProgressIndicator(strokeWidth: 3),
          );
        }

        final _inner = List<Widget>.generate(_paginated.data.length, (i) {
          return widget.itemBuilder(context, i, _paginated.data[i]);
        });

        final _list = [
          widget.firstChild,
          ..._inner,
          if (snapshot.connectionState == ConnectionState.waiting)
            SafeArea(
              top: false,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 10),
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
        ];

        return ListView.separated(
          separatorBuilder: (context, index) {
            if (index == 0) return SizedBox.shrink();
            return widget.divider(context, index) ?? SizedBox.shrink();
          },
          padding: MediaQuery.of(context).padding.copyWith(bottom: 50),
          controller: _controller,
          itemCount: _list.length,
          itemBuilder: (_, index) => _list[index],
        );
      },
    );
  }
}
