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
docker compose up -d
```

Deploy a single project without touching the others:

```powershell
docker compose -f compose.personal-page.yaml pull
docker compose -f compose.personal-page.yaml up -d
```

```powershell
docker compose -f compose.typoracer-community.yaml pull
docker compose -f compose.typoracer-community.yaml up -d
```

```powershell
docker compose -f compose.what-i-know-api.yaml pull
docker compose -f compose.what-i-know-api.yaml up -d
```

The proxy stack creates the shared `freya-proxy` network. Each public-facing app joins that network so `nginx-proxy` and `acme-companion` can discover it across compose projects.
