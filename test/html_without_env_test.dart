/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

@TestOn("browser")
library websockets.test.html_without_env;

import "package:test/test.dart";

import "tests_to_run.dart" as tests;

main() {
  group("html_without_env", () {
    tests.main();
  });
}
