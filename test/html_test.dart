/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

@TestOn("browser")
library websockets.test.html;

import "package:test/test.dart";
import "dart:html";

import "tests_to_run.dart" as tests;

main() {
  group("html", () {
    tests.main();
  });
}
