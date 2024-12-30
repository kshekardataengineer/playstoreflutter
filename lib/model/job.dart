class Job {
  String companyName;
  String role;
  bool paid;
  String jobDesignation;
  String jobType;
  String salary;
  String visaStatus;
  String requirements;
  String status;
  String contactWebsite;
  String contactEmail;
  String contactName;
  String country;
  String state;
  String location;

  Job({
    required this.companyName,
    required this.role,
    required this.paid,
    required this.jobDesignation,
    required this.jobType,
    required this.salary,
    required this.visaStatus,
    required this.requirements,
    required this.status,
    required this.contactWebsite,
    required this.contactEmail,
    required this.contactName,
    required this.country,
    required this.state,
    required this.location,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      companyName: json['company_name'] ?? '',
      role: json['role'] ?? '',
      paid: json['paid'] == 'true',
      jobDesignation: json['job_designation'] ?? '',
      jobType: json['job_type'] ?? '',
      salary: json['salary'] ?? '',
      visaStatus: json['visa_status'] ?? '',
      requirements: json['requirements'] ?? '',
      status: json['status'] ?? '',
      contactWebsite: json['contact_website'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactName: json['contact_name'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      location: json['location'] ?? '',
    );
  }

  static List<Job> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Job.fromJson(json)).toList();
  }
}
