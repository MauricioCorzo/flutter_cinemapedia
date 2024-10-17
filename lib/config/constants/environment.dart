import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String movieDbApiKey =
      dotenv.env["THE_MOVIEDB_KEY"] ?? "Api Key missing";

  static String movieDbBearerToken =
      dotenv.env["THE_MOVIEDB_BEARER_TOKEN"] ?? "Missing Bearer Token";
}
