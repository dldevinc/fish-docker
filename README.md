# fish-docker

Docker completions for fish shell.

## Installation

```bash
mkdir -p ~/.config/fish/completions
wget -qO ~/.config/fish/completions/docker.fish https://raw.githubusercontent.com/dldevinc/fish-docker/main/completions/docker.fish
wget -qO ~/.config/fish/completions/docker-compose.fish https://raw.githubusercontent.com/dldevinc/fish-docker/main/completions/docker-compose.fish
```

## Manual generation

```bash
python3 src/main.py --buildkit docker > completions/docker.fish
python3 src/main.py --buildkit docker-compose > completions/docker-compose.fish
```
