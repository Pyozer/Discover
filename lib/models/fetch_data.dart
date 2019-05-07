class FetchData<T> {
  bool isLoading;
  T _data;
  Exception _error;
 
  FetchData({this.isLoading = false});
 
  T get data => this._data;
  set data(T data) {
    this._error = null;
    this._data = data;
  }
 
  Exception get error => this._error;
  set error(Exception e) {
    this._error = e;
    this._data = null;
  }
 
  bool get hasData => data != null;
  bool get hasError => error != null;
}