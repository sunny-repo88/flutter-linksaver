import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:link_saver/collection/list_collection/list_collection_page.dart';
import 'package:link_saver/edit_link/edit_link.dart';
import 'package:link_saver/home/home.dart';
import 'package:link_saver/links_overview/links_overview.dart';
import 'package:link_saver/settings/settings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LinksOverviewPage();
  }
}
