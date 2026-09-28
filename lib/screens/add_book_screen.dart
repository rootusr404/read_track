import 'package:flutter/material.dart';

import '../l10n/generated/app_localizations.dart';
import '../widgets/add_book_form.dart';

class AddBookScreen extends StatelessWidget {
  const AddBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addBookTitle)),
      body: const SingleChildScrollView(child: AddBookForm()),
    );
  }
}
