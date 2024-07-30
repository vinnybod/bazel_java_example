## Bazel Java Example - classifier missing from generated pom.xml

## Background

Generated pom.xml from `java_export` does not contain the classifier for the artifact.
In some cases, it incorectly places the classifier in the `<scope>` tag.

## Reproduction

First build the repo using `bazel build //...`

View the contents of `bazel-bin/app/app-pom.xml`.

You can observe that the classifier is being added to the pom file as a `<scope>` tag.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example.vinnybod</groupId>
    <artifactId>app</artifactId>
    <version>0.0.1</version>

    <dependencies>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>linux-aarch_64</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>linux-x86_64</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>osx-aarch_64</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>osx-x86_64</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>windows-x86_64</scope>
        </dependency>
    </dependencies>
</project>
```

Uncomment the `runtime_deps` from `app/BUILD.bazel` and rebuild the repo using `bazel build //...`

View the contents of `bazel-bin/app/app-pom.xml`.

Observe that the scope is now properly reported as `runtime`, but the classifier is missing.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example.vinnybod</groupId>
    <artifactId>app</artifactId>
    <version>0.0.1</version>

    <dependencies>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
        </dependency>
    </dependencies>
</project>
```

## Solution

Swap the `rules_jvm_external` in `WORKSPACE.bazel` with the `git_repository` in
`WORKSPACE.bazel`.

Comment out the `runtime_deps` from `app/BUILD.bazel`

Rebuild the repo using `bazel build //...`

View the contents of `bazel-bin/app/app-pom.xml`.

Observe that the classifier is now properly reported.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example.vinnybod</groupId>
    <artifactId>app</artifactId>
    <version>0.0.1</version>

    <dependencies>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <classifier>linux-aarch_64</classifier>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <classifier>linux-x86_64</classifier>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <classifier>osx-aarch_64</classifier>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <classifier>osx-x86_64</classifier>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <classifier>windows-x86_64</classifier>
        </dependency>
    </dependencies>
</project>
```

Uncomment the `runtime_deps` from `app/BUILD.bazel`

Rebuild the repo using `bazel build //...`

Observe that both scope and classifier are now properly reported.
```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd" xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example.vinnybod</groupId>
    <artifactId>app</artifactId>
    <version>0.0.1</version>

    <dependencies>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
            <classifier>linux-aarch_64</classifier>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
            <classifier>linux-x86_64</classifier>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
            <classifier>osx-aarch_64</classifier>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
            <classifier>osx-x86_64</classifier>
        </dependency>
        <dependency>
            <groupId>io.netty</groupId>
            <artifactId>netty-tcnative-boringssl-static</artifactId>
            <version>2.0.61.Final</version>
            <scope>runtime</scope>
            <classifier>windows-x86_64</classifier>
        </dependency>
    </dependencies>
</project>
```