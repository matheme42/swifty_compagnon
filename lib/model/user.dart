import 'package:swifty_compagnon/model/cursus_users.dart';
import 'package:swifty_compagnon/model/model.dart';
import 'package:swifty_compagnon/model/models.dart';

class User extends Model {
  String email = "";

  String login = "";

  String firstName = "";

  String lastName = "";

  String url = "";

  String phone = "";

  String displayName = "";

  String imageUrl = "";

  bool staff = false;

  int correctionPoint = 0;

  String poolMonth = "";

  String poolYear = "";

  int wallet = 0;

  String anonymizeDate = "";

  Map<int, CursusUser> cursusUser = {};

  @override
  void fromMap(Map<String, dynamic> data) {
    if (data.containsKey('email')) email = data['email'].toString();
    if (data.containsKey('login')) login = data['login'].toString();
    if (data.containsKey('first_name'))
      firstName = data['first_name'].toString();
    if (data.containsKey('last_name')) lastName = data['last_name'].toString();
    if (data.containsKey('phone')) phone = data['phone'].toString();
    if (data.containsKey('displayname'))
      displayName = data['displayname'].toString();
    if (data.containsKey('image_url')) imageUrl = data['image_url'].toString();
    if (data.containsKey('staff') && data['staff'] != null) staff = data['staff'];
    if (data.containsKey('correction_point'))
      correctionPoint = int.tryParse(data['correction_point'].toString())!;
    if (data.containsKey('pool_month'))
      poolMonth = data['pool_month'].toString();
    if (data.containsKey('pool_year')) poolYear = data['pool_year'].toString();
    if (data.containsKey('wallet'))
      wallet = int.tryParse(data['wallet'].toString())!;
    if (data.containsKey('anonymize_date'))
      anonymizeDate = data['anonymize_date'].toString();

    if (data.containsKey("cursus_users")) {
      List<dynamic> cursusUserDataList = [];

      cursusUserDataList = data["cursus_users"];
      cursusUserDataList.forEach((cursusUserData) {
        CursusUser localCursusUser;
        localCursusUser = CursusUser()..fromMap(cursusUserData);
        cursusUser[localCursusUser.id] = localCursusUser;
      });
    }

    try {
      if (data.containsKey("projects_users")) {
        List projectUserDataList = data["projects_users"];
        projectUserDataList.forEach((projectUserData) {
          Project project = Project()..fromMap(projectUserData);
          CursusUser? localCursusUser = cursusUser[project.cursusId];
          if (localCursusUser != null) localCursusUser.projects.add(project);
        });
      }
    } catch (e) {
      print(e);
    }

    super.fromMap(data);
  }

  @override
  Map<String, dynamic> asMap() {
    Map<String, dynamic> message = {};
    message['url'] = url;
    message['login'] = login;
    message.addAll(super.asMap());
    return message;
  }
}
