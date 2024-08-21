## Bazel Java Example - scalafmt include/exclude paths not working

## Background

`rules_lint`'s scalafmt seems to ignore `include` and `exclude` paths.

## Reproduction

Run `bazel test //tools/format:format_test --test_output=errors` to see that both `DontFormatThis.scala` and `FormatThis.scala`
 are attempted to be formatted.
```shell
==================== Test output for //tools/format:format_test_Scala_with_scalafmt:
--- a/Users/vinnybod/dev/vinnybod/bazel_java_example/app/src/main/scala/com/example/DontFormatThis.scala
+++ b/Users/vinnybod/dev/vinnybod/bazel_java_example/app/src/main/scala/com/example/DontFormatThis.scala
@@ -4,6 +4,4 @@
 
-
-  def main
-(args:
-Array[String]) = println("Hello, world")
+  def main(args: Array[String]) = println("Hello, world")
 }
+
--- a/Users/vinnybod/dev/vinnybod/bazel_java_example/app/src/main/scala/com/example/FormatThis.scala
+++ b/Users/vinnybod/dev/vinnybod/bazel_java_example/app/src/main/scala/com/example/FormatThis.scala
@@ -4,6 +4,4 @@
 
-
-  def main
-(args:
-Array[String]) = println("Hello, world")
+  def main(args: Array[String]) = println("Hello, world")
 }
+
error: --test failed
FAILED: A formatter tool exited with code 1
Try running 'bazel run //tools/format:format_test_Scala_with_scalafmt ' to fix this.
================================================================================
Target //tools/format:format_test_Scala_with_scalafmt up-to-date:
  bazel-bin/tools/format/format_test_Scala_with_scalafmt
INFO: Elapsed time: 1.241s, Critical Path: 1.13s
INFO: 2 processes: 2 local.
INFO: Build completed, 1 test FAILED, 2 total actions
```

Run `scala-cli fmt . --check` (I installed it via [coursier](https://get-coursier.io/docs/cli-installation#macos)).
See that only `FormatThis.scala` is attempted to be formatted.

```shell
--- a/Users/vinnybod/dev/vinnybod/bazel_java_example/app/src/main/scala/com/example/FormatThis.scala
+++ b/Users/vinnybod/dev/vinnybod/bazel_java_example/app/src/main/scala/com/example/FormatThis.scala
@@ -4,6 +4,4 @@
 
-
-  def main
-(args:
-Array[String]) = println("Hello, world")
+  def main(args: Array[String]) = println("Hello, world")
 }
+
error: --test failed
```