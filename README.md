## Bazel Java Example - Generated Checkstyle Config

This is an example of using a generated file as a checkstyle config for `rules_jvm`'s linting.
It is not currently working.

To try it out, first use the working config that uses a static file:
```python
# BUILD.bazel

# This works
checkstyle_config(
    name = "my_checkstyle_config",
    checkstyle_binary = ":checkstyle_bin",
    config_file = "checkstyle.xml",
    visibility = ["//visibility:public"],
)

# This doesn't
#checkstyle_config_wrapped(
#    name = "my_checkstyle_config",
#    checkstyle_binary = ":checkstyle_bin",
#    checkstyle_xml = "checkstyle.xml",
#)
```

Running this should produce a failed test due to failing linting.
```bash
# bazel test //...
INFO: Invocation ID: afc08e49-5231-4fd2-b42f-58481683e474
INFO: Analyzed 6 targets (24 packages loaded, 429 targets configured).
INFO: Found 5 targets and 1 test target...
FAIL: //:entrypoint-checkstyle (see /private/var/tmp/_bazel_vrose/17aacbd88bcaf1ce194e6bbdb78e4a29/execroot/__main__/bazel-out/darwin_arm64-fastbuild/testlogs/entrypoint-checkstyle/test.log)
INFO: From Testing //:entrypoint-checkstyle:
==================== Test output for //:entrypoint-checkstyle:
com.puppycrawl.tools.checkstyle.api.CheckstyleException: RedundantImport is not allowed as a child in Checker
	at com.puppycrawl.tools.checkstyle.Checker.setupChild(Checker.java:502)
	at com.puppycrawl.tools.checkstyle.api.AutomaticBean.configure(AutomaticBean.java:201)
	at com.puppycrawl.tools.checkstyle.Main.runCheckstyle(Main.java:404)
	at com.puppycrawl.tools.checkstyle.Main.runCli(Main.java:331)
	at com.puppycrawl.tools.checkstyle.Main.execute(Main.java:190)
	at com.puppycrawl.tools.checkstyle.Main.main(Main.java:125)
Checkstyle ends with 1 errors.
================================================================================
INFO: Elapsed time: 0.742s, Critical Path: 0.53s
INFO: 2 processes: 1 disk cache hit, 1 darwin-sandbox.
INFO: Build completed, 1 test FAILED, 2 total actions
//:entrypoint-checkstyle                                                 FAILED in 0.5s
  /private/var/tmp/_bazel_vrose/17aacbd88bcaf1ce194e6bbdb78e4a29/execroot/__main__/bazel-out/darwin_arm64-fastbuild/testlogs/entrypoint-checkstyle/test.log

Executed 1 out of 1 test: 1 fails locally.
```

Now, try using the generated config:
```python
# This works
#checkstyle_config(
#    name = "my_checkstyle_config",
#    checkstyle_binary = ":checkstyle_bin",
#    config_file = "checkstyle.xml",
#    visibility = ["//visibility:public"],
#)

# This doesn't
checkstyle_config_wrapped(
    name = "my_checkstyle_config",
    checkstyle_binary = ":checkstyle_bin",
    checkstyle_xml = "checkstyle.xml",
)
```

Running this produces a failed test, but for the wrong reasons. It is failing to run the checkstyle tests.
It is failing here: https://github.com/bazel-contrib/rules_jvm/blob/main/java/private/checkstyle.bzl#L18
```bash
INFO: Invocation ID: 300a43af-8451-4adb-b49f-a69bfe52a210
INFO: Analyzed 7 targets (2 packages loaded, 11 targets configured).
INFO: Found 6 targets and 1 test target...
FAIL: //:entrypoint-checkstyle (see /private/var/tmp/_bazel_vrose/17aacbd88bcaf1ce194e6bbdb78e4a29/execroot/__main__/bazel-out/darwin_arm64-fastbuild/testlogs/entrypoint-checkstyle/test.log)
INFO: From Testing //:entrypoint-checkstyle:
==================== Test output for //:entrypoint-checkstyle:
/private/var/tmp/_bazel_vrose/17aacbd88bcaf1ce194e6bbdb78e4a29/sandbox/darwin-sandbox/106/execroot/__main__/bazel-out/darwin_arm64-fastbuild/bin/entrypoint-checkstyleexec.runfiles/__main__/entrypoint-checkstyleexec: line 5: cd: bazel-out/darwin_arm64-fastbuild/bin: No such file or directory
================================================================================
INFO: Elapsed time: 0.795s, Critical Path: 0.70s
INFO: 5 processes: 3 internal, 2 darwin-sandbox.
INFO: Build completed, 1 test FAILED, 5 total actions
//:entrypoint-checkstyle                                                 FAILED in 0.5s
  /private/var/tmp/_bazel_vrose/17aacbd88bcaf1ce194e6bbdb78e4a29/execroot/__main__/bazel-out/darwin_arm64-fastbuild/testlogs/entrypoint-checkstyle/test.log

Executed 1 out of 1 test: 1 fails locally.
```

