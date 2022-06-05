import 'package:flutter/foundation.dart';
import 'package:infinite_scrollview/model.dart';

class DataProvider extends ChangeNotifier {
  int _per = 20;

  Paginated<Data> _paginated;

  Paginated<Data> get paginatedData => _paginated;

  List<Data> _generator(int count) {
    return List.generate(
      count,
      (index) => Data(
        name: "Item ${(_paginated?.data?.length ?? 0) + index + 1}",
      ),
    );
  }

  void initialize() {
    final _dataLength = 170;
    final _list = _generator(_per);
    _paginated = Paginated(
      data: _list,
      currrentPage: 1,
      nextPage: 2,
      previousPage: 1,
      totalPages: (_dataLength / _per).ceil(),
      totalDataCount: _dataLength,
    );
  }

  Future<Paginated<Data>> loadItems() async {
    await Future.delayed(Duration(seconds: 1));
    if (_paginated == null) {
      initialize();
      return _paginated;
    }
    if (_paginated.nextPage <= _paginated.totalPages) {
      _paginated.currrentPage += 1;
      _paginated.nextPage += 1;
      _paginated.previousPage += 1;
      final _rem = _paginated.totalDataCount - _paginated.data.length;
      int _newPer = _per;
      if (_paginated.totalPages == _paginated.currrentPage && (_rem < _per)) {
        _newPer = _rem;
      }
      _paginated.data..addAll(_generator(_newPer));
      notifyListeners();
    }
    return _paginated;
  }
}
