class CustomError implements Exception {
  final String message;

  const CustomError(this.message);

  @override
  String toString() => message;
}
