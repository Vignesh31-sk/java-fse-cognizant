# Mockito Testing Examples

This project demonstrates comprehensive Mockito usage for testing services that depend on external APIs and verifying method interactions.

## Overview

This project implements the following requirements:

### 1. Testing a Service with External API Dependencies
- **Mock External API**: Create mock objects for external API services
- **Stub Methods**: Configure mock methods to return predefined values
- **Test Service Logic**: Write test cases that use mock objects to test business logic

### 2. Verifying Method Calls with Specific Arguments
- **Create Mock Objects**: Set up mock instances for testing
- **Call Methods**: Invoke methods with specific arguments
- **Verify Interactions**: Confirm that methods were called with expected arguments

## Project Structure

```
src/
├── main/java/com/example/
│   ├── ExternalApiService.java      # Interface for external API
│   ├── User.java                    # User model class
│   ├── UserService.java             # Service that depends on external API
│   ├── App.java                     # Main application class
│   └── Calculator.java              # Simple calculator class
└── test/java/com/example/
    ├── SimpleMockitoExamplesTest.java # Simple examples demonstrating core concepts
    ├── UserServiceTest.java           # Comprehensive test suite
    ├── AppTest.java                   # Basic app tests
    └── CalculatorTests.java           # Calculator tests
```

## Key Classes

### ExternalApiService
Interface representing an external API service with methods for:
- Getting user by ID
- Getting all users
- Creating new users
- Updating existing users
- Deleting users

### UserService
Service class that depends on `ExternalApiService` and provides:
- User validation and business logic
- Adult user filtering (age >= 18)
- Email update functionality
- User deletion with existence checks

### User
Model class representing a user with:
- ID, name, email, and age properties
- Proper equals/hashCode implementation
- Builder-style constructors

## Test Examples

### 1. Basic Mocking and Stubbing
```java
@Test
public void example1_BasicMockingAndStubbing() {
    // Step 1: Create a mock object for the external API
    ExternalApiService mockApiService = mock(ExternalApiService.class);
    
    // Step 2: Stub the methods to return predefined values
    User expectedUser = new User("123", "John Doe", "john@example.com", 25);
    when(mockApiService.getUserById("123")).thenReturn(expectedUser);
    
    // Step 3: Write a test case that uses the mock object
    UserService userService = new UserService(mockApiService);
    User actualUser = userService.getUserById("123");
    
    // Verify the stubbed method returned the expected value
    assertEquals("User ID should match", "123", actualUser.getId());
}
```

### 2. Verifying Method Calls with Specific Arguments
```java
@Test
public void example3_VerifyMethodCallWithSpecificArguments() {
    // Step 1: Create a mock object
    ExternalApiService mockApiService = mock(ExternalApiService.class);
    
    // Stub the method to return something
    when(mockApiService.getUserById("test-id")).thenReturn(mockUser);
    
    // Step 2: Call the method with specific arguments
    UserService userService = new UserService(mockApiService);
    userService.getUserById("test-id");
    
    // Step 3: Verify the interaction
    verify(mockApiService, times(1)).getUserById("test-id");
}
```

### 3. Advanced Verification Patterns
```java
// Verify argument matchers
verify(mockApiService).createUser(argThat(user -> 
    user.getName().equals("Test User") && 
    user.getAge() == 25
));

// Verify order of method calls
var inOrder = inOrder(mockApiService);
inOrder.verify(mockApiService).getUserById("update-id");
inOrder.verify(mockApiService).updateUser(eq("update-id"), any(User.class));

// Verify no unwanted interactions
verifyNoInteractions(mockApiService);
```

## Key Mockito Features Demonstrated

1. **Mock Creation**: `@Mock` annotation and `mock()` method
2. **Method Stubbing**: `when().thenReturn()` pattern
3. **Argument Matchers**: `any()`, `eq()`, `argThat()`, `anyString()`
4. **Verification**: `verify()` with various options
5. **Interaction Counting**: `times()`, `never()`
6. **Order Verification**: `inOrder()`
7. **No Interactions**: `verifyNoInteractions()`

## Running the Tests

```bash
# Compile the project
mvn clean compile

# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=SimpleMockitoExamplesTest
mvn test -Dtest=UserServiceTest
```

## Dependencies

- **JUnit 4.11**: Testing framework
- **Mockito 5.8.0**: Mocking framework (compatible with Java 21)
- **Java 21**: Target JDK version

## Test Results

When you run the tests, you should see output like:
```
✓ Successfully mocked external API and stubbed method
✓ Successfully stubbed multiple methods
✓ Successfully verified method call with specific arguments
✓ Successfully verified multiple interactions
✓ Successfully verified order of method calls
✓ Successfully verified no unwanted interactions
✓ Successfully verified with specific argument matchers

Tests run: 26, Failures: 0, Errors: 0, Skipped: 0
```

## Learning Objectives Achieved

✅ **Requirement 1: Mock External API**
- Created mock objects for external API services
- Stubbed methods to return predefined values
- Wrote comprehensive test cases using mock objects

✅ **Requirement 2: Verify Method Calls**
- Created mock objects for verification
- Called methods with specific arguments
- Verified interactions with various patterns and matchers

This implementation provides a solid foundation for understanding and using Mockito in real-world Java applications, demonstrating both basic and advanced mocking and verification techniques.
