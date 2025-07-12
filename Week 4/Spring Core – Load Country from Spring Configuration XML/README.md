# SpringLearn Airlines Country Bean Assignment

## Assignment Description

This Spring Boot application demonstrates how to use a Spring XML configuration file to define a bean for a country, and how to read and display its details using Spring's ApplicationContext. The scenario is for an airlines website that supports booking in four countries, each identified by a two-character ISO code.

### Countries Supported
| Code | Name           |
|------|----------------|
| US   | United States  |
| DE   | Germany        |
| IN   | India          |
| JP   | Japan          |

The country bean is configured for India (IN) in this example.

## Implementation Steps

1. **Country Bean Configuration**
   - The `country.xml` file in `src/main/resources` defines a bean for the country with code `IN` and name `India`.

2. **Country Class**
   - Contains `code` and `name` fields, with debug logging in the constructor, getters, and setters.

3. **SpringLearnApplication**
   - The `displayCountry()` method loads the country bean from `country.xml` and logs its details at DEBUG level.
   - The method is called from `main()`.

4. **Logging Configuration**
   - The `application.properties` file sets the log level for `com.cognizant.spring_learn` to DEBUG so that all debug messages are visible in the console.

## How to Run

1. Build and run the application using your IDE or with Maven:
   ```bash
   ./mvnw spring-boot:run
   ```
2. Observe the console output. You should see:
   - `Welcome to Spring Boot Application` (from `System.out.println`)
   - Debug log messages showing the country bean details and method invocations.

## Expected Output

```
Welcome to Spring Boot Application
250712|12:34:56.789|main                |DEBUG|SpringLearnApplication   |displayCountry         |Country : Country [code=IN, name=India]
```

You will also see additional debug logs from the `Country` class, such as:

```
250712|12:34:56.789|main                |DEBUG|Country                  |<init>                 |Inside Country Constructor.
250712|12:34:56.790|main                |DEBUG|Country                  |setCode                |Setting code: IN
250712|12:34:56.790|main                |DEBUG|Country                  |setName                |Setting name: India
250712|12:34:56.791|main                |DEBUG|Country                  |toString               |Country [code=IN, name=India]
```

## Notes

- If you do not see the debug logs, ensure your `application.properties` contains:
  ```
  logging.level.com.cognizant.spring_learn=DEBUG
  ```
- The log format may vary depending on your configuration.