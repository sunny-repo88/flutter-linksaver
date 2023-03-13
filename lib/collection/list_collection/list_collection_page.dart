import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:link_saver/collection/add_collection/add_collection_page.dart';
import 'package:link_saver/collection/collection_details/collection_details_page.dart';
import 'package:link_saver/collection/list_collection/bloc/list_collection_bloc.dart';
import 'package:link_saver/helpers/AdHelper.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:links_repository/links_repository.dart';

class ListCollectionPage extends StatelessWidget {
  const ListCollectionPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ListCollectionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListCollectionBloc(
        linksRepository: context.read<LinksRepository>(),
      )..add(const CollectionsOverviewSubscriptionRequested()),
      child: const ListCollectionsView(),
    );
  }
}

class ListCollectionsView extends StatefulWidget {
  const ListCollectionsView({
    Key? key,
  }) : super(key: key);

  @override
  State<ListCollectionsView> createState() => _ListCollectionsViewState();
}

class _ListCollectionsViewState extends State<ListCollectionsView> {
  BannerAd? _bannerAd;

  final String _adUnitId =
      AdHelper.getAdmobAdId(adsName: Ads.bannerAdListCollectionId);

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

    return BlocBuilder<ListCollectionBloc, ListCollectionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Folders"),
          ),
          floatingActionButton: ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => AddCollectionPage(),
                    ),
                  )
                  .then((value) => {
                        if (value == true)
                          {
                            context.read<ListCollectionBloc>().add(
                                  const ListCollectionSubmitted(),
                                ),
                          }
                      });
            },
            icon: Icon(Icons.add), //icon data for elevated button
            label: Text('New Folder'),
          ),
          body: BlocListener<ListCollectionBloc, ListCollectionState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == ListCollectionStatus.failure) {
                SnackBar snackbar = createSnackbar(
                    context, l10n.linksOverviewErrorSnackbarText, true);
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
            },
            child: CupertinoScrollbar(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    StreamBuilder<Object>(
                      stream: null,
                      builder: (context, snapshot) {
                        final l10n = context.l10n;
                        if (state.filteredCollections.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 188.0),
                              child: Text(
                                l10n.emptyCollection,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                          child: Center(
                            child: Wrap(
                              // alignment: WrapAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              runAlignment: WrapAlignment.spaceBetween,
                              spacing: 20,
                              runSpacing: 20.0,

                              children: [
                                for (final collection
                                    in state.filteredCollections) ...[
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CollectionDetailsPage(
                                                collection: collection,
                                              ),
                                            ),
                                          )
                                          .then(
                                            (value) => {
                                              context
                                                  .read<ListCollectionBloc>()
                                                  .add(
                                                    const ListCollectionSubmitted(),
                                                  ),
                                            },
                                          );
                                    },
                                    child: Container(
                                      width: 150,
                                      height: 140,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 28.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            const Image(
                                              image: AssetImage(
                                                  'assets/folder.png'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 16.0, left: 8, right: 8),
                                              child: Text(
                                                collection.name +
                                                    ' (${collection.links?.length})',
                                                overflow: TextOverflow.ellipsis,
                                                style: new TextStyle(
                                                  fontSize: 13.0,
                                                  fontFamily: 'Roboto',
                                                  color: Theme.of(context)
                                                              .brightness ==
                                                          Brightness.light
                                                      ? LinkSaverLighTheme()
                                                          .color
                                                      : LinkSaverDarkTheme()
                                                          .color,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        // color: Color(0xFFF7F9FC),
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? LinkSaverLighTheme()
                                                .boxDecorationColor
                                            : LinkSaverDarkTheme()
                                                .boxDecorationColor,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
