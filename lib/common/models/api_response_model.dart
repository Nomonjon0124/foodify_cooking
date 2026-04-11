class ApiResponseModel<T> {
  const ApiResponseModel({required this.data, this.message});

  final T data;
  final String? message;
}
