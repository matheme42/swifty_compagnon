import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_charts/multi_charts.dart';
import 'package:page_view_indicators/page_view_indicators.dart';
import 'package:shimmer/shimmer.dart';
import 'package:swifty_compagnon/backend.dart';
import 'package:swifty_compagnon/context.dart';
import 'package:swifty_compagnon/get_access_token.dart';
import 'package:swifty_compagnon/model/cursus_users.dart';
import 'package:swifty_compagnon/model/models.dart';

import 'model/user.dart';

class UserInfo extends StatelessWidget {
  final controller = PageController(initialPage: 0);
  final ValueNotifier<int> currentPage = ValueNotifier<int>(0);

  void function() {
    currentPage.value = controller.page!.toInt();
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(function);
    return WillPopScope(onWillPop: () async {
      SwiftyCompagnonContext.ofRootContext.currentUser = null;
      return false;
    }, child: GetAccessToken(
      child: Builder(builder: (context) {
        return FutureBuilder(
            future: SwiftyCompagnonBackend().getUserInfo(),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/triangle_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Shimmer.fromColors(
                    highlightColor: Colors.white70,
                    baseColor: Colors.black12,
                    child: FractionallySizedBox(
                        heightFactor: 1,
                        widthFactor: 1,
                        child: Center(child: CircularProgressIndicator())),
                  ),
                );
              }
              User user = SwiftyCompagnonContext.ofRootContext.currentUser;
              List<Widget> list = [];
              user.cursusUser.forEach((_, cursusUser) {
                list.add(CursusInfo(info: cursusUser));
              });
              list.reversed;
              list.insert(0, UserInfoFirstTile());
              return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/triangle_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: FractionallySizedBox(
                      heightFactor: 1,
                      widthFactor: 1,
                      child: Column(
                        children: [
                          Flexible(
                            flex: 4,
                            child: UserGlobalInfo(
                              currentPage: currentPage,
                              indicatorLength: list.length,
                            ),
                          ),
                          Flexible(
                            flex: 10,
                            child: PageView(
                                controller: controller,
                                pageSnapping: true,
                                children: list),
                          )
                        ],
                      )));
            });
      }),
    ));
  }
}

class CursusInfo extends StatelessWidget {
  final CursusUser info;
  final ValueNotifier<bool> updater = ValueNotifier<bool>(false);

  CursusInfo({required this.info});

  @override
  Widget build(BuildContext context) {
    List<String> features = [];
    List<double> data = [];
    features.clear();
    data.clear();

    info.skills.forEach((skill) {
      features.add(skill.name);
      data.add(skill.level);
    });

    AutoSizeGroup autoSizeGroup = AutoSizeGroup();

    return ValueListenableBuilder<bool>(
        valueListenable: updater,
        builder: (context, value, _) {
          return Padding(
            padding: EdgeInsets.all(0),
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              reverseDuration: Duration(milliseconds: 500),
              child: updater.value == false
                  ? ListView(
                      children: [
                        Center(
                          child: AutoSizeText(
                            info.name,
                            maxLines: 1,
                            minFontSize: 1,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                        Row(
                          children: [
                            Spacer(flex: 2),
                            Flexible(
                              flex: 13,
                              child: Column(
                                children: [
                                  ListTile(
                                    title: AutoSizeText(
                                      "level",
                                      maxLines: 1,
                                      minFontSize: 1,
                                      group: autoSizeGroup,
                                      style: TextStyle(color: Colors.white30),
                                    ),
                                    subtitle: AutoSizeText(
                                      info.level.toString(),
                                      maxLines: 1,
                                      minFontSize: 1,
                                      group: autoSizeGroup,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    leading: Icon(
                                      Icons.stacked_bar_chart,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  ListTile(
                                    title: AutoSizeText(
                                      "grade",
                                      maxLines: 1,
                                      minFontSize: 1,
                                      group: autoSizeGroup,
                                      style: TextStyle(color: Colors.white30),
                                    ),
                                    subtitle: AutoSizeText(
                                      info.grade != "null" ? info.grade : "",
                                      maxLines: 1,
                                      minFontSize: 1,
                                      group: autoSizeGroup,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    leading: Icon(
                                      Icons.grade_outlined,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  ListTile(
                                    title: AutoSizeText(
                                      "blackhole",
                                      maxLines: 1,
                                      minFontSize: 1,
                                      group: autoSizeGroup,
                                      style: TextStyle(color: Colors.white30),
                                    ),
                                    subtitle: AutoSizeText(
                                      info.blackHoled != "null"
                                          ? DateFormat.yMd().format(
                                              DateTime.parse(
                                                  info.blackHoled!.toString()))
                                          : "no",
                                      maxLines: 1,
                                      minFontSize: 1,
                                      group: autoSizeGroup,
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    leading: Icon(
                                      Icons.hourglass_top_sharp,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Flexible(
                              flex: 13,
                              child: data.length >= 3
                                  ? MaterialButton(
                                      onPressed: () =>
                                          updater.value = !updater.value,
                                      child: RadarChart(
                                        values: data,
                                        labels: features,
                                        maxLinesForLabels: 2,
                                        labelColor: Colors.white70,
                                        maxValue: 15,
                                        fillColor: Colors.white70,
                                        chartRadiusFactor: 0.8,
                                      ),
                                    )
                                  : Container(),
                            ),
                            Spacer(flex: 2),
                          ],
                        ),
                        UserInfoProject(
                          projects: info.projects,
                        ),
                      ],
                    )
                  : Padding(
                      padding: EdgeInsets.all(8.0),
                      child: MaterialButton(
                        onPressed: () => updater.value = !updater.value,
                        child: RadarChart(
                          values: data,
                          labels: features,
                          maxLinesForLabels: 2,
                          labelColor: Colors.white70,
                          maxValue: 15,
                          fillColor: Colors.white70,
                          chartRadiusFactor: 0.6,
                        ),
                      ),
                    ),
            ),
          );
        });
  }
}

class UserInfoProject extends StatelessWidget {
  final List<Project> projects;
  final List<Widget> widgets = [];
  final AutoSizeGroup autoSizeGroup = AutoSizeGroup();

  UserInfoProject({required this.projects});

  @override
  Widget build(BuildContext context) {
    widgets.clear();

    projects.sort((a, b) {
      return a.name.trim().toLowerCase().compareTo(b.name.trim().toLowerCase());
    });

    widgets.add(Divider(color: Colors.white30));

    projects.forEach((project) {
      late Color color;

      if (project.status == "parent") return;

      if (project.status == "finished") {
        color = (project.validated == false) ? Colors.red : Colors.green;
      } else if (project.status == "in_progress")
        color = Colors.blueAccent;
      else if (project.status == "waiting_for_correction")
        color = Colors.blue;
      else
        color = Colors.blueAccent;

      widgets.add(Padding(
        padding: EdgeInsets.all(4.0),
        child: Container(
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: color, width: 1),
              color: color.withAlpha(100),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                Flexible(
                  flex: 4,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: AutoSizeText(
                      project.finalMark.toString() == "null"
                          ? "?"
                          : project.finalMark.toString(),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      minFontSize: 1,
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 20,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: AutoSizeText(
                      project.name.toLowerCase(),
                      group: autoSizeGroup,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      minFontSize: 1,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                Spacer(),
                Flexible(
                  flex: 5,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: AutoSizeText(
                      "${project.occurrence.toString()} retry",
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      minFontSize: 1,
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
                Spacer(),
              ],
            )),
      ));
    });
    return Column(children: widgets);
  }
}

class UserInfoFirstTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = SwiftyCompagnonContext.ofRootContext.currentUser;
    return ListView(
      children: [
        ListTile(
          leading: Icon(
            Icons.emoji_people,
            color: Colors.white70,
          ),
          title: AutoSizeText(
            "name",
            style: TextStyle(color: Colors.white30),
          ),
          subtitle: AutoSizeText(
            user.displayName,
            style: TextStyle(color: Colors.white70),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.email,
            color: Colors.white70,
          ),
          title: AutoSizeText(
            "email",
            style: TextStyle(color: Colors.white30),
          ),
          subtitle: AutoSizeText(
            user.email,
            style: TextStyle(color: Colors.white70),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.phone,
            color: Colors.white70,
          ),
          title: AutoSizeText(
            "phone",
            style: TextStyle(color: Colors.white30),
          ),
          subtitle: AutoSizeText(
            user.phone,
            style: TextStyle(color: Colors.white70),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.done,
            color: Colors.white70,
          ),
          title: AutoSizeText(
            "correction points",
            style: TextStyle(color: Colors.white30),
          ),
          subtitle: AutoSizeText(
            "${user.correctionPoint.toString()}",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.account_balance_wallet_outlined,
            color: Colors.white70,
          ),
          title: AutoSizeText(
            "Wallet",
            style: TextStyle(color: Colors.white30),
          ),
          subtitle: AutoSizeText(
            "${user.wallet.toString()} ₳",
            style: TextStyle(color: Colors.white70),
          ),
        ),
        ListTile(
          leading: Icon(
            Icons.date_range,
            color: Colors.white70,
          ),
          title: AutoSizeText(
            "anonymization date",
            style: TextStyle(color: Colors.white30),
          ),
          subtitle: AutoSizeText(
            user.anonymizeDate.toString() != ""
                ? DateFormat.yMd()
                    .format(DateTime.parse(user.anonymizeDate.toString()))
                : "",
            style: TextStyle(color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class UserGlobalInfo extends StatelessWidget {
  final ValueNotifier<int> currentPage;
  final int indicatorLength;

  UserGlobalInfo({required this.currentPage, required this.indicatorLength});

  @override
  Widget build(BuildContext context) {
    User user = SwiftyCompagnonContext.ofRootContext.currentUser;
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.white10),
          child: FractionallySizedBox(
            widthFactor: 1,
            heightFactor: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  flex: 600,
                  child: FractionallySizedBox(
                    heightFactor: 1,
                    widthFactor: 1,
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: user.imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 200.0,
                          height: 200.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  flex: 100,
                  child: Row(
                    children: [
                      Flexible(
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Container(),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: Center(
                            child: AutoSizeText(
                              user.login,
                              maxLines: 1,
                              minFontSize: 1,
                              textScaleFactor: 2,
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                          child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Center(
                          child: CirclePageIndicator(
                            itemCount: indicatorLength,
                            currentPageNotifier: currentPage,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
                Flexible(child: Divider(color: Colors.white70))
              ],
            ),
          ),
        ),
        Shimmer.fromColors(
          child: FractionallySizedBox(
            heightFactor: 1,
            widthFactor: 1,
            child: Container(
              color: Colors.white30,
            ),
          ),
          baseColor: Colors.black12,
          highlightColor: Colors.white30,
        ),
      ],
    );
  }
}
