import 'package:jaspr/client.dart';
import 'package:neubrutalism_print_club/component_gallery.dart';
import 'package:neubrutalism_print_club/print_club.dart';

void main() => runApp(
  Uri.base.queryParameters['view'] == 'components'
      ? const ComponentGallery()
      : const PrintClub(),
);
