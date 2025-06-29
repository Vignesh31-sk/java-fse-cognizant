# JUnit Testing with Arrange-Act-Assert (AAA) Pattern and Setup/Teardown

## Overview

This assignment demonstrates how to organize unit tests using the **Arrange-Act-Assert (AAA)** pattern, as well as how to use JUnit's **@Before** and **@After** annotations for setup and teardown methods. The goal is to write clear and well-structured tests, and ensure that each test is independent and well-prepared using these features.

In this project, we have a `Calculator` class, and various test methods are written using the AAA pattern. Additionally, the `@Before` and `@After` annotations ensure that setup and teardown actions occur before and after each test.

## Project Structure

The project contains the following components:

1. **Calculator.java** - This class contains the basic arithmetic methods.
2. **CalculatorTests.java** - This class contains the unit tests that use the AAA pattern for organization, and setup and teardown methods to prepare the test environment.

## Classes

### 1. Calculator.java

The `Calculator` class contains the following arithmetic methods:

- **add(int a, int b)**: Returns the sum of `a` and `b`.
- **subtract(int a, int b)**: Returns the difference between `a` and `b`.
- **multiply(int a, int b)**: Returns the product of `a` and `b`.
- **divide(int a, int b)**: Returns the quotient of `a` divided by `b`.

### 2. CalculatorTests.java

This class contains the following tests, which use the **Arrange-Act-Assert (AAA)** pattern:

- **testAdd_PositiveNumbers()**: 
  - **Arrange**: Prepare the input values (2 and 3).
  - **Act**: Call the `add()` method.
  - **Assert**: Verify that the result is 5.

- **testAdd_NegativeNumbers()**: 
  - **Arrange**: Prepare the input values (-2 and -3).
  - **Act**: Call the `add()` method.
  - **Assert**: Verify that the result is -5.

- **testAdd_PositiveAndNegative()**: 
  - **Arrange**: Prepare the input values (5 and -3).
  - **Act**: Call the `add()` method.
  - **Assert**: Verify that the result is 2.

- **testAdd_WithZero()**: 
  - **Arrange**: Prepare the input values (0 and 7).
  - **Act**: Call the `add()` method.
  - **Assert**: Verify that the result is 7.

### Setup and Teardown

- **@Before Annotation**: The `setUp()` method is annotated with `@Before`, which is executed before each test. It initializes the `Calculator` object to ensure that the tests run on a fresh instance.
  
- **@After Annotation**: The `tearDown()` method is annotated with `@After`, which is executed after each test. It ensures that the `Calculator` instance is nullified, cleaning up any resources.

## Arrange-Act-Assert (AAA) Pattern

The **AAA** pattern is a clear and structured approach to writing tests. It consists of the following steps:

1. **Arrange**: Set up the necessary conditions for the test (e.g., input values, objects).
2. **Act**: Execute the method under test.
3. **Assert**: Verify that the expected result has been achieved.
