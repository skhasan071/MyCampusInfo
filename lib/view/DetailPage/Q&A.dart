import 'package:my_campus_info/view_model/themeController.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QAPage extends StatefulWidget {
  final String collegeId;
  final String collegeName;

  const QAPage({super.key, required this.collegeId, required this.collegeName});

  @override
  _QAPageState createState() => _QAPageState();
}

class _QAPageState extends State<QAPage> {
  final List<Question> _questions = [];
  final List<Question> _filteredQuestions = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchQuestions();
    _searchController.addListener(filterQuestions);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void filterQuestions() {
    final keyword = _searchController.text.toLowerCase();
    setState(() {
      _filteredQuestions.clear();
      _filteredQuestions.addAll(
        _questions.where(
          (q) =>
              q.question.toLowerCase().contains(keyword) ||
              q.answer.toLowerCase().contains(keyword) ||
              q.user.toLowerCase().contains(keyword),
        ),
      );
    });
  }

  Future<void> fetchQuestions() async {
    final url = Uri.parse(
      'https://tc-ca-server.onrender.com/api/colleges/questions/${widget.collegeId}',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          _questions.clear();
          _questions.addAll(
            data.expand((doc) {
              return (doc['questions'] as List).map((qa) {
                return Question(
                  question: qa['question'] ?? '',
                  answer: qa['answer'] ?? '',
                  user: qa['user'] ?? 'Anonymous',
                  time: DateFormat(
                    'jm',
                  ).format(DateTime.parse(qa['createdAt'])),
                );
              });
            }),
          );
          _filteredQuestions.clear();
          _filteredQuestions.addAll(_questions);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Q&A - ${widget.collegeName}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: TextField(
                  controller: _searchController,
                  cursorColor: theme.filterSelectedColor,
                  decoration: InputDecoration(
                    hintText: 'Search questions',
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: theme.filterSelectedColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),

              _isLoading
                  ? Center(
                    child: CircularProgressIndicator(
                      color: theme.filterSelectedColor,
                    ),
                  )
                  : _filteredQuestions.isEmpty
                  ? const Center(child: Text('No questions found.'))
                  : ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredQuestions.length,
                    separatorBuilder:
                        (context, index) =>
                            const Divider(height: 1, color: Colors.grey),
                    itemBuilder:
                        (context, index) => _QuestionItem(
                          question: _filteredQuestions[index],
                          onAnswerPressed: () {
                            setState(() {
                              _filteredQuestions[index].isAnswerVisible =
                                  !_filteredQuestions[index].isAnswerVisible;
                            });
                          },
                        ),
                  ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => AskQuestionPage(collegeId: widget.collegeId),
              ),
            );

            if (result != null && result is Map<String, dynamic>) {
              final newQuestion = Question(
                question: result['question'],
                answer: '',
                user: result['user'],
                time: DateFormat('jm').format(DateTime.now()),
              );

              setState(() {
                _questions.insert(0, newQuestion);
                filterQuestions(); // refresh the filtered list
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Submitted successfully",
                    style: TextStyle(color: theme.filterTextColor),
                  ),
                  backgroundColor: theme.filterSelectedColor,
                ),
              );
            }
          },
          icon: const Icon(Icons.add, size: 20),
          label: const Text(
            'Ask a Question',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: theme.filterSelectedColor,
          foregroundColor: theme.filterTextColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
    });
  }
}

class AskQuestionPage extends StatefulWidget {
  final String collegeId;

  const AskQuestionPage({super.key, required this.collegeId});

  @override
  State<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final theme = ThemeController.to.currentTheme;
  bool _isSubmitting = false;

  @override
  void dispose() {
    questionController.dispose();
    nameController.dispose();
    super.dispose();
  }

  void handleSubmit() async {
    final question = questionController.text.trim();
    final name = nameController.text.trim();

    if (question.isEmpty || name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill all fields",
            style: TextStyle(color: theme.filterTextColor),
          ),
          backgroundColor: theme.filterSelectedColor,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final url = Uri.parse(
        'https://tc-ca-server.onrender.com/api/add-question',
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'collegeId': widget.collegeId,
          'user': name,
          'question': question,
        }),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context, {'user': name, 'question': question});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Submission failed",
              style: TextStyle(color: theme.filterTextColor),
            ),
            backgroundColor: theme.filterSelectedColor,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "An error occurred",
            style: TextStyle(color: theme.filterTextColor),
          ),
          backgroundColor: theme.filterSelectedColor,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final theme = ThemeController.to.currentTheme;
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Text(
            'Ask a Question',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.white,
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                cursorColor: theme.filterSelectedColor,
                decoration: InputDecoration(
                  labelText: 'Enter Your Name',
                  labelStyle: TextStyle(color: Colors.black),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.filterSelectedColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: questionController,
                maxLines: 4,
                cursorColor: theme.filterSelectedColor,
                decoration: InputDecoration(
                  labelText: 'Enter Your Question',
                  labelStyle: TextStyle(color: Colors.black),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: theme.filterSelectedColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.filterSelectedColor,
                    foregroundColor: theme.filterTextColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child:
                      _isSubmitting
                          ? CircularProgressIndicator(
                            color: theme.filterSelectedColor,
                          )
                          : const Text(
                            'Submit',
                            style: TextStyle(fontSize: 16),
                          ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class Question {
  String question;
  String user;
  String time;
  String answer;
  bool isAnswerVisible;

  Question({
    required this.question,
    required this.user,
    required this.time,
    required this.answer,
    this.isAnswerVisible = false,
  });
}

class _QuestionItem extends StatelessWidget {
  final Question question;
  final VoidCallback onAnswerPressed;

  const _QuestionItem({required this.question, required this.onAnswerPressed});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.to.currentTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.selectedTextBackground,
                child: Icon(
                  Icons.person,
                  size: 30,
                  color: theme.filterSelectedColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question.question,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${question.user} • ${question.time}',
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: onAnswerPressed,
                          child: Text(
                            'Answer',
                            style: TextStyle(color: theme.filterSelectedColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (question.isAnswerVisible)
            Padding(
              padding: const EdgeInsets.only(left: 32, top: 8),
              child: Text(
                question.answer,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
