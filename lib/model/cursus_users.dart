import 'package:swifty_compagnon/model/model.dart';
import 'package:swifty_compagnon/model/models.dart';

class Skill extends Model {

	String name = "";

	double level = 0.0;

	@override
	void fromMap(Map<String, dynamic> data) {
		if (data.containsKey('name')) name = data['name'].toString();
		if (data.containsKey('level')) level = double.tryParse(data['level'].toString())!;
		super.fromMap(data);
	}

	@override
	Map<String, dynamic> asMap() {
		Map<String, dynamic> message = {};

		message.addAll(super.asMap());
		return message;
	}
}

class CursusUser extends Model {

	String grade = "";

	String name = "";

	double? level = 0;

	List<Skill> skills = [];

	String? blackHoled;

	List<Project> projects = [];

	@override
	void fromMap(Map<String, dynamic> data) {
		if (data.containsKey('cursus')) {
			Map<String, dynamic> cursusInfo = data['cursus'];
			if (cursusInfo.containsKey('name')) name = cursusInfo['name'].toString();
			super.fromMap(cursusInfo);
		}
		if (data.containsKey('grade')) grade = data['grade'].toString();
		if (data.containsKey('level')) {
		  level = double?.tryParse(data['level'].toString());
		}
		if (data.containsKey('blackholed_at')) blackHoled = data['blackholed_at'].toString();
		if (data.containsKey('skills')) {
			List skillsData = data['skills'];
			skillsData.forEach((skill) {
				skills.add(Skill()..fromMap(skill));
			});
		}
	}

	@override
	Map<String, dynamic> asMap() {
		Map<String, dynamic> message = {};

		message.addAll(super.asMap());
		return message;
	}
}