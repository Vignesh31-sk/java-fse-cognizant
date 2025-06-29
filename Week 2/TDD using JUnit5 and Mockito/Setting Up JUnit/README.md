# Setting Up JUnit for Unit Testing in Java

## Overview

This assignment demonstrates how to set up JUnit in a Java project to write unit tests. JUnit is a widely used testing framework for Java applications, and it allows developers to write and run repeatable tests to ensure their code works as expected. The goal of this assignment is to help you set up JUnit in your project and write basic unit tests to validate the functionality of your code.

1. Set up JUnit in your Java project using a build tool (Maven or Gradle).
2. Write your first unit tests using JUnit.
3. Run the tests and analyze the results.

## Steps for Setting Up JUnit

### 1. Setting Up JUnit with Maven

If you're using **Maven** to manage your project dependencies, follow these steps:

1. Open your `pom.xml` file.
2. Add the following dependency for JUnit:

   ```xml
   <dependencies>
       <!-- JUnit 4 Dependency -->
       <dependency>
           <groupId>junit</groupId>
           <artifactId>junit</artifactId>
           <version>4.13.2</version>
           <scope>test</scope>
       </dependency>
   </dependencies>

### 2. Writting unit cases.

create a class that contains the methods you want to test.

```java
public class Calculator {

    // Method to add two numbers
    public int add(int a, int b) {
        return a + b;
    }

    // Method to subtract two numbers
    public int subtract(int a, int b) {
        return a - b;
    }
}
```

Next, create a test class that contains your unit tests. The test class should be located in the src/test/java/com/example/ directory (standard for Maven and Gradle projects).


```java
import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class CalculatorTest {

    @Test
    public void testAdd() {
        Calculator calculator = new Calculator();
        int result = calculator.add(2, 3);
        assertEquals(5, result); // This will pass if the addition is correct
    }

    @Test
    public void testSubtract() {
        Calculator calculator = new Calculator();
        int result = calculator.subtract(5, 3);
        assertEquals(2, result); // This will pass if the subtraction is correct
    }
}
```


### 3. Running tests.

```powershell
mvn test
```

### 4. Interpreting Test Results
After running the tests, you will see one of the following outcomes:

- `Green bar`: All tests have passed successfully.

- `Red bar`: One or more tests have failed. Review the error messages to debug and fix the issues.

```yaml
-------------------------------------------------------
 T E S T S
-------------------------------------------------------
Running CalculatorTest
Tests run: 2, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.051 sec
Results : SUCCESS
```
