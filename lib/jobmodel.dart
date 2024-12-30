/*class Job {
  final String companyName;
  final String contactEmail;
  final String contactName;
  final String contactWebsite;
  final String jobDesignation;
  final String jobType;
  final String paid;
  final String requirements;
  final String role;
  final String salary;
  final String status;
  final String visaStatus;

  Job({
    required this.companyName,
    required this.contactEmail,
    required this.contactName,
    required this.contactWebsite,
    required this.jobDesignation,
    required this.jobType,
    required this.paid,
    required this.requirements,
    required this.role,
    required this.salary,
    required this.status,
    required this.visaStatus,
  });

  // Factory method to create a Job instance from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      companyName: json['company_name'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactName: json['contact_name'] ?? '',
      contactWebsite: json['contact_website'] ?? '',
      jobDesignation: json['job_designation'] ?? '',
      jobType: json['job_type'] ?? '',
      paid: json['paid'] ?? '',
      requirements: json['requirements'] ?? '',
      role: json['role'] ?? '',
      salary: json['salary'] ?? '',
      status: json['status'] ?? '',
      visaStatus: json['visa_status'] ?? '',
    );
  }
}
*/
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


 /* factory Job.fromJson(Map<String, dynamic> json)
  {
    return Job(
      companyName: json['companyname'],
      role: json['role'],
      paid: json['paid'].toLowerCase() == 'true',
      jobDesignation: json['job_designation'],
      jobType: json['job_type'],
      salary: json['salary'],
      visaStatus: json['visa_status'],
      requirements: json['requirements'],
      status: json['status'],
      contactWebsite: json['contact_website'],
      contactEmail: json['contact_email'],
      contactName: json['contact_name'],
      country: json['country'],
      state: json['state'],
      location: json['location'],
    );
  }*/
 /* static List<Job> fromJsonList(Map<String, dynamic> json) {
    int length = json['friendName'].length;
    List<Job> friends = [];
    for (int i = 0; i < length; i++) {
      friends.add(Job.fromJson(json));
    }
    return friends;
  }*/
  // Method to convert JSON array to list of Jobs
  static List<Job> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Job.fromJson(json['j'])).toList();
  }


  // Factory method to create a Job instance from JSON
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      companyName: json['company_name'] ?? '',
      contactEmail: json['contact_email'] ?? '',
      contactName: json['contact_name'] ?? '',
      contactWebsite: json['contact_website'] ?? '',
      jobDesignation: json['job_designation'] ?? '',
      jobType: json['job_type'] ?? '',
      paid: json['paid'] ?? '',
      requirements: json['requirements'] ?? '',
      role: json['role'] ?? '',
      salary: json['salary'] ?? '',
      status: json['status'] ?? '',
      visaStatus: json['visa_status'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      location: json['location'] ?? '',
    );
  }
}




