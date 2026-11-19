import 'package:arcane_jaspr/arcane_jaspr.dart' hide runApp;
import 'package:arcane_jaspr_neubrutalism/arcane_jaspr_neubrutalism.dart';
import 'package:jaspr/client.dart' show runApp;
import 'package:jaspr/jaspr.dart' show EventCallback;
import 'package:jaspr/dom.dart' as dom;

void main() => runApp(const _RatingFixture());

class _RatingFixture extends StatefulWidget {
  const _RatingFixture();

  @override
  State<_RatingFixture> createState() => _RatingFixtureState();
}

class _RatingFixtureState extends State<_RatingFixture> {
  int _rating = 3;
  int _changes = 0;
  int _submissions = 0;

  @override
  Widget build(BuildContext context) => ArcaneApp(
    stylesheet: const NeubrutalismStylesheet(),
    home: dom.form(
      events: <String, EventCallback>{
        'submit': (event) {
          event.preventDefault();
          setState(() => _submissions++);
        },
      },
      <Widget>[
        const dom.button(id: 'before', type: dom.ButtonType.button, <Widget>[
          Text('Before'),
        ]),
        dom.div(id: 'interactive', <Widget>[
          RatingStars(
            rating: _rating.toDouble(),
            interactive: true,
            onRatingChanged: (int rating) => setState(() {
              _rating = rating;
              _changes++;
            }),
          ),
        ]),
        const dom.div(id: 'static', <Widget>[RatingStars(rating: 3)]),
        const dom.div(id: 'no-callback', <Widget>[
          RatingStars(rating: 3, interactive: true),
        ]),
        const dom.button(id: 'after', type: dom.ButtonType.button, <Widget>[
          Text('After'),
        ]),
        dom.p(id: 'rating', <Widget>[Text('$_rating')]),
        dom.p(id: 'changes', <Widget>[Text('$_changes')]),
        dom.p(id: 'submissions', <Widget>[Text('$_submissions')]),
      ],
    ),
  );
}
