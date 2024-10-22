import 'package:flutter/material.dart';

class AboutYeah extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AboutUsSection(),
              const SizedBox(height: 30),
              WhyChoose(),
              const SizedBox(height: 30),
              TheTeamHeader(),
              const SizedBox(height: 30),
              FeaturesSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class AboutUsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'ABOUT',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Welcome to the English Learning Application Based on Games. Here, you will enhance your English skills through interactive features such as word matching, translation, dictionary, and constructing sentences.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }
}

class WhyChoose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'Why Choose Us?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(
                'Interactive and Friendly',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Our content is designed to be engaging and user-friendly, making learning enjoyable and effective.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            ListTile(
              title: Text(
                'Learn While Playing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Our application integrates game mechanics to make learning English fun and motivating.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            ListTile(
              title: Text(
                'Challenging and Logical',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'Our levels are designed to challenge your logic and problem-solving skills, enhancing your cognitive abilities.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            ListTile(
              title: Text(
                'Variety of Features',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                'We offer a wide range of features, including word matching, sentence construction, translation, and more.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TheTeamHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Align(
      alignment: Alignment.center,
      child: Text(
        'THE TEAM',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: Text(
            'FEATURES',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),
        SizedBox(height: 20),
        ListTile(
          leading: Icon(Icons.translate, color: Colors.blue),
          title: Text(
            'Translation Games',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Enhance your translation skills by translating words and sentences between English and your native language.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
        ListTile(
          leading: Icon(Icons.spellcheck, color: Colors.blue),
          title: Text(
            'Word Matching',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Match English words with their meanings or synonyms to improve your vocabulary.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
        ListTile(
          leading: Icon(Icons.sentiment_satisfied, color: Colors.blue),
          title: Text(
            'Sentence Construction',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Construct grammatically correct sentences from given words, enhancing your grammar and syntax skills.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
        ListTile(
          leading: Icon(Icons.book, color: Colors.blue),
          title: Text(
            'Interactive Dictionary',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Access a comprehensive dictionary with audio pronunciations, example sentences, and more.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}
