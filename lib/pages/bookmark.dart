import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:responsi/pages/detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'job_data.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late Future<List<Job>> _bookmarkedJobs;
  
  get http => null;

  @override
  void initState() {
    super.initState();
    _bookmarkedJobs = _loadBookmarkedJobs();
  }

  Future<List<Job>> _loadBookmarkedJobs() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedJobIds = prefs.getStringList('bookmarkedJobs') ?? [];
    final response = await http.get(Uri.parse('https://jobicy.com/api/v2/remote-jobs'));
    final jobs = JobData.fromJson(json.decode(response.body)).jobs;

    return jobs.where((job) => bookmarkedJobIds.contains(job.id.toString())).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarked Jobs'),
        backgroundColor: Colors.blueGrey[700],
      ),
      body: FutureBuilder<List<Job>>(
        future: _bookmarkedJobs,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final jobs = snapshot.data ?? [];
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
