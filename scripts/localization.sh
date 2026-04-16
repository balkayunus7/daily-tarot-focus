#!/bin/bash

dart run easy_localization:generate -S assets/translations -f keys -O lib/core/util -o locale_keys.dart
echo "Locale keys generated successfully! ✅"
