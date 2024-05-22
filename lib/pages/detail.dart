import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'job_data.dart';

class JobDetailPage extends StatefulWidget {
  final Job job;

  JobDetailPage({required this.job});

  @override
  _JobDetailPageState createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  late bool isBookmarked;

  @override
  void initState() {
    super.initState();
    _loadBookmarkStatus();
  }

  Future<void> _loadBookmarkStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedJobs = prefs.getStringList('bookmarkedJobs') ?? [];
    setState(() {
      isBookmarked = bookmarkedJobs.contains(widget.job.id.toString());
    });
  }

  Future<void> _toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkedJobs = prefs.getStringList('bookmarkedJobs') ?? [];

    if (isBookmarked) {
      bookmarkedJobs.remove(widget.job.id.toString());
    } else {
      bookmarkedJobs.add(widget.job.id.toString());
    }

    await prefs.setStringList('bookmarkedJobs', bookmarkedJobs);
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job.jobTitle ?? 'Job Detail'),
        backgroundColor: Colors.blueGrey[700],
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.job.jobTitle ?? 'No title',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(widget.job.companyName ?? 'No company name'),
            SizedBox(height: 16),
            Text(widget.job.jobDesc ?? 'No job description'),
          ],
        ),
      ),
    );
  }
}
