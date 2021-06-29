abstract class Serializable {
	Map<String, dynamic> asMap();

	void fromMap(Map<String, dynamic> data);
}

class Model extends Serializable {

	late int id;

	@override
	void fromMap(Map<String, dynamic> data) {
		if (data.containsKey('id')) id = int.tryParse(data['id'].toString())!;
	}

	@override
	Map<String, dynamic> asMap() {
		Map<String, dynamic> message = {};

		message['id'] = id;
		return message;
	}
}