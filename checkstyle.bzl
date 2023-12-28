load("@contrib_rules_jvm//java:defs.bzl", "checkstyle_config")

# This is a minimal example of generating a checkstyle config.
# All it does is copy the checkstyle config from the source tree to the
# output directory and then try to generate a checkstyle_config with it.
def checkstyle_config_wrapped(
        name,
        checkstyle_binary,
        checkstyle_xml):
    out_file = name + "_generated.xml"
    gen_name = name + "_genrule"
    native.genrule(
        name = gen_name,
        srcs = [
            checkstyle_xml,
        ],
        outs = [out_file],
        cmd = """
                 cp $(location {checkstyle_xml}) $(@D)/{output_file}
                 """.format(
            checkstyle_xml = checkstyle_xml,
            output_file = out_file,
        ),
    )

    checkstyle_config(
        name = name,
        checkstyle_binary = checkstyle_binary,
        config_file = "//:" + gen_name,
        visibility = ["//visibility:public"],
    )
