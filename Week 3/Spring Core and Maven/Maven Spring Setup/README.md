# LibraryManagement - Maven Project Setup with Spring

## Overview
This project demonstrates the setup of a Maven project named `LibraryManagement` for a library management application integrated with the Spring Framework. It includes essential Spring dependencies and is configured to use Java 1.8. The project provides a foundation for further development and includes a test class to verify the configuration.

## Files
- **`pom.xml`**  
  The Maven configuration file that manages project dependencies and build settings. It includes dependencies for Spring Context, Spring AOP, and Spring WebMVC, along with the Maven Compiler Plugin configured for Java 1.8.

- **`TestApp.java`**  
  Located in the `com.library` package, this is a simple test class that prints a message to the console, confirming that the Maven project and Spring setup are working correctly.

## Configuration
The `pom.xml` file is the core of this project’s configuration:
- **Dependencies**: 
  - `spring-context`: Provides core Spring features such as dependency injection.
  - `spring-aop`: Enables aspect-oriented programming capabilities.
  - `spring-webmvc`: Supports building web applications using Spring MVC.
- **Maven Compiler Plugin**: Configured to use Java 1.8 for both source and target compatibility.

## Running the Application
To build and run the application:
1. Ensure Maven is installed on your system.
2. Open a terminal and navigate to the project root directory.
3. Run `mvn clean install` to build the project.
4. Execute the `TestApp` class by running `java -cp target/classes com.library.TestApp` from the command line, or use an IDE to run it directly.

## Expected Output
When you run the `TestApp`, the console should display:
```
Spring Maven setup is working!
```
This output confirms that the Maven project is correctly configured and that the Spring dependencies are properly included.