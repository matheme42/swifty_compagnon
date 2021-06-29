import 'package:flutter/material.dart';
import 'package:root/context.dart';
import 'package:root/home.dart';
import 'package:root/root.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';
import 'package:swifty_compagnon/main.dart';
import 'package:swifty_compagnon/userInfo.dart';

import 'model/models.dart';

class SwiftyCompagnonContext extends AppContext {
	/// the normal constructor of the context
	/// use them to create a new instance of [SwiftyCompagnonContext]
	SwiftyCompagnonContext();

	static Logger _contextLogger = Logger('SwiftyCompagnonContext');

	/// this function allow you to get the context of the currently context
	/// of the app. Use them to get the appContext of the flutter tree
	static SwiftyCompagnonContext get ofRootContext {
		return Provider.of<SwiftyCompagnonContext>(Root.context!, listen: false);
	}

	static SwiftyCompagnonContext of(BuildContext context, {listen = false}) {
		return Provider.of<SwiftyCompagnonContext>(context, listen: listen);
	}

	String? accessToken;
	String? codeToken;
	DateTime? expiredAccessToken;
	User? _currentUser;

	get tokenIsValid{
		if (accessToken == null)
			return false;
		int remainingTime = ((expiredAccessToken!.millisecondsSinceEpoch - (DateTime.now().millisecondsSinceEpoch + (DateTime.now().timeZoneOffset.inSeconds * 1000))) / 1000).ceil() - 60;
		if (remainingTime < 0)
			return false;
		return true;
	}

	set currentUser(value) {
		_currentUser = value;

		if (value == null)
			Home.ofContext!.body = App();
		else
			Home.ofContext!.body = UserInfo();
	}



	get currentUser {
		return _currentUser;
	}
}