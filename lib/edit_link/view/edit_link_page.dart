import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_saver/edit_link/edit_link.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/links_overview/links_overview.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:links_api/links_api.dart';
import 'package:links_repository/links_repository.dart';

class EditLinkPage extends StatelessWidget {
  const EditLinkPage({super.key});

  static Route<void> route({
    Link? initialLink,
  }) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditLinkBloc(
          linksRepository: context.read<LinksRepository>(),
          initialLink: initialLink,
        )..add(const EditLinkSubscriptionRequested()),
        child: const EditLinkPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return const EditLinkView();
    final l10n = context.l10n;

    return BlocListener<EditLinkBloc, EditLinkState>(
      listenWhen: (previous, current) => (previous.status != current.status),

      listener: (context, state) => {
        if (state.status == EditLinkStatus.loadFailure)
          {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                createSnackbar(context, l10n.unexpectedErrorSnackBar, true),
              ),
          },
        if (state.status == EditLinkStatus.editLinkfailure)
          {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                createSnackbar(context, l10n.editLinkErrorSnackbarText, true),
              ),
          },
        if (state.status == EditLinkStatus.addNewFolderFailure)
          {
            Navigator.pop(context),
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                createSnackbar(context, l10n.addFolderErrorSnackbarText, true),
              ),
          },
        if (state.status == EditLinkStatus.addNewFolderSuccess)
          {
            Navigator.pop(context),
          },
        if (state.status == EditLinkStatus.editLinkSuccess)
          {
            Navigator.pop(context),
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                createSnackbar(context, l10n.changesSavedSnackbarText, false),
              ),
          },
        if (state.status == EditLinkStatus.addNewLinkSuccess)
          {
            Navigator.pop(context),
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                createSnackbar(
                    context, l10n.addedLinkSuccessfullySnackbarText, false),
              ),
          }
      }, // Navigator.of(context).pop(true),
      child: const EditLinkView(),
    );
  }
}

class EditLinkView extends StatelessWidget {
  const EditLinkView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final status = context.select((EditLinkBloc bloc) => bloc.state.status);
    final isNewLink = context.select(
      (EditLinkBloc bloc) => bloc.state.isNewLink,
    );
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ??
        theme.colorScheme.secondary;
    SnackBar snackBar;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewLink
              ? l10n.editLinkAddAppBarTitle
              : l10n.editLinkEditAppBarTitle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Scaffold(
        floatingActionButton: BlocBuilder<EditLinkBloc, EditLinkState>(
          builder: (context, state) {
            return FloatingActionButton(
              tooltip: l10n.editLinkSaveButtonTooltip,
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
              backgroundColor: status.isLoadingOrSuccess
                  ? fabBackgroundColor.withOpacity(0.5)
                  : fabBackgroundColor,
              onPressed: status.isLoadingOrSuccess
                  ? null
                  : () => {
                        if (state.title.isEmpty)
                          {
                            snackBar = createSnackbar(
                              context,
                              l10n.titleValidationMessage,
                              true,
                            ),
                            ScaffoldMessenger.of(context).showSnackBar(snackBar)
                          }
                        else if (state.link.isEmpty)
                          {
                            snackBar = createSnackbar(
                              context,
                              l10n.linkValidationMessage,
                              true,
                            ),
                            ScaffoldMessenger.of(context).showSnackBar(snackBar)
                          }
                        else if (!Uri.parse(state.link).isAbsolute)
                          {
                            snackBar = createSnackbar(
                              context,
                              l10n.validLinkValidationMessage,
                              true,
                            ),
                            ScaffoldMessenger.of(context).showSnackBar(snackBar)
                          }
                        else
                          {
                            context.read<EditLinkBloc>().add(
                                  const EditLinkSubmitted(),
                                ),
                          }
                      },
              child: status.isLoadingOrSuccess
                  ? const CupertinoActivityIndicator()
                  : const Icon(Icons.save),
            );
          },
        ),
        body: CupertinoScrollbar(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: _TitleField(),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: _UrlField(),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.all(16.0),
                  //   child: _AddFolder(),
                  // )
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: _AddFolders(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<EditLinkBloc>().state;
    final hintText = state.initialLink?.title ?? '';

    return TextFormField(
      key: const Key('editLinkView_title_textFormField'),
      initialValue: state.title,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editLinkTitleLabel,
        hintText: hintText,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: new BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? LinkSaverLighTheme().color
                  : LinkSaverDarkTheme().color,
              width: 1.3),
        ),
        prefixIcon: Icon(Icons.category),
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        context.read<EditLinkBloc>().add(EditLinkTitleChanged(value));
      },
    );
  }
}

class _UrlField extends StatelessWidget {
  const _UrlField();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final state = context.watch<EditLinkBloc>().state;
    final hintText = state.initialLink?.link ?? '';

    return TextFormField(
      key: const Key('editLinkView_link_textFormField'),
      initialValue: state.link,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: l10n.editLinkLinkLabel,
        hintText: hintText,
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: new BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? LinkSaverLighTheme().color
                  : LinkSaverDarkTheme().color,
              width: 1.3),
        ),
        prefixIcon: Icon(Icons.link),
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditLinkBloc>().add(EditLinkLinkChanged(value));
      },
    );
  }
}

class _PrivateField extends StatefulWidget {
  const _PrivateField({super.key});

  @override
  State<_PrivateField> createState() => _PrivateFieldState();
}

class _PrivateFieldState extends State<_PrivateField> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditLinkBloc>().state;

    return SwitchListTile(
      key: const Key('editLinkView_isPrivate_field'),
      title: Text('Add to Folders'),
      // This bool value toggles the switch.
      value: state.isPrivate == 1,
      activeColor: LinkSaverTheme.primary,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        int _value = value ? 1 : 0;
        context.read<EditLinkBloc>().add(EditLinkIsPrivateChanged(_value));
      },
    );
  }
}

class _AddFolders extends StatefulWidget {
  const _AddFolders({super.key});

  @override
  State<_AddFolders> createState() => _AddFoldersState();
}

class _AddFoldersState extends State<_AddFolders> {
  List<int> _selectedItems = [];

  void _itemChange(Collection itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue.id ?? 0);
      } else {
        _selectedItems.remove(itemValue.id);
      }
    });
    context
        .read<EditLinkBloc>()
        .add(EditLinkIsCollectionsChanged(_selectedItems));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditLinkBloc>().state;
    final editLinkBloc = context.read<EditLinkBloc>();
    _selectedItems = state.ownCollections;
    final ScrollController _scrollController = ScrollController();
    final l10n = context.l10n;

    return Column(
      children: [
        // const Divider(
        //   height: 30,
        // ),
        // display selected items
        Row(
          children: [
            const Text(
              'Add this link into folder(s) below:',
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlocProvider.value(
                      value: editLinkBloc,
                      child: AddCollectionDialog(),
                    );
                  },
                );
              },
              child: const Text('Add new folder'),
            ),
          ],
        ),
        Column(
          children: <Widget>[
            Divider(),
            state.collections.length != 0
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                        color: Theme.of(context).brightness == Brightness.light
                            ? LinkSaverLighTheme().color
                            : LinkSaverDarkTheme().color,
                      ),
                    ),
                    child: SizedBox(
                      height:
                          200, // (250 - 50) where 50 units for other widgets
                      child: Scrollbar(
                        thumbVisibility: true,
                        thickness: 10,
                        controller: _scrollController,
                        scrollbarOrientation: ScrollbarOrientation
                            .right, //which side to show scrollbar

                        child: ListView.builder(
                          controller: _scrollController,
                          shrinkWrap: true,
                          itemCount: state.collections.length,
                          itemBuilder: (BuildContext context, int index) {
                            return CheckboxListTile(
                              value: _selectedItems
                                  .contains(state.collections[index].id),
                              title: Text(state.collections[index].name),
                              controlAffinity: ListTileControlAffinity.trailing,
                              onChanged: (isChecked) => _itemChange(
                                  state.collections[index], isChecked!),
                            );
                          },
                        ),
                      ),
                    ))
                : Center(
                    child: Text(
                      l10n.emptyCollectionInEditLink,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
          ],
        ),
      ],
    );
  }
}

class AddCollectionDialog extends StatefulWidget {
  const AddCollectionDialog();

  @override
  State<AddCollectionDialog> createState() => _AddCollectionDialogState();
}

class _AddCollectionDialogState extends State<AddCollectionDialog> {
  @override
  Widget build(BuildContext context) {
    final status = context.select((EditLinkBloc bloc) => bloc.state.status);

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
                    .read<EditLinkBloc>()
                    .add(EditLinkCollectionNameChanged(value));
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.read<EditLinkBloc>().add(EditLinkAddCollection());
          },
          child: status.isLoadingOrSuccess
              ? const CupertinoActivityIndicator()
              : const Text('Add'),
        ),
      ],
    );
  }
}
