import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_saver/l10n/l10n.dart';
import 'package:link_saver/links_overview/bloc/links_overview_bloc.dart';
import 'package:link_saver/theme/theme.dart';
import 'package:link_saver/widgets/snackbar.dart';
import 'package:links_api/links_api.dart';

class LinksOverviewFilterDialog extends StatefulWidget {
  const LinksOverviewFilterDialog({super.key});

  @override
  State<LinksOverviewFilterDialog> createState() =>
      _LinksOverviewFilterDialogState();
}

class _LinksOverviewFilterDialogState extends State<LinksOverviewFilterDialog> {
  @override
  Widget build(BuildContext context) {
    int sort =
        context.select((LinksOverviewBloc bloc) => bloc.state.sort).index;
    final l10n = context.l10n;
    return BlocListener<LinksOverviewBloc, LinksOverviewState>(
      listener: (context, state) {
        if (state.status == LinksOverviewStatus.success) {
          Navigator.pop(context);
        }
        if (state.status == LinksOverviewStatus.failure) {
          SnackBar snackbar = createSnackbar(
            context,
            l10n.linksOverviewErrorSnackbarText,
            true,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
        }
      },
      child: AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          title: Text(
            'Sort By',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? LinkSaverLighTheme().color
                  : LinkSaverDarkTheme().color,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile(
                title: Text("Latest"),
                value: LinksViewsSort.byNewest.index,
                groupValue: sort,
                onChanged: (value) {
                  setState(() {
                    context
                        .read<LinksOverviewBloc>()
                        .add(LinksOverviewSortChanged(LinksViewsSort.byNewest));
                  });
                },
              ),
              RadioListTile(
                title: Text("Title"),
                value: LinksViewsSort.byTitle.index,
                groupValue: sort,
                onChanged: (value) {
                  context
                      .read<LinksOverviewBloc>()
                      .add(LinksOverviewSortChanged(LinksViewsSort.byTitle));
                },
              ),
            ],
          )),
    );
  }
}
