import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/src/models/country_model.dart';
import 'package:intl_phone_number_input/src/utils/test/test_helper.dart';
import 'package:intl_phone_number_input/src/utils/util.dart';

/// Creates a list of Countries with a search textfield.
class CountrySearchListWidget extends StatefulWidget {
  final List<Country> countries;
  final InputDecoration? searchBoxDecoration;
  final String? locale;
  final ScrollController? scrollController;
  final bool autoFocus;
  final bool? showFlags;
  final bool? useEmoji;
  final bool? showCountryCode;

  CountrySearchListWidget(
    this.countries,
    this.locale, {
    this.searchBoxDecoration,
    this.scrollController,
    this.showFlags,
    this.useEmoji,
    this.autoFocus = false,
    this.showCountryCode,
  });

  @override
  _CountrySearchListWidgetState createState() =>
      _CountrySearchListWidgetState();
}

class _CountrySearchListWidgetState extends State<CountrySearchListWidget> {
  late TextEditingController _searchController = TextEditingController();
  late List<Country> filteredCountries;

  @override
  void initState() {
    final String value = _searchController.text.trim();
    filteredCountries = Utils.filterCountries(
      countries: widget.countries,
      locale: widget.locale,
      value: value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Returns [InputDecoration] of the search box
  InputDecoration getSearchBoxDecoration() {
    return widget.searchBoxDecoration ?? InputDecoration(labelText: 'Search');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            key: Key(TestHelper.CountrySearchInputKeyValue),
            decoration: getSearchBoxDecoration(),
            controller: _searchController,
            autofocus: widget.autoFocus,
            onChanged: (value) {
              final String value = _searchController.text.trim();
              return setState(
                () => filteredCountries = Utils.filterCountries(
                  countries: widget.countries,
                  locale: widget.locale,
                  value: value,
                ),
              );
            },
          ),
        ),
        Flexible(
          child: ListView.builder(
            controller: widget.scrollController,
            shrinkWrap: true,
            itemCount: filteredCountries.length,
            itemBuilder: (BuildContext context, int index) {
              Country country = filteredCountries[index];

              return DirectionalCountryListTile(
                country: country,
                locale: widget.locale,
                showFlags: widget.showFlags!,
                showCountryCode: widget.showCountryCode!,
                useEmoji: widget.useEmoji!,
              );
              // return ListTile(
              //   key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
              //   leading: widget.showFlags!
              //       ? _Flag(country: country, useEmoji: widget.useEmoji)
              //       : null,
              //   title: Align(
              //     alignment: AlignmentDirectional.centerStart,
              //     child: Text(
              //       '${Utils.getCountryName(country, widget.locale)}',
              //       textDirection: Directionality.of(context),
              //       textAlign: TextAlign.start,
              //     ),
              //   ),
              //   subtitle: Align(
              //     alignment: AlignmentDirectional.centerStart,
              //     child: Text(
              //       '${country.dialCode ?? ''}',
              //       textDirection: TextDirection.ltr,
              //       textAlign: TextAlign.start,
              //     ),
              //   ),
              //   onTap: () => Navigator.of(context).pop(country),
              // );
            },
          ),
        ),
      ],
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

class DirectionalCountryListTile extends StatelessWidget {
  final Country country;
  final String? locale;
  final bool showFlags;
  final bool useEmoji;
  final bool? showCountryCode;

  const DirectionalCountryListTile({
    Key? key,
    required this.country,
    required this.locale,
    required this.showFlags,
    required this.useEmoji,
    required this.showCountryCode,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(country),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              key: Key(TestHelper.countryItemKeyValue(country.alpha2Code)),
              children: [
                Text(
                  '${Utils.getCountryName(country, locale)}',
                  style: GoogleFonts.outfit(
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 0.7,
                  child: Text(
                    country.dialCode ?? '',
                    style: GoogleFonts.outfit(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Color.fromARGB(40, 255, 255, 255),
            )
          ],
        ),
      ),
    );
  }
}

class _Flag extends StatelessWidget {
  final Country? country;
  final bool? useEmoji;

  const _Flag({Key? key, this.country, this.useEmoji}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: useEmoji!
                ? Text(
                    Utils.generateFlagEmojiUnicode(country?.alpha2Code ?? ''),
                    style: Theme.of(context).textTheme.headline5,
                  )
                : country?.flagUri != null
                    ? CircleAvatar(
                        backgroundImage: AssetImage(
                          country!.flagUri,
                          package: 'intl_phone_number_input',
                        ),
                      )
                    : SizedBox.shrink(),
          )
        : SizedBox.shrink();
  }
}

class _CountryCode extends StatelessWidget {
  final Country? country;

  const _CountryCode({Key? key, this.country}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return country != null
        ? Container(
            child: Text(
              country?.dialCode ?? '',
            ),
          )
        : SizedBox.shrink();
  }
}
