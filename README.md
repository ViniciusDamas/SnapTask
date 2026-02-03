# SnapTask

SnapTask is a full‑stack task board application inspired by tools like Trello. It focuses on a clean, extensible backend and a Flutter client, with a use‑case driven architecture, JWT auth, and a testable API surface for boards, columns, and cards.

## Highlights

- Clean Architecture with clear separation of domain, use cases, and infrastructure
- REST API for boards, columns, and cards
- JWT authentication with ASP.NET Identity
- ProblemDetails for standardized API errors
- Integration tests using `WebApplicationFactory`
- Dockerized PostgreSQL for local development
- Flutter client with theming, routing, and auth flow (in progress)

## Tech Stack

Backend
- ASP.NET Core (.NET 10)
- Entity Framework Core
- PostgreSQL
- ASP.NET Identity + JWT

Frontend
- Flutter web

Tooling
- Docker and Docker Compose
- xUnit + FluentAssertions

## Repository Structure

```text
SnapTask/
├── backend/
│   └── SnapTaskApi/
├── frontend/
│   └── snaptask_app/
├── tests/
│   └── SnapTaskApi.IntegrationTests/
└── README.md
```

## Backend Architecture

```text
SnapTaskApi/
├── Domain/            # Entities and domain rules
├── Application/       # Use cases
├── Infrastructure/    # EF Core, repositories
├── WebApi/            # Controllers + contracts
└── Program.cs
```

## API Overview

Auth
- `POST /auth/register`
- `POST /auth/login`
- `GET /auth/me`

Boards
- `POST /api/boards`
- `GET /api/boards`
- `GET /api/boards/{id}`
- `PUT /api/boards/{id}`
- `DELETE /api/boards/{id}`

Columns
- `POST /api/columns`
- `GET /api/columns/{id}`
- `PUT /api/columns/{id}`
- `DELETE /api/columns/{id}`

Cards
- `POST /api/cards`
- `GET /api/cards/{id}`
- `PUT /api/cards/{id}`
- `DELETE /api/cards/{id}`

## Running the Backend (Development)

Prerequisites
- .NET SDK 10
- Docker and Docker Compose

1. Start PostgreSQL

```bash
docker compose up -d db
```

2. Configure connection string

Create `backend/SnapTaskApi/appsettings.Development.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=snaptask;Username=postgres;Password=postgres"
  }
}
```

3. Apply migrations

```bash
cd backend/SnapTaskApi
dotnet ef database update
```

4. Run the API

```bash
dotnet run
```

Default URLs (from `backend/SnapTaskApi/Properties/launchSettings.json`)
- `http://localhost:5187`
- `https://localhost:7140`

## Running with Docker

```bash
docker compose up -d --build
```

When running inside Docker, the API uses ports `8080` (HTTP) and `8081` (HTTPS), and the database host is `db`.

## Tests

Integration tests live in `tests/SnapTaskApi.IntegrationTests` and run against an in‑memory EF Core database under the `Testing` environment. Test JWT defaults are injected automatically for test runs.

Run all tests:

```bash
dotnet test
```

Debug a single test (waits for debugger attach):

```powershell
$env:VSTEST_HOST_DEBUG=1
dotnet test --filter "FullyQualifiedName=SnapTaskApi.IntegrationTests.Boards.CreateBoardTests.POST_create_board_returns_201_and_board_payload" --framework net10.0 --no-build
```

## Frontend (Flutter)

Current status
- Global theming
- Routing and navigation shell
- HTTP client with interceptors
- Authentication flow
- Boards listing screen

Architecture (feature‑first)

```text
lib/
├── app/
│   ├── router/
│   ├── routes/
│   ├── theme/
│   └── shell/
├── core/
│   ├── http/
│   └── storage/
└── features/
    ├── auth/
    └── boards/
```

## Roadmap

- Column move endpoint
- Drag‑and‑drop ordering for columns and cards
- Card details screen in Flutter
- Board details screen in Flutter
- State management expansion (Riverpod or BLoC)

## License

This project is intended for educational and portfolio purposes.
