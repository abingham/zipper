#!/bin/bash

rackup             \
  --env production \
  --host 0.0.0.0   \
  --port 4587      \
  --server thin    \
  --warn           \
    config.ru
