/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.environments.exception;

class EnvironmentException implements Exception {
  final String message;

  EnvironmentException(String this.message);

  @override
  String toString() => "EnvironmentException: $message";
}
