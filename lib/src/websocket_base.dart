/*
 * The MIT License (MIT)
 * Copyright (c) 2016 Steven Roose
 */

library websockets.impl.base;

import 'dart:async';

import "../websockets.dart";

abstract class WebSocketBase extends Stream implements WebSocket {}
