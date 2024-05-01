## Bazel Java Example - service file license gets jumbled

## Background

This is an example of an issue that occurs when a service file contains a license (or any comments). The comments get
sorted just like the rest of the file, which can cause issues when the order of the comments is important, such as in a license.

## Reproduction

First build the repo using `bazel build //...`

View the contents of `app-project.jar`'s `META-INF/services/com.example.ThingProvider` file. You will see that the comments are sorted.

Original File:
```
 # Licensed to the Apache Software Foundation (ASF) under one or more
 # contributor license agreements. See the NOTICE file distributed with
 # this work for additional information regarding copyright ownership.
 # The ASF licenses this file to You under the Apache License, Version 2.0
 # (the "License"); you may not use this file except in compliance with
 # the License. You may obtain a copy of the License at
 #
 #    http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.
com.example.ThingProviderImpl

```

File in `app-project.jar`:
```
 #
 #    http://www.apache.org/licenses/LICENSE-2.0
 # (the "License"); you may not use this file except in compliance with
 # Licensed to the Apache Software Foundation (ASF) under one or more
 # See the License for the specific language governing permissions and
 # The ASF licenses this file to You under the Apache License, Version 2.0
 # Unless required by applicable law or agreed to in writing, software
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # contributor license agreements. See the NOTICE file distributed with
 # distributed under the License is distributed on an "AS IS" BASIS,
 # limitations under the License.
 # the License. You may obtain a copy of the License at
 # this work for additional information regarding copyright ownership.
com.example.ThingProviderImpl
```

## Possible Solution

I built a potential solution for this at https://github.com/confluentinc/rules_jvm_external/commit/4c249d084f24aee09a8a9980787a8467a8094395

To test this, replace the `http_archive` for `rules_jvm_external` with the commented `git_repository` for `rules_jvm_external` in `WORKSPACE.bazel`. 
Then uncomment `prepend_services` in `app/BUILD.bazel` and rebuild the repo using `bazel build //...`

After this, you'll be able to observe that the resulting `META-INF/services/com.example.ThingProvider` file in `app-project.jar` is as expected:

```
 # Licensed to the Apache Software Foundation (ASF) under one or more
 # contributor license agreements. See the NOTICE file distributed with
 # this work for additional information regarding copyright ownership.
 # The ASF licenses this file to You under the Apache License, Version 2.0
 # (the "License"); you may not use this file except in compliance with
 # the License. You may obtain a copy of the License at
 #
 #    http://www.apache.org/licenses/LICENSE-2.0
 #
 # Unless required by applicable law or agreed to in writing, software
 # distributed under the License is distributed on an "AS IS" BASIS,
 # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 # See the License for the specific language governing permissions and
 # limitations under the License.

com.example.ThingProviderImpl

```