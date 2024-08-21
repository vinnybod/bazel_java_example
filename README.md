## Bazel Java Example - classifier missing from generated pom.xml

## Background

`rules_lint`'s scalafmt seems to ignore `include` and `exclude` paths.

## Reproduction

Run `bazel test //tools/format:format_test` to see that both `DontFormatThis.scala` and `FormatThis.scala`
 are attempted to be formatted.

Run `scala-cli fmt . --check` (I installed it via [coursier](https://get-coursier.io/docs/cli-installation#macos)).
See that only `FormatThis.scala` is attempted to be formatted.