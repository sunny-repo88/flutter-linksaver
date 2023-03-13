import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_saver/app/app.dart';
import 'package:link_saver/collection/add_collection/bloc/collection_bloc.dart';
import 'package:link_saver/collection/collection_details/bloc/collection_details_bloc.dart';
import 'package:link_saver/collection/collection_details/widgets/collection_details_action_dialog.dart';
import 'package:link_saver/collection/collection_details/widgets/link_action_dialog.dart';
import 'package:link_saver/edit_link/view/edit_link_page.dart';
import 'package:link_saver/helpers/AdHelper.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/links_overview/links_overview.dart';
import 'package:link_saver/links_overview/widgets/link_list_tile.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:links_api/links_api.dart';
import 'package:links_repository/links_repository.dart';

class CollectionDetailsPage extends StatelessWidget {
  const CollectionDetailsPage({required this.collection});

  final Collection collection;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CollectionDetailsBloc(
        linksRepository: context.read<LinksRepository>(),
        collection: collection,
      )..add(const CollectionDetailsSubscriptionRequested()),
      child: const CollectionDetailsView(),
    );
  }
}

class CollectionDetailsView extends StatefulWidget {
  const CollectionDetailsView({super.key});

  @override
  State<CollectionDetailsView> createState() => _CollectionDetailsViewState();
}

class _CollectionDetailsViewState extends State<CollectionDetailsView> {
  BannerAd? _bannerAd;

  final String _adUnitId =
      AdHelper.getAdmobAdId(adsName: Ads.bannerAdCollectionDetailsId);

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadAd() async {
    BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final collectionDetailsBloc = context.read<CollectionDetailsBloc>();
    final status =
        context.select((CollectionDetailsBloc bloc) => bloc.state.status);

    return BlocListener<CollectionDetailsBloc, CollectionDetailsState>(
      listener: (context, state) {
        if (state.status == CollectionDetailsStatus.loadFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(
                  context, l10n.loadFolderDetailsErrorSnackbarText, true),
            );
        }
        if (state.status == CollectionDetailsStatus.deleteFolderFailure) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(context, l10n.deleteFolderErrorSnackbarText, true),
            );
        }
        if (state.status == CollectionDetailsStatus.editLinkFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(
                  context, l10n.editFolderDetailsErrorSnackbarText, true),
            );
        }
        if (state.status == CollectionDetailsStatus.editTitleFailure) {
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(
                  context, l10n.editFolderDetailsErrorSnackbarText, true),
            );
        }
        if (state.status == CollectionDetailsStatus.deleteLinkFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(context, l10n.deleteLinkErrorSnackbarText, true),
            );
        }
        if (state.status == CollectionDetailsStatus.deleteFolderSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(
                context,
                l10n.deleteFolderSuccessSnackbarText,
                false,
              ),
            );
        }
        if (state.status == CollectionDetailsStatus.editLinkSuccess) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(
                context,
                l10n.changesSavedSnackbarText,
                false,
              ),
            );
        }
        if (state.status == CollectionDetailsStatus.editTitleSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(
                context,
                l10n.changesSavedSnackbarText,
                false,
              ),
            );
        }
        if (state.status == CollectionDetailsStatus.deleteLinkSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              createSnackbar(
                context,
                l10n.changesSavedSnackbarText,
                false,
              ),
            );
          context.read<CollectionDetailsBloc>().add(
                CollectionDetailsSubscriptionRequested(),
              );
        }
      },
      child: BlocBuilder<CollectionDetailsBloc, CollectionDetailsState>(
        builder: (context, state) {
          return Scaffold(
            floatingActionButton: !state.editMode
                ? FloatingActionButton(
                    child: Icon(Icons.edit),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BlocProvider.value(
                            value: collectionDetailsBloc,
                            child: CollectionDetailActionDialog(),
                          );
                        },
                      );
                    },
                  )
                : null,
            appBar: AppBar(
              title: Text(state.collection?.name ?? "Folder Details"),
              actions: [],
            ),
            body: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  final l10n = context.l10n;

                  if (state.editMode) {
                    return MultiSelect(
                        items: state.allLinks, checkedItems: state.links);
                  } else {
                    return Column(
                      children: [
                        if (_bannerAd != null)
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SafeArea(
                              child: SizedBox(
                                width: _bannerAd!.size.width.toDouble(),
                                height: _bannerAd!.size.height.toDouble(),
                                child: AdWidget(ad: _bannerAd!),
                              ),
                            ),
                          ),
                        ListTile(
                          title: TextField(
                            key: const Key(
                                'collection_details_edit_mode_page_search_TextField'),
                            decoration: InputDecoration(
                              hintText: '   Search by title ...',
                              hintStyle: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? LinkSaverLighTheme().color
                                    : LinkSaverDarkTheme().color,
                                fontSize: 18,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? LinkSaverLighTheme().color
                                  : LinkSaverDarkTheme().color,
                            ),
                            enableSuggestions: false,
                            autocorrect: false,
                            onChanged: (value) {
                              setState(() {
                                collectionDetailsBloc.add(
                                    CollectionDetailsFilterByTitleChanged(
                                        value));
                              });
                            },
                          ),
                        ),
                        StreamBuilder(
                          stream: null,
                          builder: (context, snapshot) {
                            if (state.filteredLinks.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 58.0),
                                  child: Text(
                                    state.filterTitle.isEmpty
                                        ? l10n.collectionEmptyLinkText
                                        : l10n.linksOverviewEmptyWithFilterText,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ),
                              );
                            }

                            return Expanded(
                              child: CupertinoScrollbar(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 20.0, left: 32, right: 32),
                                        child: Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          runAlignment:
                                              WrapAlignment.spaceBetween,
                                          spacing: 20,
                                          runSpacing: 20.0,
                                          children: [
                                            for (final link
                                                in state.filteredLinks) ...[
                                              LinkListTile(
                                                link: link,
                                                onTap: () {
                                                  showDialog<void>(
                                                    context: context,
                                                    builder:
                                                        (BuildContext modal) {
                                                      return BlocProvider.value(
                                                        value: BlocProvider.of<
                                                                CollectionDetailsBloc>(
                                                            context),
                                                        child: LinkActionDialog(
                                                          link: link,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  }
                }),
            bottomNavigationBar: StreamBuilder<Object>(
                stream: null,
                builder: (context, snapshot) {
                  if (state.editMode) {
                    return BottomAppBar(
                      // decoration: BoxDecoration(
                      //     // border: Border.all(color: Colors.black, width: 1),
                      //     ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, //Center Row contents horizontally,
                        children: [
                          TextButton(
                            onPressed: () {
                              collectionDetailsBloc
                                  .add(CollectionDetailsEditModeChanged(false));
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? LinkSaverLighTheme().color
                                    : LinkSaverDarkTheme().color,
                              ),
                            ),
                          ),
                          SizedBox(width: 50), // give it width

                          ElevatedButton(
                            onPressed: () {
                              collectionDetailsBloc.add(
                                CollectionDetailsAddLinksSubmitted(),
                              );
                              collectionDetailsBloc
                                  .add(CollectionDetailsEditModeChanged(false));
                            },
                            child: status.isLoadingOrSuccess
                                ? const CupertinoActivityIndicator()
                                : const Text('Save'),
                          ),
                        ],
                      ),
                    );
                  }
                  return Container(
                    height: 1,
                  );
                }),
          );
        },
      ),
    );
  }
}

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<Link> items;
  final List<Link> checkedItems;

  const MultiSelect({Key? key, required this.items, required this.checkedItems})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  // this variable holds the selected items
  late List<Link> _selectedItems = [];
  late List<Link> _items = [];
  late List<Link> _filteredItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(Link itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  void initState() {
    _selectedItems = widget.checkedItems;
    _items = widget.items;
    _filteredItems = _items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: TextField(
              key: const Key(
                  'collection_details_edit_mode_page_search_TextField'),
              decoration: InputDecoration(
                hintText: '   Search by title ...',
                hintStyle: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
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
                setState(
                  () {
                    if (value == "" || value == null) {
                      _filteredItems = _items;
                    } else {
                      _filteredItems =
                          _items.where((x) => x.title.contains(value)).toList();
                    }
                  },
                );
              },
            ),
          ),
          StreamBuilder<Object>(
            stream: null,
            builder: (context, snapshot) {
              final l10n = context.l10n;

              if (_filteredItems.isEmpty) {
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

              return Expanded(
                child: SingleChildScrollView(
                  child: ListBody(
                    children: [
                      ..._filteredItems
                          .map((item) => CheckboxListTile(
                                value: _selectedItems.contains(item),
                                title: Text(item.title),
                                subtitle: Text(item.link),
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                onChanged: (isChecked) =>
                                    _itemChange(item, isChecked!),
                              ))
                          .toList()
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
