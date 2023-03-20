#!/usr/bin/env python3
import argparse
import re
from pathlib import Path
from typing import Dict

import utils


def process_command(params: Dict):
    executable = params["executable"]
    executable_id = executable.replace("-", "_")
    arguments = " ".join(params["arguments"])

    command = (executable + " " + arguments).strip()
    if "--help" not in command:
        command = f"{command} --help"

    parsed_info = utils.parse_command_info(command, params.get("env"))

    cleaned_command = " ".join([
        part
        for part in re.split(r"\s+", command)
        if not part.startswith("-")
    ])
    yield f"# {cleaned_command}"

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
                ],
                "env": params["env"]
            })


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        usage="\n"
              "  python3 main.py -- docker > completions/docker.fish"
              "  python3 main.py -- docker-compose > completions/docker-compose.fish"
    )
    parser.add_argument("command", type=str, nargs="+", default="docker")
    parser.add_argument("--buildkit", action="store_true")
    options = parser.parse_args()

    params = {
        "executable": " ".join(options.command),
        "arguments": [],
        "prefix_first": "complete -c {executable} -n '__fish_is_first_{executable_id}_argument'",
        "prefix_subcommand_startswith": "complete -c {executable} -n '__fish_{executable_id}_arguments_startswith {arguments}'",
        "prefix_subcommand_equals": "complete -c {executable} -n '__fish_{executable_id}_arguments_equals {arguments}'",
        "level": 0,
        "injections": [],
        "env": {
            "DOCKER_BUILDKIT": str(int(options.buildkit))
        }
    }

    # Output function definitions
    if len(options.command) == 1:
        prefix_file = Path("./prefix") / f"{options.command[0]}.fish"
        if prefix_file.exists():
            print(prefix_file.read_text())

    for line in process_command(params):
        print(line)
