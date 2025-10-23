import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';

/// {@template country_code}
/// A single country code item.
///
/// Contains a [name], [code], and [dialCode].
///
/// [CountryCode]s are immutable and can be copied using [copyWith] and
/// which are basically from [List] of [Map<String, String>] that are
/// converted using the [CountryCode.fromMap] method.
///
/// You can also get the widget that contains the [CountryCode]'s flag image
/// by calling the [flagImage] getter method.
/// {@endtemplate}
@immutable
class CountryCode {
  /// {@macro country_code}
  const CountryCode({
    required this.name,
    required this.code,
    required this.dialCode,
    this.nationalSignificantNumber,
  });

  /// Converts the country code from map to the actual item.
  factory CountryCode.fromMap(Map<String, dynamic> map) {
    return CountryCode(
      name: map['name'] as String? ?? 'United States',
      code: map['code'] as String? ?? 'US',
      dialCode: map['dial_code'] as String? ?? '+1',
      nationalSignificantNumber: map['national_significant_number'] as int?,
    );
  }

  /// Gets [CountryCode] based on the given dial code.
  /// Returns `null` if not found.
  static CountryCode? fromDialCode(String? dialCode) {
    if (dialCode == null) return null;

    var formattedDC = dialCode;
    if (!dialCode.startsWith('+')) formattedDC = '+$formattedDC';

    final allCountryCodes = codes.map(CountryCode.fromMap).toList();

    final index = allCountryCodes.indexWhere((c) => c.dialCode == formattedDC);
    if (index == -1) return null;

    return allCountryCodes[index];
  }

  /// Gets [CountryCode] based on the given country code.
  /// Returns `null` if not found.
  static CountryCode? fromCode(String? code) {
    if (code == null) return null;

    final allCountryCodes = codes.map(CountryCode.fromMap).toList();

    final index = allCountryCodes
        .indexWhere((c) => c.code.toUpperCase() == code.toUpperCase());
    if (index == -1) return null;

    return allCountryCodes[index];
  }

  /// Gets [CountryCode] based on the given country name.
  /// Returns `null` if not found.
  static CountryCode? fromName(String? name) {
    if (name == null) return null;

    final allCountryCodes = codes.map(CountryCode.fromMap).toList();

    final index = allCountryCodes
        .indexWhere((c) => c.name.toLowerCase() == name.toLowerCase());
    if (index == -1) return null;

    return allCountryCodes[index];
  }

  /// The name of the country.
  ///
  /// Cannot be empty.
  final String name;

  /// {@template code}
  /// The 2 character ISO code of the country.
  ///
  /// For more info: https://countrycode.org
  /// {@endtemplate}
  final String code;

  /// {@template dial_code}
  /// The country dial code.
  ///
  /// By convention, international telephone numbers are
  /// represented by prefixing the country code with a plus sign (+).
  ///
  /// This properties return [String] value like this:
  /// `+1` for US.
  ///
  /// For more info: https://en.wikipedia.org/wiki/List_of_country_calling_codes
  /// {@endtemplate}
  final String dialCode;

  /// The number of digits that allow to uniquely identify a number
  /// within the country. It excludes the country code and any trunk code or
  /// access code. It includes the mobile prefix towards the total
  /// number of digits.
  ///
  /// This can be used to validate the length of the phone input.
  ///
  /// Returns `null` if country doesn't have concrete value for NSN.
  ///
  /// ### Warning
  /// The provided NSN might not be accurate. Please read the link
  /// below to make sure that the possible range of countries that your user
  /// might select is correct.
  ///
  /// For more info: https://en.wikipedia.org/wiki/List_of_mobile_telephone_prefixes_by_country
  final int? nationalSignificantNumber;

  /// Convenient getter for localized version of this country code.
  CountryCode localize(BuildContext context) => copyWith(
        name: CountryLocalizations.of(context)?.translation(code),
      );

  /// Uri of this [CountryCode] located at package's directory to supply
  /// at [Image] widget if you're going to get the raw flag image.
  ///
  /// Don't forget to use the `flagImagePackage` to prevent [OS not found]
  /// error because it is inside the package's bundle.
  ///
  /// ### Example
  /// ```dart
  ///      Image.asset(
  ///        fit: fit,
  ///        width: width,
  ///        countryCode.flagUri,
  ///        alignment: alignment,
  ///        package: countryCode.flagImagePackage,
  ///      );
  /// ```
  String get flagUri => 'assets/flags/${code.toLowerCase()}.png';

  /// Package to supply at [Image] widget if you're going to get
  /// the raw flag image.
  String get flagImagePackage => 'fl_country_code_picker';

  /// Gets the widget that can be used on displaying
  /// the selected country's flag.
  CountryCodeFlagWidget flagImage({
    BoxFit? fit,
    double width = 32,
    AlignmentGeometry alignment = Alignment.center,
  }) =>
      CountryCodeFlagWidget(
        fit: fit,
        width: width,
        countryCode: this,
        alignment: alignment,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CountryCode &&
        other.name == name &&
        other.code == code &&
        other.dialCode == dialCode &&
        other.nationalSignificantNumber == nationalSignificantNumber;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      code.hashCode ^
      dialCode.hashCode ^
      nationalSignificantNumber.hashCode;

  /// Returns a copy of this [CountryCode] with the given values updated.
  CountryCode copyWith({
    String? name,
    String? code,
    String? dialCode,
    int? nationalSignificantNumber,
  }) {
    return CountryCode(
      name: name ?? this.name,
      code: code ?? this.code,
      dialCode: dialCode ?? this.dialCode,
      nationalSignificantNumber:
          nationalSignificantNumber ?? this.nationalSignificantNumber,
    );
  }

  /// Normalizes text by removing accents and converting to lowercase.
  /// This is useful for accent-insensitive search functionality.
  static String normalizeText(String text) {
    const Map<String, String> accentMap = {
      'À': 'A', 'Á': 'A', 'Â': 'A', 'Ã': 'A', 'Ä': 'A', 'Å': 'A',
      'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
      'Ā': 'A', 'ā': 'a', 'Ă': 'A', 'ă': 'a', 'Ą': 'A', 'ą': 'a',
      'Ç': 'C', 'ç': 'c', 'Ć': 'C', 'ć': 'c', 'Ĉ': 'C', 'ĉ': 'c',
      'Ċ': 'C', 'ċ': 'c', 'Č': 'C', 'č': 'c', 'Ď': 'D', 'ď': 'd',
      'Đ': 'D', 'đ': 'd', 'È': 'E', 'É': 'E', 'Ê': 'E', 'Ë': 'E',
      'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e', 'Ē': 'E', 'ē': 'e',
      'Ĕ': 'E', 'ĕ': 'e', 'Ė': 'E', 'ė': 'e', 'Ę': 'E', 'ę': 'e',
      'Ě': 'E', 'ě': 'e', 'Ĝ': 'G', 'ĝ': 'g', 'Ğ': 'G', 'ğ': 'g',
      'Ġ': 'G', 'ġ': 'g', 'Ģ': 'G', 'ģ': 'g', 'Ĥ': 'H', 'ĥ': 'h',
      'Ħ': 'H', 'ħ': 'h', 'Ì': 'I', 'Í': 'I', 'Î': 'I', 'Ï': 'I',
      'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i', 'Ĩ': 'I', 'ĩ': 'i',
      'Ī': 'I', 'ī': 'i', 'Ĭ': 'I', 'ĭ': 'i', 'Į': 'I', 'į': 'i',
      'İ': 'I', 'ı': 'i', 'Ĵ': 'J', 'ĵ': 'j', 'Ķ': 'K', 'ķ': 'k',
      'ĸ': 'k', 'Ĺ': 'L', 'ĺ': 'l', 'Ļ': 'L', 'ļ': 'l', 'Ľ': 'L',
      'ľ': 'l', 'Ŀ': 'L', 'ŀ': 'l', 'Ł': 'L', 'ł': 'l', 'Ñ': 'N',
      'ñ': 'n', 'Ń': 'N', 'ń': 'n', 'Ņ': 'N', 'ņ': 'n', 'Ň': 'N',
      'ň': 'n', 'ŉ': 'n', 'Ŋ': 'N', 'ŋ': 'n', 'Ò': 'O', 'Ó': 'O',
      'Ô': 'O', 'Õ': 'O', 'Ö': 'O', 'Ø': 'O', 'ò': 'o', 'ó': 'o',
      'ô': 'o', 'õ': 'o', 'ö': 'o', 'ø': 'o', 'Ō': 'O', 'ō': 'o',
      'Ŏ': 'O', 'ŏ': 'o', 'Ő': 'O', 'ő': 'o', 'Ŕ': 'R', 'ŕ': 'r',
      'Ŗ': 'R', 'ŗ': 'r', 'Ř': 'R', 'ř': 'r', 'Ś': 'S', 'ś': 's',
      'Ŝ': 'S', 'ŝ': 's', 'Ş': 'S', 'ş': 's', 'Š': 'S', 'š': 's',
      'Ţ': 'T', 'ţ': 't', 'Ť': 'T', 'ť': 't', 'Ŧ': 'T', 'ŧ': 't',
      'Ù': 'U', 'Ú': 'U', 'Û': 'U', 'Ü': 'U', 'ù': 'u', 'ú': 'u',
      'û': 'u', 'ü': 'u', 'Ũ': 'U', 'ũ': 'u', 'Ū': 'U', 'ū': 'u',
      'Ŭ': 'U', 'ŭ': 'u', 'Ů': 'U', 'ů': 'u', 'Ű': 'U', 'ű': 'u',
      'Ų': 'U', 'ų': 'u', 'Ŵ': 'W', 'ŵ': 'w', 'Ŷ': 'Y', 'ŷ': 'y',
      'Ÿ': 'Y', 'Ź': 'Z', 'ź': 'z', 'Ż': 'Z', 'ż': 'z', 'Ž': 'Z',
      'ž': 'z', 'ſ': 's',
    };
    
    String normalized = text.toLowerCase();
    accentMap.forEach((accent, replacement) {
      normalized = normalized.replaceAll(accent, replacement);
    });
    return normalized;
  }
}

/// {@template country_code_flag}
/// Widget that can be used on retrieving the flag's image.
/// {@endtemplate}
class CountryCodeFlagWidget extends StatelessWidget {
  /// {@macro country_code_flag}
  const CountryCodeFlagWidget({
    required this.width,
    required this.alignment,
    required this.countryCode,
    this.fit,
    super.key,
  });

  /// The associated [CountryCode] for display.
  final CountryCode countryCode;

  /// BoxFit property of the widget.
  final BoxFit? fit;

  /// Alignment property of the widget.
  final AlignmentGeometry alignment;

  /// Width property of the widget.
  final double width;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      countryCode.flagUri,
      fit: fit,
      width: width,
      alignment: alignment,
      package: countryCode.flagImagePackage,
    );
  }
}
