# dockerapp_template

> A dockerized service.

## Requirements

- Docker
- Docker Compose

## Usage

```bash
# Run locally (always rebuilds image)
dup

# Skip rebuild if image already exists
dup --skip-build
```

## API

| Method | Endpoint | Description  |
|--------|----------|--------------|
| GET    | /        | Status check |
| GET    | /health  | Health check |

## Development

```bash
# Push changes to GitHub and Docker Hub
./upload
```

## Docker Hub

Image: [superkeyor/dockerapp_template](https://hub.docker.com/r/superkeyor/dockerapp_template)

```bash
docker pull superkeyor/dockerapp_template:latest
```

## License

[AGPLv3](LICENSE) © 2026 superkeyor
