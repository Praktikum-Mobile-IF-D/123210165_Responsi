class JobData {
  final List<Job> jobs;

  JobData({required this.jobs});

  factory JobData.fromJson(Map<String, dynamic> json) {
    var list = json['jobs'] as List;
    List<Job> jobsList = list.map((i) => Job.fromJson(i)).toList();
    return JobData(jobs: jobsList);
  }
}

class Job {
  final int? id;
  final String? jobTitle;
  final String? companyName;
  final String? jobDesc;

  Job({this.id, this.jobTitle, this.companyName, this.jobDesc});

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      jobTitle: json['jobTitle'],
      companyName: json['companyName'],
      jobDesc: json['jobDesc'],
    );
  }
}
