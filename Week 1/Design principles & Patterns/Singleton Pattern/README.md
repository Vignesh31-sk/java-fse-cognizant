# Singleton Pattern Implementation

This Java application demonstrates the implementation of the Singleton design pattern using a Logger class.

## Overview

The Singleton pattern is a creational design pattern that ensures a class has only one instance and provides a global point of access to that instance. This is useful when exactly one object is needed to coordinate actions across the system.

## Implementation Details

### Logger Class

The `Logger` class in this project implements the Singleton pattern with the following characteristics:

- A private static variable `instance` that holds the single instance of the Logger
- A private constructor to prevent instantiation from outside the class
- A public static method `getInstance()` that returns the single instance (creating it if it doesn't exist)
- A `log()` method to demonstrate the functionality of the Logger

### Key Components

```java
class Logger {
    // Private static variable to hold the single instance
    private static Logger instance;
    
    // Private constructor
    private Logger() { ... }
    
    // Public static method to get the instance
    public static Logger getInstance() { ... }
    
    // Functionality method
    public void log(String message) { ... }
}
```

### Test Implementation

The `App` class contains a `main` method that tests the Singleton implementation by:

1. Getting two instances of the Logger using `getInstance()`
2. Verifying that both references point to the same object (confirming the Singleton property)
3. Demonstrating the Logger functionality by logging messages

## Expected Output

When you run this application, you should see output similar to the following:

```
Testing Singleton Pattern with Logger class
Logger instance created
Singleton works! Both variables contain the same instance.
LOG: This is a log message from logger1
LOG: This is a log message from logger2
```

Note that "Logger instance created" appears only once, confirming that only one instance is created.