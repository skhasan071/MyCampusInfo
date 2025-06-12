class AdmissionProcess {
  final String id; // MongoDB ObjectId
  final String collegeId;
  final String startDate;
  final String applicationProcess;
  final String endDate;
  final List<String> documentsRequired;
  final List<String> requiredExams;


  AdmissionProcess({
    required this.id,
    required this.collegeId,
    required this.startDate,
    required this.applicationProcess,
    required this.endDate,
    required this.documentsRequired,
    required this.requiredExams
  });

  factory AdmissionProcess.fromMap(Map<String, dynamic> map) {
    return AdmissionProcess(
      id: map['_id'] ?? '',
      collegeId: map['collegeId'] ?? '',
      startDate: map['startDate'] ?? '',
      applicationProcess: map['applicationProcess'] ?? '',
      requiredExams: map['requiredExams']??'',
      endDate: map['endDate'] ?? '',
      documentsRequired: List<String>.from(map['documentsRequired'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'collegeId': collegeId,
      'startDate':startDate,
      'applicationProcess': applicationProcess,
      'endDate': endDate,
      'documentsRequired': documentsRequired,
      'requiredExams':requiredExams
    };
  }
}
