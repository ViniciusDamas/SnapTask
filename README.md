# SnapTask

SnapTask is a **full‑stack task board application** inspired by tools like **Trello** and **Miro**. The project focuses on building a clean, extensible, and production‑oriented task management system with ordered boards, columns, and cards, designed to support drag‑and‑drop workflows.

This repository is developed **incrementally**, following a **milestone‑based approach** that mirrors real‑world software development.

---

## Project Goals

* Provide a backend API to manage **Boards**, **Columns**, and **Cards**
* Support **ordered and movable tasks** (drag‑and‑drop friendly)
* Apply **Clean Architecture** and **use‑case driven design**
* Serve as a **learning and portfolio project** with production‑oriented practices

---

## Tech Stack

### Backend

* **ASP.NET Core (.NET 10)**
* **Entity Framework Core**
* **PostgreSQL**
* **ASP.NET Identity** (authentication)
* **Docker & Docker Compose**

### Frontend (in progress)

* **Flutter** (Mobile + Web)
* Modular, feature‑based architecture
* REST API consumption
* Authentication flow (login/logout)

---

## Project Structure (Monorepo)

```text
snaptask/
├── backend/
│   └── SnapTaskApi/
├── frontend/
│   └── snaptask_app/
├── docs/
└── README.md
```

---

## Backend Architecture (Clean Architecture – simplified)

```text
SnapTaskApi/
├── Domain/            # Entities and core domain rules
├── Application/       # Use cases (Commands / Queries)
├── Infrastructure/    # EF Core, repositories, migrations
├── Api/               # Controllers and HTTP contracts
└── Program.cs
```

### Implemented Domain Entities

* **Board**
* **Column**
* **Card**

Each entity supports ordering to enable future drag‑and‑drop operations.

### Implemented Use Cases

* Boards: Create, Get All, Get By Id (with details), Update, Delete
* Columns: Create, Get By Id (with cards), Update, Delete
* Cards: Create, Order handling, Delete

### API Controllers

* `BoardsController`
* `ColumnsController`
* `AuthController`

---

## Frontend (Flutter)

The frontend is under active development and already includes:

### Implemented

* Global app theming (Light / Dark)
* Centralized routing
* HTTP client with interceptors
* Authentication API integration
* Login screen (functional)
* Boards listing screen (API‑driven)

### Frontend Architecture

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
    │   ├── data/
    │   └── ui/
    └── boards/
        ├── data/
        └── ui/
```

The structure follows a **feature‑first approach**, keeping UI, data access, and models grouped by feature.

---

## Running the Backend API (Development)

### Prerequisites

* .NET SDK 10
* Docker & Docker Compose

### 1. Start PostgreSQL (Docker)

From the repository root:

```bash
docker compose up -d db
```

PostgreSQL will be exposed on `localhost:5432`.

---

### 2. Configure database connection

Create the file (not committed to git):

```text
backend/SnapTaskApi/appsettings.Development.json
```

With the following content:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Host=localhost;Port=5432;Database=snaptask;Username=postgres;Password=postgres"
  }
}
```

---

### 3. Apply database migrations

```bash
cd backend/SnapTaskApi
dotnet ef database update
```

---

### 4. Run the API

```bash
dotnet run
```

API will be available at:

```
http://localhost:8080
```

---

## Optional: Run API + Database with Docker

```bash
docker compose up -d --build
```

> When running inside Docker, the PostgreSQL host is `db`, not `localhost`.

---

## Screenshots & Demo

> *(Placeholders – to be updated)*

```text
[ GIF / Screenshot – Login Screen ]

[ GIF / Screenshot – Boards List ]

[ GIF / Screenshot – Board with Columns & Cards ]
```

---

## Roadmap

* ✅ Core domain entities (Board, Column, Card)
* ✅ Persistence with EF Core + PostgreSQL
* ✅ REST API (Boards & Columns)
* ✅ Authentication (ASP.NET Identity)
* 🚧 Drag‑and‑drop ordering (Columns & Cards)
* 🚧 Card CRUD endpoints
* 🚧 Flutter board details screen
* 🚧 Drag‑and‑drop UI (Flutter)
* 🚧 State management (Riverpod / BLoC)

---

## Notes

* Database schema is managed via **EF Core migrations**
* Migrations must be applied before first API run
* This project is intentionally evolving step‑by‑step to reflect real‑world development

---

## 📄 License

This project is intended for educational and portfolio purposes.
