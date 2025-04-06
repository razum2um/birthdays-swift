# Birthdays API (Swift + Vapor)

A simple RESTful API built with [Vapor](https://vapor.codes) and Swift that lets users store their date of birth and retrieve how many days remain until their next birthday.

## Features

- **Save Birthdays**: Store a user's birthday by username.
- **Next Birthday Countdown**: Return how many days until their next birthday.
- **Minimal and Fast**: Lightweight implementation using Swift and Vapor.
- **Easy to Extend**: Add auth, database, or more endpoints if needed.

## API Overview

### Set a Birthday

**Request:**

```
PUT /hello/:username
Content-Type: application/json
```

**Body:**

```json
{ "dateOfBirth": "YYYY-MM-DD" }
```

**Example:**

```bash
curl -X PUT http://localhost:8080/hello/alice \
  -H "Content-Type: application/json" \
  -d '{"dateOfBirth": "1990-05-01"}'
```

### Get Days Until Next Birthday

**Request:**

```
GET /hello/:username
```

**Response:**

- If today is not the user's birthday:

```json
{ "message": "Hello, alice! Your birthday is in 120 day(s)." }
```

- If today *is* the user's birthday:
```json
{ "message": "Hello, alice! Happy birthday!" }
```

**Example:**

```bash
curl http://localhost:8080/hello/alice
```

## Running Locally

1. Clone the repo:

```bash
git clone https://github.com/your-org/birthdays-vapor.git
cd birthdays-vapor
```

2. Fix values in `.envrc` and run:

```bash
source .envrc
swift run BirthdaysSwift migrate
swift run
```

3. The server will start at `http://localhost:8080`.

## Implementations in Other Languages

This project is inspired by [RealWorld](https://realworld-docs.netlify.app/) — the "mother of all demos" for full-stack apps — where the same app is built in many languages and stacks to serve as a reference and learning tool.

This project is designed to be small, clear, and easily implemented in other languages or frameworks, currently also written in:

- [Rust](https://github.com/razum2um/birthdays)
- [Clojure](https://github.com/razum2um/birthdays-clj)

## TODOs

- Refactor: extract reusable views and response logic
- Add unit and integration tests
- Improve validation and error handling
- Add logging middleware
- Add OpenAPI (Swagger) documentation

## License

This project is licensed under the MIT License.
