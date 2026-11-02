class Workshop {
  final String id;
  final String title;
  final String category;
  final String description;
  final String date;
  final String time;
  final int price;
  final String artwork;

  const Workshop({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.date,
    required this.time,
    required this.price,
    required this.artwork,
  });
}

const List<Workshop> workshops = <Workshop>[
  Workshop(
    id: 'riso',
    title: 'Two colors. Endless possibilities.',
    category: 'Risograph',
    description:
        'Turn a simple sketch into a small edition of wonderfully imperfect prints.',
    date: 'SAT 31 OCT',
    time: '10:00–13:00',
    price: 45,
    artwork: 'riso',
  ),
  Workshop(
    id: 'zine',
    title: 'A tiny book with a big point of view.',
    category: 'Zines',
    description:
        'Cut, fold, collage. Make an eight-page zine from one very ordinary sheet.',
    date: 'SUN 01 NOV',
    time: '11:00–13:00',
    price: 30,
    artwork: 'zine',
  ),
  Workshop(
    id: 'poster',
    title: 'Say it loud. Print it bigger.',
    category: 'Screenprint',
    description:
        'Pull your first screenprint and leave with a poster that deserves some wall space.',
    date: 'SAT 07 NOV',
    time: '14:00–17:00',
    price: 55,
    artwork: 'poster',
  ),
];
