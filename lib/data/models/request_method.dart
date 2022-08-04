import 'package:dio/dio.dart';
import 'package:flutter_simple_base_project/core/error_handling/exceptions.dart';

enum RequestMethod { get, post }

extension RequestMethodExt on RequestMethod {
  String get name {
    switch (this) {
      case RequestMethod.get:
        return 'GET';
      case RequestMethod.post:
        return 'POST';
    }
  }

  Options get options {
    switch (this) {
      case RequestMethod.get:
        return Options(method: name);
      case RequestMethod.post:
        return Options(method: name);
    }
  }

  static RequestMethod getRequestMethodFromOptionName(String name) {
    if (name.toUpperCase() == RequestMethod.get.name) return RequestMethod.get;

    if (name.toUpperCase() == RequestMethod.post.name) {
      return RequestMethod.post;
    }

    throw UnhandledException();
  }
}
