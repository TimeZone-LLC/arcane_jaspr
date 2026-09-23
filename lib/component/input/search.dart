import 'package:arcane_jaspr/component/card/card.dart';
import 'package:arcane_jaspr/component/input/button.dart';
import 'package:arcane_jaspr/component/input/icon_button.dart';
import 'package:arcane_jaspr/component/input/text_input.dart';
import 'package:arcane_jaspr/component/layout/flow.dart';
import 'package:arcane_jaspr/component/support/icons.dart';
import 'package:arcane_jaspr/component/view/separator.dart';
import 'package:arcane_jaspr/flutter.dart';
import 'package:arcane_jaspr/util/arcane.dart';

class SearchResult {
  final String title;
  final String? subtitle;
  final String? href;
  final void Function()? onTap;

  const SearchResult({
    required this.title,
    this.subtitle,
    this.href,
    this.onTap,
  });
}

class Search extends StatelessWidget {
  final String placeholder;
  final String? value;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final List<SearchResult> results;
  final bool showDropdown;
  final bool showClear;
  final bool autofocus;
  final bool disabled;

  const Search({
    this.placeholder = 'Search...',
    this.value,
    this.onChanged,
    this.onSubmitted,
    this.results = const <SearchResult>[],
    this.showDropdown = false,
    this.showClear = true,
    this.autofocus = false,
    this.disabled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Widget input = TextInput(
      type: TextInputType.search,
      placeholder: placeholder,
      value: value,
      disabled: disabled,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      prefix: Icon(Icons.search),
      suffix: showClear && (value?.isNotEmpty ?? false)
          ? IconButton(
              icon: Icons.x(),
              onPressed: onChanged == null ? null : () => onChanged!(''),
            )
          : null,
    );

    if (!showDropdown || results.isEmpty) {
      return input;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: <Widget>[
        input,
        Card.outlined(
          fillWidth: true,
          children: <Widget>[
            for (int index = 0; index < results.length; index++) ...<Widget>[
              Button.ghost(
                fullWidth: true,
                href: results[index].href,
                onPressed: results[index].onTap,
                label: results[index].subtitle == null
                    ? results[index].title
                    : '${results[index].title} - ${results[index].subtitle}',
              ),
              if (index < results.length - 1) const ArcaneSeparator.subtle(),
            ],
          ],
        ),
      ],
    );
  }
}
