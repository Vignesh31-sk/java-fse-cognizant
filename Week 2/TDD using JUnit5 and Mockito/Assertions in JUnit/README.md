# JUnit Assertions Assignment

## Overview

This assignment demonstrates how to use different assertions in JUnit to validate test results. JUnit is a widely used testing framework in Java, and it provides several assertion methods that allow you to verify whether the results of your code behave as expected.

In this project, we have a `Calculator` class with basic arithmetic operations (addition, subtraction, multiplication, division) and two methods that return `null` and a non-`null` object. The tests are designed to validate these methods using different JUnit assertion methods like `assertEquals`, `assertTrue`, `assertFalse`, `assertNull`, and `assertNotNull`.

## Project Structure

The project consists of two main files:

1. **Calculator.java** - This class contains basic arithmetic methods and two methods that return `null` or a non-`null` object.
2. **CalculatorTests.java** - This file contains JUnit test cases that use different assertion methods to validate the results from the `Calculator` class.

## Classes

### 1. Calculator.java

This class contains the following methods:

- **add(int a, int b)**: Returns the sum of `a` and `b`.
- **subtract(int a, int b)**: Returns the difference between `a` and `b`.
- **multiply(int a, int b)**: Returns the product of `a` and `b`.
- **divide(int a, int b)**: Returns the quotient of `a` divided by `b`.
- **getNull()**: Returns `null`.
- **getNotNull()**: Returns a new `Object`.

### 2. CalculatorTests.java

This class contains the following test methods that utilize various JUnit assertions:

- **testAdd()**: Verifies that the `add()` method correctly returns the sum of two integers using `assertEquals()`.
- **testAssertTrue()**: Validates a condition using `assertTrue()` that the addition of two integers results in 2.
- **testAssertFalse()**: Verifies that the result of adding two integers is not equal to 5 using `assertFalse()`.
- **testAssertNull()**: Ensures that the method `getNull()` returns `null` using `assertNull()`.
- **testAssertNotNull()**: Confirms that the method `getNotNull()` does not return `null` using `assertNotNull()`.

## Assertions Used

1. **assertEquals(expected, actual)**:
   - Used to check if two values are equal.
   - In `testAdd()`, we check if the result of the `add()` method is equal to the expected sum.

2. **assertTrue(condition)**:
   - Validates that the given condition is true.
   - In `testAssertTrue()`, we verify that the sum of `1 + 1` is indeed equal to 2.

3. **assertFalse(condition)**:
   - Ensures that the given condition is false.
   - In `testAssertFalse()`, we check that `2 + 2` is not equal to 5.

4. **assertNull(object)**:
   - Confirms that the provided object is `null`.
   - In `testAssertNull()`, we verify that the method `getNull()` returns `null`.

5. **assertNotNull(object)**:
   - Ensures that the provided object is not `null`.
   - In `testAssertNotNull()`, we verify that the method `getNotNull()` does not return `null`.

## How to Run

1. **Set Up Your Environment**:
   - Ensure you have Java and JUnit installed.
   - You can use an IDE like IntelliJ IDEA or Eclipse, or you can run the tests through the command line.

2. **Run the Tests**:
   - In your IDE, right-click the `CalculatorTests.java` file and select "Run."
   - Alternatively, if you're using Maven or Gradle, run the following commands:
     - For Maven: `mvn test`
     - For Gradle: `gradle test`

## Conclusion

By completing this assignment, you'll gain hands-on experience with various JUnit assertions. Assertions are a powerful way to validate that your code behaves as expected. This foundation can be applied to more complex unit testing scenarios in larger Java applications.
