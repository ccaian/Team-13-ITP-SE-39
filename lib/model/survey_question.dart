class Question {
  final int id;
  final String question;
  final List<String> options;

  Question({required this.id, required this.question, required this.options});
}

const List sample_data = [
  {
    "id": 1,
    "question":
    "I have been able to laugh and see the funny side of things",
    "options": ['As much as I always could', 'Not quite so much now ', 'Definitely not so much now', 'Not at all'],
  },
  {
    "id": 2,
    "question": "I have looked forward with enjoyment to things",
    "options": ['As much as I ever did', 'Rather less than I used to', 'Definitely less than I used to', 'Hardly at all'],
  },
  {
    "id": 3,
    "question": "I have blamed myself unnecessarily when things went wrong.",
    "options": ['Yes, most of the time', 'Yes, some of the time', 'Not very often', 'No, never'],
  },
  {
    "id": 4,
    "question": "I have been anxious or worried for no good reason",
    "options": ['No, not at all', 'Hardly ever', 'Yes, sometimes', 'Yes, very often'],
  },
  {
    "id": 5,
    "question": "I have felt scared or panicky for no very good reason",
    "options": ['Yes, quite a lot ', 'Yes, sometimes', 'No, not much', 'No, not at all'],
  },
  {
    "id": 6,
    "question": "Things have been getting on top of me ",
    "options": ['Yes most of the time im unable to cope', 'Yes, sometimes I havent been coping as well', 'No, most of the time I have coped quite well ', 'No, I have been coping as well as ever'],
    "answer_index": 4,
  },
  {
    "id": 7,
    "question": "I have been so unhappy that I have had difficulty sleeping",
    "options": ['Yes, most of the time', 'Yes, sometimes', 'Not very often ', 'No, not at all'],
  },
  {
    "id": 8,
    "question": "I have felt sad or miserable",
    "options": ['Yes, most of the time', 'Yes, quite often', 'Not very often ', 'No, not at all '],
  },
  {
    "id": 9,
    "question": "I have been so unhappy that I have been crying",
    "options": ['Yes, most of the time ', 'Yes, quite often', 'Only occasionally', 'No, never'],
  },
  {
    "id": 10,
    "question": "The thought of harming myself has occurred to me",
    "options": ['Yes, quite often ', 'Sometimes', 'Hardly ever ', 'Never'],
  },
];