# freya-deploy

Deployment repo for the shared edge stack and individual project stacks.

## Compose files

- `compose.yaml`: shared edge stack with `nginx-proxy`, `acme-companion`, and the `freya-proxy` network
- `compose.personal-page.yaml`: `personal-page`
- `compose.typoracer-community.yaml`: `typoracer-community` and its Postgres database
- `compose.what-i-know-api.yaml`: `what-i-know-api` and its Postgres database

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

The proxy stack creates the shared `freya-proxy` network. Each public-facing app joins that network so `nginx-proxy` and `acme-companion` can discover it across compose projects.

Using explicit project names keeps the edge stack and each app stack separate, which avoids orphan-container warnings when deploying a single project.
