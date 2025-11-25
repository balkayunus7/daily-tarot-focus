enum RegisterStatus {
  initial('Initial'),
  loading('Loading'),
  success('Success'),
  failure('Failure');

  final String value;
  const RegisterStatus(this.value);

  factory RegisterStatus.fromString(String value) =>
      RegisterStatus.values.firstWhere((e) => e.value == value);

  bool get isInitial => this == RegisterStatus.initial;
  bool get isLoading => this == RegisterStatus.loading;
  bool get isSuccess => this == RegisterStatus.success;
  bool get isFailure => this == RegisterStatus.failure;
}
