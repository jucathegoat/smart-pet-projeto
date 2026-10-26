import 'package:shelf/shelf.dart';
import 'package:shelf/src/middleware.dart';
import '../../utils/custom_env.dart';
import 'security_service.dart';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class SecurityServiceImp implements SecurityService<JWT> {
  
  SecurityServiceImp(){
    print('Objeto criado ${DateTime.now().microsecondsSinceEpoch}');
  }
  
  @override
  Future<String> generateJWT(String userID) async {
    final jwt = JWT({
      'iat': DateTime.now().millisecondsSinceEpoch,
      'userID': userID,
      'roles': ['admin', 'user'],
    });
    final String key = await CustomEnv.get(key: 'jwt_key');
    final String token = jwt.sign(SecretKey(key));
    return token;
  }

  @override
  Future<JWT?> validateJWT(String token) async {
    String key = await CustomEnv.get(key: 'jwt_key');

    try {
      return JWT.verify(token, SecretKey(key));
    } on JWTInvalidException {
      return null;
    } on JWTExpiredException {
      return null;
    } on JWTUndefinedException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  // TODO: implement authorization
  Middleware get authorization {
    return (Handler handler){
     return (Request req) async{
      String? authorizationHeader = req.headers['Authorization'];

      JWT? jwt;

      if(authorizationHeader != null){
        if(authorizationHeader.startsWith('Bearer ')){
          String token = authorizationHeader.substring(7);
         jwt = await validateJWT(token);
        }
      }

      var request = req.change(context: {'jwt':jwt});
      return handler(request);
      };
    };
  }

  @override
  // TODO: implement verifyJet
  Middleware get verifyJwt =>createMiddleware(
    requestHandler: (Request req){
      if(req.context['jwt'] == null){
        return Response.forbidden('Não autorizado');
      }
      return null;
    }
  );
  
}

