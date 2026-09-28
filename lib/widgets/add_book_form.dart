import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../l10n/generated/app_localizations.dart';
import '../models/book.dart';
import '../providers/book_providers.dart';

/// Formulaire d'ajout de livre : titre, auteur, catégorie (tous requis).
///
/// HookConsumerWidget : combine `flutter_hooks` (contrôleurs, form key)
/// et Riverpod (accès au repository) sans State manuel.
class AddBookForm extends HookConsumerWidget {
  const AddBookForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final titleController = useTextEditingController();
    final authorController = useTextEditingController();
    final categoryController = useTextEditingController();
    final isSubmitting = useState(false);

    Future<void> submit() async {
      if (!(formKey.currentState?.validate() ?? false)) return;
      isSubmitting.value = true;
      final book = Book(
        id: 'b${DateTime.now().microsecondsSinceEpoch}',
        title: titleController.text.trim(),
        author: authorController.text.trim(),
        category: categoryController.text.trim(),
      );
      try {
        await ref.read(bookRepositoryProvider).add(book);
        ref.invalidate(booksProvider);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.addBookSuccess)));
        Navigator.of(context).pop();
      } finally {
        isSubmitting.value = false;
      }
    }

    String? requiredValidator(String? value) {
      return (value == null || value.trim().isEmpty)
          ? l10n.addBookValidationRequired
          : null;
    }

    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: titleController,
              decoration: InputDecoration(labelText: l10n.addBookFieldTitle),
              textInputAction: TextInputAction.next,
              validator: requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: authorController,
              decoration: InputDecoration(labelText: l10n.addBookFieldAuthor),
              textInputAction: TextInputAction.next,
              validator: requiredValidator,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: categoryController,
              decoration: InputDecoration(
                labelText: l10n.addBookFieldCategory,
                hintText: l10n.addBookFieldCategoryHint,
              ),
              textInputAction: TextInputAction.done,
              validator: requiredValidator,
              onFieldSubmitted: (_) => submit(),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isSubmitting.value ? null : submit,
              child: isSubmitting.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.addBookSubmit),
            ),
          ],
        ),
      ),
    );
  }
}
