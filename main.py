#!/usr/bin/env python3
import argparse
from typing import Dict

import utils


def process_command(params: Dict):
    executable = params["executable"]
    executable_id = executable.replace("-", "_")
    arguments = " ".join(params["arguments"])
    command = (executable + " " + arguments).strip()

    parsed_info = utils.parse_command_info(command)

    yield f"# {command}"

    if "usage" in parsed_info:
        yield f"# Usage: {parsed_info['usage']}"

    if params["level"] == 0:
        prefix = params["prefix_first"].format(
            executable=executable,
            arguments=arguments,
            executable_id=executable_id,
        )
    elif params["level"] == 1 and "options" not in parsed_info:
        prefix = params["prefix_subcommand_equals"].format(
            executable=executable,
            arguments=arguments,
            executable_id=executable_id,
        )
    else:
        prefix = params["prefix_subcommand_startswith"].format(
            executable=executable,
            arguments=arguments,
            executable_id=executable_id,
        )

    if "injections" in params:
        yield from params["injections"]

    if "options" in parsed_info:
        for option in parsed_info["options"]:
            yield "{} {}".format(
                prefix,
                utils.convert_option(option)
            )

    if "subcommands" in parsed_info:
        for subcommand_data in parsed_info["subcommands"]:
            yield ""
            yield from process_command({
                "executable": params["executable"],
                "arguments": params["arguments"] + [subcommand_data["name"]],
                "prefix_first": params["prefix_first"],
                "prefix_subcommand_startswith": params["prefix_subcommand_startswith"],
                "prefix_subcommand_equals": params["prefix_subcommand_equals"],
                "level": params["level"] + 1,
                "injections": [
                    "{} -fa {} {}".format(
                        prefix,
                        subcommand_data["name"],
                        utils.convert_subcommand(subcommand_data)
                    )
                ]
            })


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("command")
    options = parser.parse_args()

    params = {
        "executable": options.command,
        "arguments": [],
        "prefix_first": "complete -c {executable} -n '__fish_is_first_{executable_id}_argument'",
        "prefix_subcommand_startswith": "complete -c {executable} -n '__fish_{executable_id}_arguments_startswith {arguments}'",
        "prefix_subcommand_equals": "complete -c {executable} -n '__fish_{executable_id}_arguments_equals {arguments}'",
        "level": 0,
        "injections": []
    }

    for line in process_command(params):
        print(line)
