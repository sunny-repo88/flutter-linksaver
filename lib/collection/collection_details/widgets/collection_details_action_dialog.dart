import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_saver/collection/collection_details/bloc/collection_details_bloc.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/widgets/snackbar.dart';

class CollectionDetailActionDialog extends StatefulWidget {
  const CollectionDetailActionDialog({super.key});

  @override
  State<CollectionDetailActionDialog> createState() =>
      _CollectionDetailActionDialogState();
}

class _CollectionDetailActionDialogState
    extends State<CollectionDetailActionDialog> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final collectionDetailsBloc = context.read<CollectionDetailsBloc>();
    final state = context.select((CollectionDetailsBloc bloc) => bloc.state);

    return BlocListener<CollectionDetailsBloc, CollectionDetailsState>(
      listener: (context, state) {},
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Change folder name'),
              leading: const Icon(Icons.edit_outlined),
              onTap: () {
                collectionDetailsBloc.add(
                  CollectionDetailsTitleChanged(state.collection?.name ?? ""),
                );
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                      value: collectionDetailsBloc,
                      child: EditTitleDialog(),
                    );
                  },
                );
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Add/Remove Links in this folder'),
              leading: const Icon(Icons.add_link_rounded),
              onTap: () {
                final collectionDetailsBloc =
                    context.read<CollectionDetailsBloc>();
                collectionDetailsBloc.add(
                  CollectionDetailsTitleChanged(state.collection?.name ?? ""),
                );
                collectionDetailsBloc
                    .add(CollectionDetailsEditModeChanged(true));
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              title: const Text('Delete Folder'),
              leading: const Icon(Icons.delete_forever_outlined),
              onTap: () {
                // set up the buttons
                Widget cancelButton = TextButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light
                          ? LinkSaverLighTheme().color
                          : LinkSaverDarkTheme().color,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                );
                Widget continueButton = ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text("Delete Folder"),
                  onPressed: () {
                    collectionDetailsBloc
                        .add(CollectionDetailsDeleteFolderSubmitted());
                  },
                );

                // set up the AlertDialog
                AlertDialog alert = AlertDialog(
                  title: Text(
                    "Delete Folder",
                    style: TextStyle(color: Colors.red),
                  ),
                  content: Text(
                      "This action cannot be undo. are you sure you want to delete this folder?"),
                  actions: [
                    cancelButton,
                    continueButton,
                  ],
                );

                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return alert;
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditTitleDialog extends StatefulWidget {
  const EditTitleDialog();

  @override
  State<EditTitleDialog> createState() => _EditTitleDialogState();
}

class _EditTitleDialogState extends State<EditTitleDialog> {
  @override
  Widget build(BuildContext context) {
    final state = context.select((CollectionDetailsBloc bloc) => bloc.state);
    final collectionDetailsBloc = context.read<CollectionDetailsBloc>();
    return AlertDialog(
      title: Text(
        'Edit Folder Name',
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.light
              ? LinkSaverLighTheme().color
              : LinkSaverDarkTheme().color,
        ),
      ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Edit Folder'),
              onChanged: (value) {
                context
                    .read<CollectionDetailsBloc>()
                    .add(CollectionDetailsTitleChanged(value));
              },
              initialValue: state.title,
              autofocus: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? LinkSaverLighTheme().color
                  : LinkSaverDarkTheme().color,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ElevatedButton(
          onPressed: () {
            collectionDetailsBloc.add(CollectionDetailsTitleSubmitted());
          },
          child: state.status.isLoadingOrSuccess
              ? const CupertinoActivityIndicator()
              : const Text('Save'),
        ),
      ],
    );
  }
}
