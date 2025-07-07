# LibraryManagement - Dependency Injection with Spring

## Overview
This project demonstrates the implementation of dependency injection (DI) using the Spring Framework in a simple library management application. It focuses on managing dependencies between the `BookService` and `BookRepository` classes through Spring's Inversion of Control (IoC) container. This assignment builds on a prior setup but stands alone as a console-based showcase of Spring DI principles.

## Files
- **`MainApp.java`**  
  Located in the `com.library` package, this is the main entry point. It initializes the Spring application context using `ClassPathXmlApplicationContext` to load `applicationContext.xml`. It retrieves the `BookService` bean and invokes its `addBook` method with "Clean Code".

- **`BookService.java`**  
  Located in the `com.library.service` package, this class depends on `BookRepository`. It includes a setter method (`setBookRepository`) to enable Spring to inject the `BookRepository` dependency. The `addBook` method outputs a message and delegates to `BookRepository`ΓÇÖs `saveBook` method.

- **`BookRepository.java`**  
  Located in the `com.library.repository` package, this class simulates book persistence. Its `saveBook` method prints a confirmation message when a book is saved.

- **`applicationContext.xml`**  
  Located in `src/main/resources`, this configuration file defines the `BookService` and `BookRepository` beans. It uses setter injection to wire `BookRepository` into `BookService`, showcasing Spring's DI capabilities.

- **`pom.xml`**  
  The Maven configuration file (assumed in the project root) includes dependencies for Spring Core libraries, enabling the project to leverage Spring functionality.

## Configuration
The Spring IoC container is configured via `applicationContext.xml`. This file declares two beans: `bookService` (of type `BookService`) and `bookRepository` (of type `BookRepository`). The `bookService` bean uses a `<property>` tag to inject `bookRepository` via the setter method, ensuring loose coupling and dependency management.

## Running the Application
To execute the application:
1. Ensure Java and Maven are installed on your system.
2. Build the project with `mvn clean install`.
3. Run the `MainApp` class (e.g., via an IDE or command line).

## Expected Output
Upon running, the console will display:
```
Adding book: Clean Code
Book saved: Clean Code
```
This output verifies that dependency injection is working correctly, with `BookService` successfully utilizing the injected `BookRepository`.
