import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:think/Features/Home/bloc/tab_bloc.dart';
import 'package:think/Features/Home/feed/feed_tab.dart';
import 'package:think/Features/Home/characters/characters_tab.dart';
import 'package:think/Features/Profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = 'home';
  final List<Widget> tabs = [CharactersTab(), FeedTab()];

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TabBloc(),
      child: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/images/background.png"))),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.white,
                    ));
              },
            ),
          ),
          backgroundColor: Colors.transparent,
          drawer: Drawer(
            backgroundColor: Colors.white,
            child: Column(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text(
                    "Profile",
                    style: TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, ProfileScreen.routeName);
                  },
                ),
                // const ListTile(
                //   leading: Icon(Icons.logout),
                //   title: Text("Log Out"),
                // )
              ],
            ),
          ),
          body: BlocBuilder<TabBloc, TabState>(
            builder: (context, state) {
              if (state.status == TabStatus.changed) {
                return tabs[state.index];
              }
              return CharactersTab();
            },
          ),
          bottomNavigationBar: BlocBuilder<TabBloc, TabState>(
            builder: (context, state) {
              int currentIndex = 0;
              if (state.status == TabStatus.changed) {
                currentIndex = state.index;
              }
              return BottomNavigationBar(
                backgroundColor: Theme.of(context).primaryColor,
                currentIndex: currentIndex,
                onTap: (value) {
                  currentIndex = value;
                  context.read<TabBloc>().add(ChangeTab(value));
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.feed), label: "Feed")
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
