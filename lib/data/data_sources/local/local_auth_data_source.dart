/// Local authentication data source
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../models/user_model.dart';
import '../../../core/constants/app_constants.dart';

abstract class LocalAuthDataSource {
  Future<UserModel?> getUser();
  Future<void> saveUser(UserModel user);
  Future<void> clearUser();
  Future<bool> hasCompletedOnboarding();
  Future<void> setOnboardingComplete();
  Future<String?> getAuthToken();
  Future<void> saveAuthToken(String token);
  Future<void> clearAuthToken();
}

/// Local authentication data source implementation using SharedPreferences
class LocalAuthDataSourceImpl implements LocalAuthDataSource {
  final SharedPreferences _prefs;

  LocalAuthDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<UserModel?> getUser() async {
    try {
      final userJson = _prefs.getString(AppConstants.userPrefsKey);
      if (userJson == null) {
        return null;
      }
      return UserModel.fromJson(jsonDecode(userJson) as Map<String, dynamic>);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveUser(UserModel user) async {
    try {
      final userJson = jsonEncode(user.toJson());
      await _prefs.setString(AppConstants.userPrefsKey, userJson);
      await _prefs.setString(AppConstants.userIdKey, user.id);
    } catch (e) {
      throw Exception('Failed to save user: $e');
    }
  }

  @override
  Future<void> clearUser() async {
    try {
      await _prefs.remove(AppConstants.userPrefsKey);
      await _prefs.remove(AppConstants.userIdKey);
      await _prefs.remove(AppConstants.authTokenKey);
    } catch (e) {
      throw Exception('Failed to clear user: $e');
    }
  }

  @override
  Future<bool> hasCompletedOnboarding() async {
    return _prefs.getBool(AppConstants.hasCompletedOnboardingKey) ?? false;
  }

  @override
  Future<void> setOnboardingComplete() async {
    await _prefs.setBool(AppConstants.hasCompletedOnboardingKey, true);
  }

  @override
  Future<String?> getAuthToken() async {
    return _prefs.getString(AppConstants.authTokenKey);
  }

  @override
  Future<void> saveAuthToken(String token) async {
    await _prefs.setString(AppConstants.authTokenKey, token);
  }

  @override
  Future<void> clearAuthToken() async {
    await _prefs.remove(AppConstants.authTokenKey);
  }
}
