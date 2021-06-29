import 'package:flutter/material.dart';
import 'package:http_request/http_request.dart';
import 'package:root/home.dart';
import 'package:swifty_compagnon/context.dart';
import 'package:snack/snack.dart';
import 'package:swifty_compagnon/main.dart';
import 'package:swifty_compagnon/model/user.dart';
import 'package:swifty_compagnon/userInfo.dart';

abstract class Backend {
	HttpRequest _requestManager = HttpRequest();
	static int lastRequest = 0;
	static int currentRequest = 0;

	Future<void> _wait() async {
		int requestNumber = lastRequest;
		lastRequest += 1;
		while (requestNumber != currentRequest) {
			await Future.delayed(Duration(seconds: 1));
		}
	}

	_done() => currentRequest += 1;

	@protected
	Future<dynamic> _get(String _service, Map<String, String> argument,
		{String? message, Widget? icon}) async {
		_wait();
		var response = await _requestManager.get(_service, argument);
		_done();
		if (response != null && message != null) {
			Snack.success(message, icon: icon);
		}
		return response;
	}

	@protected
	Future<dynamic> _delete(String _service, Map<String, String> argument,
		{String? message, Widget? icon}) async {
		_wait();
		var response = await _requestManager.delete(_service, argument);
		_done();
		if (response != null && message != null) {
			Snack.success(message, icon: icon);
		}
		return response;
	}

	@protected
	Future<dynamic> _post(String _service, Map<String, dynamic> body,
		{String? message, Widget? icon}) async {
		_wait();
		var response = await _requestManager.post(_service, body);
		_done();
		if (response != null && message != null) {
			Snack.success(message, icon: icon);
		}
		return response;
	}

	@protected
	Future<dynamic> _put(String _service, Map<String, dynamic> body, {String? message, Widget? icon}) async {
		_wait();
		var response = await _requestManager.put(_service, body);
		_done();
		if (response != null && message != null) {
			Snack.success(message, icon: icon);
		}
		return response;
	}
}

class SwiftyCompagnonBackend extends Backend {

	/// the method getToken await a message from the backend
	/// the message is to the format
	/// message : {
	/// 	"grant_type" : "client_credentials",
	/// 	"client_id" : "6c4307bdcb507c5e9665ed389770c5e54e418df8244c1f602d512b341c4cf8c5",
    ///		"client_secret" : "3e6b7540b0cd730ae4d88b200240db4258dfb99d4095da57da9dfc8bccefa011"
	/// }
	/// if the request have a 200 response return true
	/// else return false
	Future<bool> getToken() async {
		// a link to the global context of the app
		SwiftyCompagnonContext context = SwiftyCompagnonContext.ofRootContext;

		Map<String, dynamic> body = {
			"grant_type" : "authorization_code",
			"client_id" : "6c4307bdcb507c5e9665ed389770c5e54e418df8244c1f602d512b341c4cf8c5",
			"client_secret" : "3e6b7540b0cd730ae4d88b200240db4258dfb99d4095da57da9dfc8bccefa011",
			"code" : context.codeToken,
			"redirect_uri" : "https://profile.intra.42.fr/"
		};
		Map? response = await super._post("/oauth/token", body);
		if (response == null) return false;

		context.accessToken = response['access_token'];
		context.expiredAccessToken = DateTime.fromMillisecondsSinceEpoch((response['created_at'] + DateTime.now().timeZoneOffset.inSeconds + response['expires_in']) * 1000).toUtc();
		return true;
	}

	/// the method getToken await a message from the backend
	/// the message is to the format
	/// message : {
	/// 	"grant_type" : "client_credentials",
	/// 	"client_id" : "6c4307bdcb507c5e9665ed389770c5e54e418df8244c1f602d512b341c4cf8c5",
	///		"client_secret" : "3e6b7540b0cd730ae4d88b200240db4258dfb99d4095da57da9dfc8bccefa011"
	/// }
	/// if the request have a 200 response return true
	/// else return false
	Future<List<User>> getUsersInfo(String login) async {

		// a link to the global context of the app
		SwiftyCompagnonContext context = SwiftyCompagnonContext.ofRootContext;
		if (!context.tokenIsValid)
			return [];

		Map<String, String> body = {
			"access_token" : "${context.accessToken}",
			"range[login]" : "$login,${login}z",
		};
		List? response = await super._get("/v2/users", body);
		if (response == null) return [];

		List<User> users = [];
		response.forEach((user) {
			users.add(User()..fromMap(user));
		});
		return users;
	}

	Future<void> getUserInfo() async {
		// a link to the global context of the app
		SwiftyCompagnonContext context = SwiftyCompagnonContext.ofRootContext;
		if (!context.tokenIsValid)
			return ;

		Map<String, String> body = {
			"access_token" : "${context.accessToken}",
		};
		Map<String, dynamic>? response = await super._get("/v2/users/${context.currentUser.login}", body);
		if (response == null) return ;
		User user = context.currentUser;
		user.fromMap(response);
	}
}