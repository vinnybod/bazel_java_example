load("@contrib_rules_jvm//java:defs.bzl", "checkstyle_config")

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
