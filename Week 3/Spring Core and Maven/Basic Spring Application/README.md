# LibraryManagement - Spring Framework Configuration

## Overview
This project sets up the backend operations for a library management system using the Spring Framework. It demonstrates basic Spring configuration with XML-based dependency injection. Currently, it is a console application that showcases how to wire beans and manage dependencies.

## Files
- **`MainApp.java`**  
  Located in the `com.library` package, this is the entry point of the application. It initializes the Spring application context by loading `applicationContext.xml` from the classpath using `ClassPathXmlApplicationContext`. It retrieves the `BookService` bean and calls its `addBook` method with the title "Spring in Action".

- **`BookService.java`**  
  Located in the `com.library.service` package, this service class depends on `BookRepository`. It includes a setter method (`setBookRepository`) for injecting the `BookRepository` dependency. The `addBook` method prints a message indicating that a book is being added and then calls the `saveBook` method of `BookRepository`.

- **`BookRepository.java`**  
  Located in the `com.library.repository` package, this repository class simulates the persistence of a book. It has a `saveBook` method that prints a message indicating that the book has been saved.

- **`applicationContext.xml`**  
  Located in `src/main/resources`, this XML file (assumed to be correctly implemented per the assignment) defines the beans for `BookService` and `BookRepository`. It configures dependency injection by wiring `BookRepository` into `BookService` using setter injection.

- **`pom.xml`**  
  The Maven configuration file (assumed to be present in the project root) manages the project dependencies, including the Spring Core libraries as specified in the assignment.

## Configuration
The Spring application context is configured using `applicationContext.xml`. This file defines beans for `BookService` and `BookRepository`. The `BookService` bean is configured to have its `bookRepository` property set to the `BookRepository` bean, demonstrating dependency injection via setter injection.

## Running the Application
To run the application:
1. Ensure Java and Maven are installed.
2. Build the project using `mvn clean install`.
3. Execute the `MainApp` class (e.g., through an IDE or by running the compiled class from the command line).

## Expected Output
When the application is run, it will produce the following output in the console:
```
Adding book: Spring in Action
Book saved: Spring in Action
```
This output confirms that the `BookService` is correctly wired with `BookRepository` and that the method calls are executed as expected.
