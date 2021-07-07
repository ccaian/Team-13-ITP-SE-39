class ForumPost {
  final int id;
  final String author;
  final String date;
  final String title;
  final String description;

  ForumPost({required this.id, required this.date,required this.author, required this.title, required this.description});
}

const List sample_posts = [
  {
    "id": 1,
    "date":
    "19/1/21",
    "author":
    "Admin",
    "title":
    "Hospital Update 3",
    "description":
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut ",
  },
  {
    "id": 2,
    "date":
    "15/1/21",
    "author":
    "Admin",
    "title":
    "Nurse Meetup Session",
    "description":
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut",},
  {
    "id": 3,
    "date":
    "11/1/21",
    "author":
    "Admin",
    "title":
    "Baby Wellbeing Checkup",
    "description":
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut",
  },
  {
    "id": 4,
    "date":
    "09/1/21",
    "author":
    "Admin",
    "title":
    "Guides on Hygiene",
    "description":
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut",
  },
  {
    "id": 5,
    "date":
    "05/1/21",
    "author":
    "Admin",
    "title":
    "Hospital Update 2",
    "description":
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut",
  },
];