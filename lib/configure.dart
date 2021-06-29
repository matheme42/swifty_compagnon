import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http_request/http_request.dart';
import 'package:root/root.dart';
import 'package:snack/snack.dart';
import 'package:http/http.dart';

/// the function [onRequestHttpError] is call each time a http request return a
/// [non200] code
/// show a [Snack] message of what's wrong with the request
/// @todo make this function more readable
void onRequestHttpError(Response? response) {
	late String message;

	if (response != null) {
		try {
			Map map = json.decode(response.body);
			if (map.containsKey("error")) {
				message = map["error"].toString();
			} else {
				message = map.values.first.toString();
			}
		} catch (_) {
			message = response.body.toString();
		}
	}
	if (response == null) {
		Snack.error("aucune connection internet",
			icon: Icon(Icons.warning, color: Colors.yellow));
	} else if (response.statusCode == 400) {
		Snack.warning(message,
			title: "format de la requete invalide",
			icon: Icon(Icons.info_outline, color: Colors.blueAccent));
	} else if (response.statusCode == 404) {
		Snack.info(message,
			title: "ressource introuvable",
			icon: Icon(Icons.info_outline, color: Colors.amber));
	} else if (response.statusCode == 403) {
		Snack.warning(message, icon: Icon(Icons.audiotrack, color: Colors.white));
	} else if (response.statusCode == 500) {
		Snack.error(message,
			title: "le server a crash",
			icon: Icon(Icons.delete_sweep, color: Colors.yellow));
	} else if (response.statusCode == 401) {
		Snack.warning(message,
			title: "autorisation refuser",
			icon: Icon(Icons.cancel_rounded, color: Colors.white));
	} else {
		Snack.info(message,
			title: "quelque chose d'etrange est survenu",
			icon: Icon(Icons.audiotrack, color: Colors.amber));
	}
}

Future<void> configure() async {
	HttpRequest.onRequestError = onRequestHttpError;
	HttpRequest('42').configure(
		useByDefault: true,
		port: "443",
		server: "api.intra.42.fr",
		https: true,
		httpRequestDebug: HttpRequestDebug.MAX,
		timeOut: Duration(seconds: 10)
	);
	Snack().configure(context: Root.context!);
}