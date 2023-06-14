class PagingRequest {
  static const int defaultPageSize = 15;
  static const int startPageNumber = 1;

  int pageSize = defaultPageSize; //default
  int pageNumber = startPageNumber; //default

  static createDefault() {
    return PagingRequest(defaultPageSize, startPageNumber);
  }

  static create(int pageNumber) {
    return PagingRequest(defaultPageSize, pageNumber);
  }

  PagingRequest(this.pageSize, this.pageNumber);
}
