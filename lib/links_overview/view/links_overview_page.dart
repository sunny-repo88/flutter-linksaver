import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_saver/collection/list_collection/list_collection_page.dart';
import 'package:link_saver/edit_link/view/edit_link_page.dart';
import 'package:link_saver/home/home.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/links_overview/links_overview.dart';
import 'package:link_saver/links_overview/widgets/link_overview_filter.dart';
import 'package:link_saver/links_overview/widgets/link_action_dialog.dart';
import 'package:link_saver/settings/view/settings_page.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:links_repository/links_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';

class LinksOverviewPage extends StatelessWidget {
  const LinksOverviewPage({super.key});

  static Route<void> route({Link? initialLink}) {
    return MaterialPageRoute(
      builder: (context) => const LinksOverviewPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LinksOverviewBloc(
        linksRepository: context.read<LinksRepository>(),
      )..add(const LinksOverviewSubscriptionRequested()),
      child: const LinksOverviewView(),
    );
  }
}

class LinksOverviewView extends StatefulWidget {
  const LinksOverviewView({super.key});

  @override
  State<LinksOverviewView> createState() => _LinksOverviewViewState();
}

class _LinksOverviewViewState extends State<LinksOverviewView> {
  Icon customIcon = const Icon(
    Icons.search,
    key: Key('links_overview_page_search_icon'),
  );
  Widget customSearchBar = const Text('Link Saver');
  bool inFilterMode = false;

  final String _adUnitId = 'ca-app-pub-3940256099942544/6300978111';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select((HomeCubit cubit) => cubit.state.tab);

    final l10n = context.l10n;
    final collections =
        context.select((LinksOverviewBloc bloc) => bloc.state.collections);
    final linksOverviewBloc = context.read<LinksOverviewBloc>();

    late FocusNode myFocusNode;
    myFocusNode = FocusNode();

    return BlocBuilder<LinksOverviewBloc, LinksOverviewState>(
      builder: (context, state) {
        return Scaffold(
          // floatingActionButtonLocation:
          // FloatingActionButtonLocation.centerDocked,

          appBar: AppBar(
            title: customSearchBar,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (customIcon.icon == Icons.search) {
                      inFilterMode = true;
                      customIcon = const Icon(
                        Icons.cancel,
                        key: Key('links_overview_page_search_cancel_icon'),
                      );
                      customSearchBar = ListTile(
                        title: TextField(
                          key:
                              const Key('links_overview_page_search_TextField'),
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
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? LinkSaverLighTheme().color
                                    : LinkSaverDarkTheme().color,
                          ),
                          focusNode: myFocusNode,
                          enableSuggestions: false,
                          autocorrect: false,
                          onChanged: (value) {
                            context
                                .read<LinksOverviewBloc>()
                                .add(LinksOverviewFilterByTitleChanged(value));
                          },
                        ),
                      );
                      myFocusNode.requestFocus();
                    } else {
                      inFilterMode = false;

                      customIcon = const Icon(
                        Icons.search,
                        key: Key('links_overview_page_search_icon'),
                      );
                      customSearchBar = const Text('Link Saver');
                      context
                          .read<LinksOverviewBloc>()
                          .add(LinksOverviewFilterByTitleChanged(""));
                    }
                  });
                },
                icon: customIcon,
              ),
              inFilterMode == false
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BlocProvider.value(
                              value: linksOverviewBloc,
                              child: LinksOverviewFilterDialog(),
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.sort))
                  : Container(),

              // const LinksOverviewFilterDialog(),
              // const LinksOverviewOptionsButton(),
            ],
          ),
          body: Scaffold(
            floatingActionButton: FloatingActionButton(
              key: const Key('homeView_addLink_floatingActionButton'),
              onPressed: () => {
                Navigator.of(context).push(EditLinkPage.route()).then((a) => {
                      context
                          .read<LinksOverviewBloc>()
                          .add(LinksOverviewSubscriptionRequested())
                    }),
              },
              child: const Icon(Icons.add),
            ),
            body: MultiBlocListener(
              listeners: [
                BlocListener<LinksOverviewBloc, LinksOverviewState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status,
                  listener: (context, state) {
                    if (state.status == LinksOverviewStatus.failure) {
                      SnackBar snackbar = createSnackbar(
                        context,
                        l10n.linksOverviewErrorSnackbarText,
                        true,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackbar);
                    }
                  },
                ),
                BlocListener<LinksOverviewBloc, LinksOverviewState>(
                  listenWhen: (previous, current) =>
                      previous.lastDeletedLink != current.lastDeletedLink &&
                      current.lastDeletedLink != null,
                  listener: (context, state) {
                    final deletedLink = state.lastDeletedLink!;
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        createSnackbar(
                            context,
                            l10n.linksOverviewLinkDeletedSnackbarText(
                              deletedLink.title,
                            ),
                            false),
                      );
                  },
                ),
              ],
              child: BlocBuilder<LinksOverviewBloc, LinksOverviewState>(
                builder: (context, state) {
                  if (state.filteredLinks.isEmpty) {
                    if (state.status == LinksOverviewStatus.loading) {
                      return const Center(child: CupertinoActivityIndicator());
                    } else if (state.status != LinksOverviewStatus.success) {
                      return const SizedBox();
                    } else {
                      if (state.title!.isNotEmpty) {
                        return Center(
                          child: Text(
                            l10n.linksOverviewEmptyWithFilterText,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            'Add a new link by pressing \' + \' button',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        );
                      }
                    }
                  }
                  List<Link> links = state.filteredLinks.toList();
                  return CupertinoScrollbar(
                    child: ListView(
                      children: [
                        for (var i = 0; i < links.length; i++) ...[
                          LinkListTile(
                            link: links[i],
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext modal) {
                                  return BlocProvider.value(
                                    value: BlocProvider.of<LinksOverviewBloc>(
                                        context),
                                    child: LinkActionDialog(
                                      link: links[i],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _HomeTabButton(
                  groupValue: selectedTab,
                  value: HomeTab.category,
                  icon: const Icon(Icons.folder_outlined),
                ),
                _HomeTabButton(
                  groupValue: selectedTab,
                  value: HomeTab.links,
                  icon: const Icon(Icons.list_outlined),
                ),
                _HomeTabButton(
                  groupValue: selectedTab,
                  value: HomeTab.settings,
                  icon: const Icon(Icons.settings_outlined),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HomeTabButton extends StatefulWidget {
  const _HomeTabButton({
    required this.groupValue,
    required this.value,
    required this.icon,
  });

  final HomeTab groupValue;
  final HomeTab value;
  final Widget icon;

  @override
  State<_HomeTabButton> createState() => _HomeTabButtonState();
}

class _HomeTabButtonState extends State<_HomeTabButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (widget.value.index == HomeTab.settings.index) {
          Navigator.of(context).push(SettingsPage.route());
        } else if (widget.value.index == HomeTab.category.index) {
          Navigator.of(context).push(ListCollectionPage.route()).then((_) => {
                context.read<LinksOverviewBloc>().add(
                      LinksOverviewSubscriptionRequested(),
                    ),
              });
        } else {
          context.read<HomeCubit>().setTab(widget.value);
        }
      },
      iconSize: 32,
      color: widget.groupValue != widget.value
          ? null
          : Theme.of(context).colorScheme.secondary,
      icon: widget.icon,
    );
  }
}
