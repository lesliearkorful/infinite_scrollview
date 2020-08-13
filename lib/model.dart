class PaginatedData<T> {
  List<T> data;
  int currrentPage;
  int previousPage;
  int nextPage;
  final int totalDataCount;
  final int totalPages;

  PaginatedData({
    this.currrentPage,
    this.data,
    this.nextPage,
    this.previousPage,
    this.totalDataCount,
    this.totalPages,
  });
}

class Data {
  final String name;
  Data({this.name});
}
