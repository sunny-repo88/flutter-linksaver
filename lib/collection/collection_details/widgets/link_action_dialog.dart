import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:link_saver/collection/collection_details/bloc/collection_details_bloc.dart';
import 'package:link_saver/edit_link/edit_link.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/links_overview/links_overview.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:links_api/links_api.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

enum LinkActionDialogType {
  LinksOverview,
  CollectionDetails,
}

class LinkActionDialog extends StatefulWidget {
  const LinkActionDialog({
    super.key,
    required this.link,
  });

  final Link link;

  @override
  State<LinkActionDialog> createState() => _LinkActionDialogState();
}

class _LinkActionDialogState extends State<LinkActionDialog> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<CollectionDetailsBloc, CollectionDetailsState>(
      listener: (context, state) {},
      child: AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        // title: Text('Sort By'),
        content: CupertinoScrollbar(
            child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Edit'),
                leading: const Icon(Icons.edit),
                onTap: () => {
                  // Navigator.of(context).pop(),
                  Navigator.of(context)
                      .push(
                        EditLinkPage.route(
                          initialLink: widget.link,
                        ),
                      )
                      .then(
                        (a) => {
                          Navigator.pop(context),
                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(
                              createSnackbar(
                                context,
                                l10n.changesSavedSnackbarText,
                                false,
                              ),
                            ),
                          context.read<CollectionDetailsBloc>().add(
                                CollectionDetailsSubscriptionRequested(),
                              ),
                        },
                      ),
                },
              ),
              Divider(),
              ListTile(
                title: const Text('Share'),
                leading: const Icon(Icons.share),
                onTap: () async {
                  Share.share(widget.link.link);
                },
              ),
              Divider(),
              ListTile(
                title: const Text('Open'),
                leading: const Icon(Icons.open_in_browser),
                onTap: () async {
                  Uri url = Uri.parse(
                    widget.link.link,
                  );
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                },
              ),
              Divider(),
              ListTile(
                title: const Text('Copy'),
                leading: const Icon(Icons.content_copy),
                onTap: () async {
                  await Clipboard.setData(
                    ClipboardData(
                      text: widget.link.link,
                    ),
                  );
                  Fluttertoast.showToast(
                      msg: "Link copied",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Color.fromARGB(255, 234, 228, 228),
                      textColor: Colors.black,
                      fontSize: 16.0);
                  Navigator.of(context).pop();
                },
              ),
              // Divider(),
              // ListTile(
              //   title: const Text('Delete this link everywhere'),
              //   leading: const Icon(Icons.delete_forever),
              //   onTap: () => {
              //     context.read<CollectionDetailsBloc>().add(
              //           CollectionDetailsLinkDeleted(widget.link),
              //         ),
              //   },
              // ),
              Divider(),
              StreamBuilder(
                stream: null,
                builder: (context, snapshot) {
                  return ListTile(
                    title: const Text('Delete from this folder'),
                    leading: const Icon(Icons.delete),
                    onTap: () => {
                      context.read<CollectionDetailsBloc>().add(
                            CollectionDetailsDeleteLinkFromFolderSubmitted(
                                widget.link),
                          ),
                    },
                  );
                },
              ),
            ],
          ),
        )),
      ),
    );
  }
}
