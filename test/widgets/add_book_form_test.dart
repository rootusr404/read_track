import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:read_track/l10n/generated/app_localizations.dart';
import 'package:read_track/widgets/add_book_form.dart';

Widget _wrap(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  testWidgets('shows a validation error per empty field on submit', (
    tester,
  ) async {
    await tester.pumpWidget(_wrap(const AddBookForm()));

    await tester.tap(find.text('Save book'));
    await tester.pump();

    expect(find.text('This field is required'), findsNWidgets(3));
  });

  testWidgets('clears the title validation error once filled', (tester) async {
    await tester.pumpWidget(_wrap(const AddBookForm()));

    await tester.tap(find.text('Save book'));
    await tester.pump();
    expect(find.text('This field is required'), findsNWidgets(3));

    await tester.enterText(find.byType(TextFormField).first, '1984');
    await tester.tap(find.text('Save book'));
    await tester.pump();

    expect(find.text('This field is required'), findsNWidgets(2));
  });
}
