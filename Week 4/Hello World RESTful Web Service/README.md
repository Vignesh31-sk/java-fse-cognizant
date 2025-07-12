# SpringLearn REST Hello World Assignment

This assignment demonstrates how to create a simple REST service using Spring Boot and Spring Web.

## Task

- Implement a REST endpoint that returns the text `Hello World!!`.
- Log the start and end of the controller method using SLF4J.
- The service should be accessible at: `http://localhost:8083/hello`

## Implementation Details

- **Controller:** `com.cognizant.spring_learn.controller.HelloController`
- **Method:** `public String sayHello()`
- **HTTP Method:** GET
- **URL:** `/hello`
- **Response:** `Hello World!!`
- **Logging:** Logs start and end of the method
- **Port:** 8083 (configured in `application.properties`)

## How to Run

1. Build and run the application using your IDE or with Maven:
   ```bash
   ./mvnw spring-boot:run
   ```
2. Open your browser or Postman and go to: [http://localhost:8083/hello](http://localhost:8083/hello)
3. You should see:
   ```
   Hello World!!
   ```
4. Check the console for logs:
   ```
   ...INFO...START: sayHello() method
   ...INFO...END: sayHello() method
   ```

## How to View HTTP Headers

- **In Chrome:**
  1. Open Developer Tools (F12) > Network tab
  2. Access `/hello` endpoint
  3. Click the request and view the "Headers" section
- **In Postman:**
  1. Send a GET request to `/hello`
  2. Click the "Headers" tab in the response section

## Sample Output

**Response:**
```
Hello World!!
```

**Console Logs:**
```
...INFO...START: sayHello() method
...INFO...END: sayHello() method
```