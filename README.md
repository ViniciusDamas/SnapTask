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

## Tech Stack (Planned)

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
