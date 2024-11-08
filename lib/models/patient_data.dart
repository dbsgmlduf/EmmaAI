class Patient {
  final String id;
  final String date;
  final int age;
  final String sex;
  final String result;
  final String resultNo;
  final String note;

  Patient({
    required this.id,
    required this.date,
    required this.age,
    required this.sex,
    this.result = '',
    this.resultNo = 'inconclusive',
    this.note = '',
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['patientId'],
      date: json['date'],
      age: json['age'],
      sex: json['sex'],
      result: json['result'] ?? '',
      resultNo: json['resultNo'] ?? 'inconclusive',
      note: json['note'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientId': id,
      'date': date,
      'age': age,
      'sex': sex,
      'result': result,
      'resultNo': resultNo,
      'note': note,
    };
  }

  Patient copyWith({
    String? id,
    String? date,
    int? age,
    String? sex,
    String? result,
    String? resultNo,
    String? note,
  }) {
    return Patient(
      id: id ?? this.id,
      date: date ?? this.date,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      result: result ?? this.result,
      resultNo: resultNo ?? this.resultNo,
      note: note ?? this.note,
    );
  }
}