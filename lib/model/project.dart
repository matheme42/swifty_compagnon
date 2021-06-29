import 'package:swifty_compagnon/model/model.dart';

class Project extends Model {

	int? occurrence = 0;

	int? finalMark = 0;

	String status = "";

	bool validated = false;

	String name = "";

	int cursusId = 0;

	@override
	void fromMap(Map<String, dynamic> data) {
		if (data.containsKey('occurrence')) occurrence = int?.tryParse(data['occurrence'].toString());
		if (data.containsKey('final_mark')) finalMark = int?.tryParse(data['final_mark'].toString());
		if (data.containsKey('status')) status = data['status'].toString();
		if (data.containsKey('validated?') && data['validated?'] != null) validated = data['validated?'];
		if (data.containsKey("project")) {
			Map projectData = data["project"];
			if (projectData.containsKey('name')) name = projectData['name'].toString();
		}
		if (data.containsKey("cursus_ids")) {
			List cursusIdData = data["cursus_ids"];
			cursusId = cursusIdData.first;
		}
	}

	@override
	Map<String, dynamic> asMap() {
		Map<String, dynamic> message = {};

		return message;
	}
}