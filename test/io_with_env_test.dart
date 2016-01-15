/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

@TestOn("vm")
library websockets.test.io_with_env;

import "package:test/test.dart";

import "package:websockets/env/io.dart";

import "tests_to_run.dart" as tests;

main() {
  group("io_with_env", () {
    tests.main();
  });
}
