/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

@TestOn("vm")
library websockets.test.io;

import "package:test/test.dart";
import "dart:io";

import "tests_to_run.dart" as tests;

main() {
  group("io", () {
    tests.main();
  });
}
