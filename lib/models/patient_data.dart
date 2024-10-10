class Patient {
  final String id;
  final String date;
  final int age;
  final String result;
  final String resultNo;
  final String sex;
  final String note;

  Patient({
    required this.id,
    required this.date,
    required this.age,
    required this.result,
    required this.resultNo,
    required this.sex,
    this.note = '',
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      date: json['date'],
      age: json['age'],
      result: json['result'],
      resultNo: json['resultNo'],
      sex: json['sex'],
      note: json['note'] ?? '',
    );
  }

  Patient copyWith({
    String? id,
    String? date,
    int? age,
    String? result,
    String? resultNo,
    String? sex,
    String? note,
  }) {
    return Patient(
      id: id ?? this.id,
      date: date ?? this.date,
      age: age ?? this.age,
      result: result ?? this.result,
      resultNo: resultNo ?? this.resultNo,
      sex: sex ?? this.sex,
      note: note ?? this.note,
    );
  }
}