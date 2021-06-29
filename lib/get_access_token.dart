import 'package:flutter/cupertino.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'backend.dart';
import 'context.dart';

class GetAccessToken extends StatelessWidget {
	Future<void> getToken() async {
		while (!SwiftyCompagnonContext.ofRootContext.tokenIsValid)
			await Future.delayed(Duration(seconds: 1));
	}
	static final String _initialUrl = "https://api.intra.42.fr/oauth/authorize?client_id=6c4307bdcb507c5e9665ed389770c5e54e418df8244c1f602d512b341c4cf8c5&redirect_uri=https%3A%2F%2Fprofile.intra.42.fr%2F&response_type=code";
	final Widget child;

	GetAccessToken({required this.child});

	@override
	Widget build(BuildContext context) {
		SwiftyCompagnonContext swiftyContext = SwiftyCompagnonContext.ofRootContext;
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
				child: !swiftyContext.tokenIsValid
					? FutureBuilder(
					future: getToken(),
					builder: (context, snapshot) {
						if (snapshot.connectionState == ConnectionState.done)
							return child;

						return WebView(
							javascriptMode: JavascriptMode.unrestricted,
							initialUrl: _initialUrl,
							navigationDelegate: (navReq) {
								if (navReq.url
									.startsWith("https://profile.intra.42.fr/")) {
									var responseUrl = Uri.parse(navReq.url);
									SwiftyCompagnonContext context =
										SwiftyCompagnonContext.ofRootContext;
									if (responseUrl.queryParametersAll
										.containsKey("error")) context.codeToken = "";
									context.codeToken = responseUrl
										.queryParametersAll["code"]!.first
										.toString();
									SwiftyCompagnonBackend().getToken();
									return NavigationDecision.prevent;
								}
								return NavigationDecision.navigate;
							},
						);
					})
					: child,
			));
	}
}