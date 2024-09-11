## Bazel Java Example - javadoc generation including dependency sources

## Background

This is an example project that uses `java_export` to generate maven artifacts (pom, docs, etc).
It imports a `neverlink` (compile-only) dependency, which causes the `javadoc` rule to fail.

From what I can tell, the `app-project-src.jar` is including the source files from the dependency, 
when it should only include the source files from the app itself.

## Reproduction

First build the repo using `bazel build //...`

```shell
INFO: From Action app/app-docs.jar:
javadoc -cp bazel-out/darwin_arm64-fastbuild/bin/lib/liblib.jar:bazel-out/darwin_arm64-fastbuild/bin/app/app-project.jar:bazel-out/darwin_arm64-fastbuild/bin/lib/liblib-hjar.jar:bazel-out/darwin_arm64-fastbuild/bin/app/app-project-ijar.jar -notimestamp -use -quiet -Xdoclint:-missing -encoding UTF8 --frames -html5 -d /var/folders/xk/zbl9py8n4fx7jsqkg4wyw2_00000gq/T/output-dir4318159177845195523 /var/folders/xk/zbl9py8n4fx7jsqkg4wyw2_00000gq/T/unpacked-sources6449193471939799573/com/example/EntryPoint.java /var/folders/xk/zbl9py8n4fx7jsqkg4wyw2_00000gq/T/unpacked-sources6449193471939799573/com/library/CompileOnlyLibrary.java
javadoc: warning - You have specified to generate frames, by using the --frames option.
The default is currently to not generate frames and the support for 
frames will be removed in a future release.
To suppress this warning, remove the --frames option and avoid the use of frames.
/var/folders/xk/zbl9py8n4fx7jsqkg4wyw2_00000gq/T/unpacked-sources6449193471939799573/com/library/CompileOnlyLibrary.java:3: error: package org.junit.jupiter.api does not exist
import org.junit.jupiter.api.Test;
                            ^
/var/folders/xk/zbl9py8n4fx7jsqkg4wyw2_00000gq/T/unpacked-sources6449193471939799573/com/library/CompileOnlyLibrary.java:4: error: package com.google.common.collect does not exist
import com.google.common.collect.Lists;
                                ^
2 errors
1 warning

ERROR: /Users/vrose/dev/vinnybod/bazel_java_example/app/BUILD.bazel:3:12: output 'app/app-docs.jar' was not created
ERROR: /Users/vrose/dev/vinnybod/bazel_java_example/app/BUILD.bazel:3:12: output 'app/app-docs-element-list-dir/element-list' was not created
ERROR: /Users/vrose/dev/vinnybod/bazel_java_example/app/BUILD.bazel:3:12: Action app/app-docs.jar failed: not all outputs were created or valid
INFO: Elapsed time: 38.488s, Critical Path: 12.53s
INFO: 273 processes: 10 disk cache hit, 29 internal, 229 darwin-sandbox, 5 worker.
ERROR: Build did NOT complete successfully
```

From the error message, it seems that the `javadoc` rule is reading the `CompileOnlyLibrary.java` file which is 
importing classes from `guava` and `junit` (and failing). `

`jar tf bazel-bin/app/app-project-src.jar` shows that the `CompileOnlyLibrary.java` file is unexpectedly included in the src jar.
Note that the `Library.java` file is not included in the jar, which is expected.
```shell
META-INF/
META-INF/MANIFEST.MF
com/
com/example/
com/example/EntryPoint.java
com/library/
com/library/CompileOnlyLibrary.java
```

I also noticed that if you remove the `maven:compile-only` tag from `compile_only_lib`, it will succeed at generating the docs. 
However, then `pom.xml` will then include the `compile_only_lib` as a dependency, which we don't want.

## Expected Behavior

The `app-project-src.jar` should only include the source files from the app itself, and not the dependencies.