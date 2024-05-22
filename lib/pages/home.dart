import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'detail.dart';
import 'job_data.dart';

class HomePage extends StatelessWidget {
  Future<JobData> fetchJobs() async {
    final response = await http.get(Uri.parse('https://jobicy.com/api/v2/remote-jobs'));

    if (response.statusCode == 200) {
      return JobData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remote Jobs'),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: FutureBuilder<JobData>(
        future: fetchJobs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final jobs = snapshot.data?.jobs ?? [];
            return ListView.builder(
              itemCount: jobs.length,
              itemBuilder: (context, index) {
                final job = jobs[index];
                return Card(
                  child: ListTile(
                    title: Text(job.jobTitle ?? 'No title'),
                    subtitle: Text(job.companyName ?? 'No company name'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailPage(job: job),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
