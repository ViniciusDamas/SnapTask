# Use Cases

This table maps primary use cases to endpoints and auth requirements.

## Auth

| Use Case | Endpoint | Auth |
|---|---|---|
| Register | `POST /auth/register` | No |
| Login | `POST /auth/login` | No |
| Get current user | `GET /auth/me` | Yes |

## Boards

| Use Case | Endpoint | Auth |
|---|---|---|
| Create board | `POST /api/boards` | Yes |
| Get all boards | `GET /api/boards` | Yes |
| Get board details | `GET /api/boards/{id}` | No |
| Update board | `PUT /api/boards/{id}` | No |
| Delete board | `DELETE /api/boards/{id}` | No |

## Columns

| Use Case | Endpoint | Auth |
|---|---|---|
| Create column | `POST /api/columns` | No |
| Get column details | `GET /api/columns/{id}` | No |
| Update column | `PUT /api/columns/{id}` | No |
| Delete column | `DELETE /api/columns/{id}` | No |

## Cards

| Use Case | Endpoint | Auth |
|---|---|---|
| Create card | `POST /api/cards` | No |
| Get card details | `GET /api/cards/{id}` | No |
| Update card | `PUT /api/cards/{id}` | No |
| Delete card | `DELETE /api/cards/{id}` | No |
