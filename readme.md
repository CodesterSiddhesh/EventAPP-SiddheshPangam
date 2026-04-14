# Event Management System


## Project Structure

```text
app/
├── Http/
│   ├── Controllers/API
│   ├── Requests
│   └── Resources
├── Models
├── Repositories
├── Services
```

---

## Installation Instructions

### 1. Clone Repository

```bash
git clone <repository-url>
cd EventAPP-SiddheshPangam/backend
```

### 2. Install Dependencies

```bash
composer install
```

### 3. Create Environment File

```bash
cp .env.example .env
```

### 4. Generate Application Key

```bash
php artisan key:generate
```

### 5. Configure Database

Update `.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=event_management
DB_USERNAME=root
DB_PASSWORD=
```

### 6. Run Database Migrations & Seeders

```bash
php artisan migrate:fresh --seed
```

### 7. Start Development Server

```bash
php artisan serve
```

Application available at:

```text
http://127.0.0.1:8000
```

---

## Demo Credentials

### Admin User

```text
Email: admin@example.com
Password: password
```

---

## API Endpoints

### Authentication APIs

| Method | Endpoint | Description |
|--------|---------|-------------|
| POST | `/api/auth/register` | Register User |
| POST | `/api/auth/login` | Login User |
| POST | `/api/auth/logout` | Logout User |

---

### Event APIs

| Method | Endpoint | Access | Description |
|--------|---------|--------|-------------|
| GET | `/api/events` | Public | List Events |
| GET | `/api/events/{id}` | Public | View Event |
| POST | `/api/events` | Admin | Create Event |
| PUT | `/api/events/{id}` | Admin | Update Event |
| DELETE | `/api/events/{id}` | Admin | Delete Event |

---

## Filtering & Pagination

### Example

```http
GET /api/events?search=conference&from=2026-05-01
```

| Parameter | Description |
|----------|-------------|
| search | Search by title/location |
| from | Filter events after date |

---

## Running Tests

```bash
php artisan test
```

---