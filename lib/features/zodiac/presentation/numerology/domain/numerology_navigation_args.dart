class NumerologyInputArgs {
  const NumerologyInputArgs({this.prefillUserData = true});

  final bool prefillUserData;
}

class NumerologyResultArgs {
  const NumerologyResultArgs({
    required this.birthDate,
    required this.fullName,
    this.isTemporary = false,
  });

  final DateTime birthDate;
  final String fullName;
  final bool isTemporary;
}
