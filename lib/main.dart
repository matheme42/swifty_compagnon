import 'dart:async';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:root/root.dart';
import 'package:swifty_compagnon/backend.dart';
import 'package:swifty_compagnon/configure.dart';
import 'package:swifty_compagnon/context.dart';
import 'package:swifty_compagnon/get_access_token.dart';
import 'model/models.dart';

void main() {
  Logger.root.onRecord.listen((event) {
    print("${event.level} ${event.message}");
  });
  runApp(Root(
    onLoading: configure,
    onLoadingScreen: OnLoadingScreen(),
    title: "swifty_compagnon",
    homeScreen: App(),
    appContext: SwiftyCompagnonContext(),
  ));
}

class OnLoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/triangle_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: CircularProgressIndicator()));
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  late final TextEditingController textController = TextEditingController();
  late final Timer timer;
  String search = "";

  void function(_) {
    if (search != textController.text) {
      search = textController.text;
      setState(() {});
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 2), function);
    textController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetAccessToken(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/triangle_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 1,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  child: AnimSearchBar(
                      width: MediaQuery.of(context).size.width * 0.98,
                      textController: textController,
                      helpText: "",
                      autoFocus: true,
                      color: Colors.white70,
                      onSuffixTap: () {
                        textController.clear();
                      }),
                ),
                Flexible(
                  flex: 9,
                  child: FutureBuilder<List>(
                      future: SwiftyCompagnonBackend()
                          .getUsersInfo(textController.text.trim()),
                      builder: (context, state) {
                        if (state.connectionState == ConnectionState.done) {
                          return ListUser(users: state.data!.cast<User>());
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListUser extends StatelessWidget {
  final List<User> users;
  final AutoSizeGroup group = AutoSizeGroup();

  ListUser({required this.users});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return MaterialButton(
            onPressed: () {
              SwiftyCompagnonContext.ofRootContext.currentUser = users[index];
            },
            child: Card(
              color: Colors.white38,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  height: 40,
                  child: Center(
                    child: AutoSizeText(
                      users[index].login,
                      group: group,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
