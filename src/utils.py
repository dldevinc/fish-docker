import re
import subprocess
from typing import Dict, List

import conf
import exceptions

re_usage = re.compile(r"^Usage:\s+(.*)$", flags=re.MULTILINE)
re_options = re.compile(r"Options:(.*?)(?:\n\n|\Z)", flags=re.DOTALL | re.MULTILINE)
re_option = re.compile(
    r"(?:-(?P<short>\w))?"
    r"(?:,\s)?"
    r"(?:--(?P<long>[-\w]+)(?:[\s=](?P<arg>[^\s]+))?)?"
    r"\s+(?P<description>.*)"
)
re_commands = re.compile(r"Commands:(.*?)(?:\n\n|\Z)", flags=re.DOTALL | re.MULTILINE)
re_command = re.compile(r"(?P<name>[-\w]+\*?)\s{2,}(?P<description>.*)")


def get_cleaned_command(command: str) -> str:
    return " ".join([
        part
        for part in re.split(r"\s+", command)
        if not part.startswith("-")
    ])


def get_command_output(command: str, env: Dict = None) -> str:
    result = subprocess.run(
        command,
        shell=True,
        encoding="utf-8",
        capture_output=True,
        env=env
    )
    if result.returncode:
        raise RuntimeError(result.stderr)

    return result.stdout


def parse_usage(output: str) -> str:
    match = re_usage.search(output)
    if match:
        return match.group(1)
    else:
        return ""


def parse_options(output: str) -> List[Dict]:
    options_match = re_options.search(output)
    if options_match is None:
        return []

    options_str = options_match.group(1)

    # strip lines and concat multiline description
    options_str = re.sub(r"\n\s{7,}(.*?)", " \\1", options_str)
    options_str = re.sub(r"^\s*(.*?)\s*$", "\\1", options_str, flags=re.MULTILINE)

    options = []
    for line in options_str.split("\n"):
        match = re_option.fullmatch(line)
        if match is None:
            raise exceptions.InvalidOption(line)

        options.append({
            key: value
            for key, value in match.groupdict().items()
            if value is not None
        })

    return options


def convert_option(option: Dict) -> str:
    """
    Convert a dictionary to the string of options for a `complete` command.
    """
    line = []

    if "long" in option:
        line.append(f'-l {option["long"]}')

    if "short" in option:
        line.append(f'-s {option["short"]}')

    if "arg" in option:
        line.append("-r")

    if "description" in option:
        if "'" in option["description"] and "\"" in option["description"]:
            description = option["description"].replace("'", "\'")
            line.append(f'-d "{description}"')

        if "'" in option["description"]:
            line.append(f'-d "{option["description"]}"')
        else:
            line.append(f"-d '{option['description']}'")

    return " ".join(line)


def parse_subcommands(output: str, extra_commands: List[Dict] = None) -> List[Dict]:
    command_blocks = re_commands.findall(output)
    if command_blocks is None:
        return []

    commands = []

    if extra_commands:
        commands.extend(extra_commands)

    for command_block in command_blocks:
        # strip lines
        command_block = re.sub(r"^\s*(.*?)\s*$", "\\1", command_block, flags=re.MULTILINE)

        for line in command_block.split("\n"):
            match = re_command.fullmatch(line)
            if match is None:
                raise exceptions.InvalidCommand(line)

            command = {
                key: value
                for key, value in match.groupdict().items()
                if value is not None
            }

            # skip marked commands
            if command["name"].endswith("*"):
                continue

            commands.append(command)

    return sorted(
        commands,
        key=lambda opt: opt["name"]
    )


def convert_subcommand(option: Dict) -> str:
    """
    Convert a dictionary to the string of options for a `complete` command.
    """
    line = []

    if "description" in option:
        if "'" in option["description"] and "\"" in option["description"]:
            raise exceptions.QuotesConflictError(option)

        if "'" in option["description"]:
            line.append(f'-d "{option["description"]}"')
        else:
            line.append(f"-d '{option['description']}'")

    return " ".join(line)


def parse_command_info(command: str, env: Dict = None) -> Dict:
    """
    Parse command help information to a dictionary
    """
    output = get_command_output(command, env)

    result = {}

    usage = parse_usage(output)
    if usage:
        result["usage"] = usage

    options = parse_options(output)
    if options:
        result["options"] = options

    extra_commands = conf.HIDDEN_COMMANDS.get(get_cleaned_command(command))
    subcommands = parse_subcommands(output, extra_commands=extra_commands)
    if subcommands:
        result["subcommands"] = subcommands

    return result
