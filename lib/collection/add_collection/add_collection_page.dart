import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_saver/collection/add_collection/bloc/collection_bloc.dart';
import 'package:link_saver/collection/list_collection/list_collection_page.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:links_repository/links_repository.dart';

class AddCollectionPage extends StatelessWidget {
  const AddCollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditCollectionBloc(
        linksRepository: context.read<LinksRepository>(),
      )..add(AddLinkstoCollectionSubscriptionRequested()),
      child: AddCollectionView(),
    );
  }
}

class AddCollectionView extends StatefulWidget {
  const AddCollectionView({super.key});

  @override
  State<AddCollectionView> createState() => _AddCollectionViewState();
}

class _AddCollectionViewState extends State<AddCollectionView> {
  @override
  Widget build(BuildContext context) {
    final collectionBloc = context.read<EditCollectionBloc>();
    final l10n = context.l10n;
    final state = context.select((EditCollectionBloc bloc) => bloc.state);
    SnackBar snackbar;

    return BlocListener<EditCollectionBloc, EditCollectionState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == EditCollectionStatus.failure) {
          snackbar =
              createSnackbar(context, l10n.addFolderErrorSnackbarText, true);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        if (state.status == EditCollectionStatus.loadingLinkFailure) {
          snackbar = createSnackbar(
              context, l10n.linksOverviewErrorSnackbarText, true);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
        if (state.status == EditCollectionStatus.saveSuccess) {
          Navigator.pop(context);
          Navigator.pop(context, true);
          snackbar =
              createSnackbar(context, l10n.addFolderSuccessSnackbarText, false);
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      child: BlocBuilder<EditCollectionBloc, EditCollectionState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: ElevatedButton(
              child: Text("Next"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                      value: collectionBloc,
                      child: MyDialog(),
                    );
                  },
                );
              },
            ),
            appBar: AppBar(
              title: Text(
                "Add Folders",
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? LinkSaverLighTheme().color
                      : LinkSaverDarkTheme().color,
                ),
              ),
              actions: [],
            ),
            body: CupertinoScrollbar(
              child: Column(
                children: [
                  ListTile(
                    onTap: () {},
                    leading: Text(
                      'Add links into new folder',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      "${state.addLinks.length} links selected",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ListTile(
                    title: TextField(
                      key: const Key('add_collections_page_search_TextField'),
                      decoration: InputDecoration(
                        hintText: '   Search by title ...',
                        hintStyle: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? LinkSaverLighTheme().color
                                  : LinkSaverDarkTheme().color,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? LinkSaverLighTheme().color
                            : LinkSaverDarkTheme().color,
                      ),
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (value) {
                        context
                            .read<EditCollectionBloc>()
                            .add(EditCollectionFilterByTitleChanged(value));
                      },
                    ),
                  ),
                  StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        if (state.filteredCollectionLinks.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                l10n.linksOverviewEmptyWithFilterText,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          );
                        }
                        return Expanded(child: CheckBoxInListView());
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog();

  @override
  State<MyDialog> createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  Widget build(BuildContext context) {
    final status =
        context.select((EditCollectionBloc bloc) => bloc.state.status);

    return AlertDialog(
      title: Text(
        'Add Folder',
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
              decoration: InputDecoration(labelText: 'Folder Name'),
              onChanged: (value) {
                context
                    .read<EditCollectionBloc>()
                    .add(EditCollectionTitleChanged(value));
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<EditCollectionBloc>().add(
                  const EditCollectionSubmitted(),
                );
          },
          child: status.isSaveLoadingOrSuccess
              ? const CupertinoActivityIndicator()
              : Text(
                  'Add',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? LinkSaverLighTheme().color
                        : LinkSaverDarkTheme().color,
                  ),
                ),
        ),
      ],
    );
  }
}

class CheckBoxInListView extends StatefulWidget {
  @override
  _CheckBoxInListViewState createState() => _CheckBoxInListViewState();
}

class _CheckBoxInListViewState extends State<CheckBoxInListView> {
  @override
  Widget build(BuildContext context) =>
      BlocBuilder<EditCollectionBloc, EditCollectionState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              for (final link in state.filteredCollectionLinks) ...[
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(link.title),
                  subtitle: Text(link.link),
                  value: link.isChecked,
                  onChanged: (val) {
                    context.read<EditCollectionBloc>().add(
                          AddLinksToCollectionChanged(link, val!),
                        );
                  },
                ),
              ],
            ],
          );
        },
      );
}
