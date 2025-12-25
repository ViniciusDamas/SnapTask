# SnapTask

SnapTask is a full-stack task board project inspired by tools like Trello and Miro.
The goal of this project is to build a clean and extensible task management system
with a drag-and-drop workflow, backed by a .NET API and a Flutter mobile application.

This repository is being developed incrementally, following a milestone-based
approach to reflect a real-world software development process.

---

## Project Goals

- Provide a backend API to manage boards, columns and cards
- Support ordered and movable tasks (drag-and-drop friendly)
- Serve as a learning and portfolio project with production-oriented practices

---

## Tech Stack

### Backend
- ASP.NET Core (.NET 10)
- Entity Framework Core
- PostgreSQL
- Docker & Docker Compose

### Frontend (planned)
- Flutter (mobile)

---

## Project Structure

This repository is organized as a monorepo:

```text
snaptask/
├── backend/
├── frontend/
└── docs/
```

---

## Running the Backend API (Development)

### Prerequisites

- .NET SDK 10
- Docker & Docker Compose

### 1. Start PostgreSQL (Docker)

From the repository root:

```bash
docker compose up -d db
```

This starts a PostgreSQL container exposed on `localhost:5432`.

### 2. Configure database connection (local development)

Create the following file (not committed to git):

`backend/SnapTaskApi/appsettings.Development.json`

With the following content:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=snaptask;Username=postgres;Password=postgres"
  }
}
```

This file is ignored by git and used only for local development.

### 3. Apply database migrations

From the API project directory:

```bash
cd backend/SnapTaskApi
dotnet ef database update
```

This will create all required database tables.

### 4. Run the API locally

```bash
dotnet run
```

The API will be available at:

```
http://localhost:8080
```

### Optional: Run API and database using Docker

Create a `.env` file based on `.env.example` and then run:

```bash
docker compose up -d --build
```

### Notes

- Database schema is managed via Entity Framework Core migrations.
- On the first run, migrations must be applied before accessing the API.
- When running inside Docker, the PostgreSQL host is `db`, not `localhost`.

---

## Roadmap

- Core domain entities (Board, Column, Card)
- Persistence layer with EF Core and PostgreSQL
- REST endpoints
- Authentication
- Drag-and-drop support
- Flutter mobile client
