// features/auth/data/models/auth_result_model.dart

import '../../domain/entities/auth_result.dart';
import 'user_model.dart';

class AuthResultModel extends AuthResult {
  const AuthResultModel({
    required super.token,
    required super.user,  
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    // Handle different response structures
    final token = json['token'] as String? ?? 
                  json['access_token'] as String? ??
                  (json['data']?['access_token'] as String?);
    
    final userJson = json['user'] as Map<String, dynamic>? ?? 
                     json['data']?['user'] as Map<String, dynamic>?;
    
    if (token == null || token.isEmpty) {
      throw const FormatException('Token is missing from response');
    }
    
    if (userJson == null) {
      throw const FormatException('User data is missing from response');
    }
    
    return AuthResultModel(
      token: token,
      user: UserModel.fromJson(userJson),  
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': (user as UserModel).toJson(),  
    };
  }

  // Convert from entity
  factory AuthResultModel.fromEntity(AuthResult authResult) {
    return AuthResultModel(
      token: authResult.token,
      user: authResult.user,  
    );
  }

  // Convert to entity
  @override
  AuthResult toEntity() {
    return AuthResult(
      token: token,
      user: user,  
    );
  }
}