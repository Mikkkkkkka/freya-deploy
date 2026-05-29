# freya-deploy

Deployment repo for the shared edge stack and individual project stacks.

## Compose files

- `compose.yaml`: shared edge stack with `nginx-proxy`, `acme-companion`, and the `freya-proxy` network
- `compose.personal-page.yaml`: `personal-page`
- `compose.typoracer-community.yaml`: `typoracer-community` and its Postgres database
- `compose.what-i-know-api.yaml`: `what-i-know-api` and its Postgres database
- `compose.minecraft-mods.yaml`: static Minecraft mods archive storage

## Typical workflow

Start or update the shared edge stack first:

```powershell
docker compose -p freya-edge up -d
```

Deploy a single project without touching the others:

```powershell
docker compose -p personal-page -f compose.personal-page.yaml pull
docker compose -p personal-page -f compose.personal-page.yaml up -d
```

```powershell
docker compose -p typoracer-community -f compose.typoracer-community.yaml pull
docker compose -p typoracer-community -f compose.typoracer-community.yaml up -d
```

```powershell
docker compose -p what-i-know-api -f compose.what-i-know-api.yaml pull
docker compose -p what-i-know-api -f compose.what-i-know-api.yaml up -d
```

```powershell
docker compose -p minecraft-mods -f compose.minecraft-mods.yaml pull
docker compose -p minecraft-mods -f compose.minecraft-mods.yaml up -d
```

Put archives and optional metadata into `MINECRAFT_MODS__FILES_PATH`, for example:

```text
/srv/freya/minecraft-mods/
  mods-latest.zip
  mods-2026-05-30.zip
  manifest.json
```

The proxy stack creates the shared `freya-proxy` network. Each public-facing app joins that network so `nginx-proxy` and `acme-companion` can discover it across compose projects.

Using explicit project names keeps the edge stack and each app stack separate, which avoids orphan-container warnings when deploying a single project.
