import 'package:flutter/cupertino.dart';
import 'package:git_drive/io/app_data_manager.dart';
import 'package:github/github.dart';

late Authentication _auth;

class GitHubAuthentication {
  static void authenticateAutomatically() {
    _auth = Authentication.withToken(prefs.getString('token'));
  }

  static Future<bool> loginWithGitHub({auth}) async {
    GitHub gitHub = GitHub(auth: auth ?? findAuthenticationFromEnvironment());
    try {
      CurrentUser user = await gitHub.users.getCurrentUser();
      debugPrint(user.name);
      _auth = gitHub.auth as Authentication;
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  }

  static GitHub getGitHubInstance() {
    return GitHub(auth: _auth);
  }

  static Future<CurrentUser> getCurrentUser() async {
    return await getGitHubInstance().users.getCurrentUser();
  }

  static Future<String> getCurrentUserName() async {
    return (await getCurrentUser()).login as String;
  }

  static Future<String> getCurrentUserEmail() async {
    return (await getCurrentUser()).email as String;
  }
}
