package com.example;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import org.junit.Test;

/**
 * Simple examples demonstrating the two main requirements:
 * 1. Mocking external API and stubbing methods
 * 2. Verifying method calls with specific arguments
 */
public class SimpleMockitoExamplesTest {

    // ========================================
    // REQUIREMENT 1: Mock External API and Stub Methods
    // ========================================

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
        assertNotNull("User should not be null", actualUser);
        assertEquals("User ID should match", "123", actualUser.getId());
        assertEquals("User name should match", "John Doe", actualUser.getName());

        System.out.println("✓ Successfully mocked external API and stubbed method");
    }

    @Test
    public void example2_StubbingMultipleMethods() {
        // Step 1: Create mock object
        ExternalApiService mockApiService = mock(ExternalApiService.class);

        // Step 2: Stub multiple methods with different return values
        User user1 = new User("1", "Alice", "alice@example.com", 30);
        User user2 = new User("2", "Bob", "bob@example.com", 25);

        when(mockApiService.getUserById("1")).thenReturn(user1);
        when(mockApiService.getUserById("2")).thenReturn(user2);
        when(mockApiService.createUser(any(User.class))).thenReturn(
                new User("3", "New User", "new@example.com", 28));

        // Step 3: Test using the stubbed methods
        UserService userService = new UserService(mockApiService);

        User retrievedUser1 = userService.getUserById("1");
        User retrievedUser2 = userService.getUserById("2");
        User createdUser = userService.createUser("New User", "new@example.com", 28);

        assertEquals("First user should be Alice", "Alice", retrievedUser1.getName());
        assertEquals("Second user should be Bob", "Bob", retrievedUser2.getName());
        assertEquals("Created user should have ID 3", "3", createdUser.getId());

        System.out.println("✓ Successfully stubbed multiple methods");
    }

    // ========================================
    // REQUIREMENT 2: Verify Method Calls with Specific Arguments
    // ========================================

    @Test
    public void example3_VerifyMethodCallWithSpecificArguments() {
        // Step 1: Create a mock object
        ExternalApiService mockApiService = mock(ExternalApiService.class);

        // Stub the method to return something
        User mockUser = new User("test-id", "Test User", "test@example.com", 30);
        when(mockApiService.getUserById("test-id")).thenReturn(mockUser);

        // Step 2: Call the method with specific arguments
        UserService userService = new UserService(mockApiService);
        userService.getUserById("test-id");

        // Step 3: Verify the interaction
        verify(mockApiService, times(1)).getUserById("test-id");

        System.out.println("✓ Successfully verified method call with specific arguments");
    }

    @Test
    public void example4_VerifyMultipleInteractions() {
        // Step 1: Create mock object
        ExternalApiService mockApiService = mock(ExternalApiService.class);

        // Stub methods
        when(mockApiService.getUserById(anyString())).thenReturn(
                new User("1", "Test", "test@example.com", 25));
        when(mockApiService.createUser(any(User.class))).thenReturn(
                new User("2", "Created", "created@example.com", 30));

        // Step 2: Call methods with specific arguments
        UserService userService = new UserService(mockApiService);
        userService.getUserById("user-123");
        userService.createUser("New User", "new@example.com", 35);

        // Step 3: Verify the interactions
        verify(mockApiService, times(1)).getUserById("user-123");
        verify(mockApiService, times(1)).createUser(argThat(user -> user.getName().equals("New User") &&
                user.getEmail().equals("new@example.com") &&
                user.getAge() == 35));

        // Verify total number of interactions
        verify(mockApiService, times(1)).getUserById(anyString());
        verify(mockApiService, times(1)).createUser(any(User.class));

        System.out.println("✓ Successfully verified multiple interactions");
    }

    @Test
    public void example5_VerifyOrderOfMethodCalls() {
        // Step 1: Create mock object
        ExternalApiService mockApiService = mock(ExternalApiService.class);

        // Stub methods
        User existingUser = new User("update-id", "Old Name", "old@example.com", 25);
        User updatedUser = new User("update-id", "Old Name", "new@example.com", 25);

        when(mockApiService.getUserById("update-id")).thenReturn(existingUser);
        when(mockApiService.updateUser(eq("update-id"), any(User.class))).thenReturn(updatedUser);

        // Step 2: Call methods that should happen in specific order
        UserService userService = new UserService(mockApiService);
        userService.updateUserEmail("update-id", "new@example.com");

        // Step 3: Verify the order of interactions
        var inOrder = inOrder(mockApiService);
        inOrder.verify(mockApiService).getUserById("update-id");
        inOrder.verify(mockApiService).updateUser(eq("update-id"), any(User.class));

        System.out.println("✓ Successfully verified order of method calls");
    }

    @Test
    public void example6_VerifyNoUnwantedInteractions() {
        // Step 1: Create mock object
        ExternalApiService mockApiService = mock(ExternalApiService.class);

        // Step 2: Call method with invalid arguments (should not call API)
        UserService userService = new UserService(mockApiService);

        try {
            userService.getUserById(""); // Invalid empty string
            fail("Should have thrown exception");
        } catch (IllegalArgumentException e) {
            // Expected exception
        }

        // Step 3: Verify no interactions occurred
        verifyNoInteractions(mockApiService);

        System.out.println("✓ Successfully verified no unwanted interactions");
    }

    @Test
    public void example7_VerifySpecificArgumentMatchers() {
        // Step 1: Create mock
        ExternalApiService mockApiService = mock(ExternalApiService.class);

        when(mockApiService.createUser(any(User.class))).thenReturn(
                new User("new-id", "Created User", "created@example.com", 30));

        // Step 2: Call method
        UserService userService = new UserService(mockApiService);
        userService.createUser("Test User", "test@example.com", 25);

        // Step 3: Verify with different argument matchers
        verify(mockApiService).createUser(any(User.class));
        verify(mockApiService).createUser(argThat(user -> user.getName().equals("Test User")));
        verify(mockApiService).createUser(argThat(user -> user.getAge() == 25));
        verify(mockApiService, never()).createUser(argThat(user -> user.getAge() < 18));

        System.out.println("✓ Successfully verified with specific argument matchers");
    }
}
