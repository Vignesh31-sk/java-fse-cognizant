package com.example;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

import org.junit.Before;
import org.junit.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.Arrays;
import java.util.List;

/**
 * Comprehensive test class demonstrating Mockito usage for:
 * 1. Mocking external API and stubbing methods
 * 2. Verifying method calls with specific arguments
 */
public class UserServiceTest {

    @Mock
    private ExternalApiService externalApiService;

    private UserService userService;

    @Before
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        userService = new UserService(externalApiService);
    }

    // ========================================
    // REQUIREMENT 1: Mock External API and Stub Methods
    // ========================================

    @Test
    public void testGetUserById_Success() {
        // Given: Create a mock object and stub its methods
        String userId = "123";
        User expectedUser = new User(userId, "John Doe", "john@example.com", 25);

        // Stub the external API method to return predefined value
        when(externalApiService.getUserById(userId)).thenReturn(expectedUser);

        // When: Call the service method
        User actualUser = userService.getUserById(userId);

        // Then: Verify the result
        assertNotNull("User should not be null", actualUser);
        assertEquals("User ID should match", userId, actualUser.getId());
        assertEquals("User name should match", "John Doe", actualUser.getName());
        assertEquals("User email should match", "john@example.com", actualUser.getEmail());
        assertEquals("User age should match", 25, actualUser.getAge());
    }

    @Test
    public void testGetAllAdultUsers_FiltersCorrectly() {
        // Given: Mock data with both adult and minor users
        List<User> allUsers = Arrays.asList(
                new User("1", "Adult User 1", "adult1@example.com", 25),
                new User("2", "Minor User", "minor@example.com", 16),
                new User("3", "Adult User 2", "adult2@example.com", 30),
                new User("4", "Just Adult", "just18@example.com", 18));

        // Stub the getAllUsers method
        when(externalApiService.getAllUsers()).thenReturn(allUsers);

        // When: Get adult users
        List<User> adultUsers = userService.getAllAdultUsers();

        // Then: Verify filtering worked correctly
        assertEquals("Should have 3 adult users", 3, adultUsers.size());

        // Verify all returned users are adults
        for (User user : adultUsers) {
            assertTrue("All users should be adults (age >= 18)", user.getAge() >= 18);
        }
    }

    @Test
    public void testCreateUser_Success() {
        // Given: Prepare input data and expected response
        String name = "Jane Smith";
        String email = "jane@example.com";
        int age = 28;

        User createdUser = new User("456", name, email, age);

        // Stub the createUser method
        when(externalApiService.createUser(any(User.class))).thenReturn(createdUser);

        // When: Create user
        User result = userService.createUser(name, email, age);

        // Then: Verify the result
        assertNotNull("Created user should not be null", result);
        assertEquals("Created user should have ID", "456", result.getId());
        assertEquals("Name should match", name, result.getName());
        assertEquals("Email should match", email, result.getEmail());
        assertEquals("Age should match", age, result.getAge());
    }

    @Test
    public void testUpdateUserEmail_Success() {
        // Given: Existing user and new email
        String userId = "123";
        String newEmail = "newemail@example.com";
        User existingUser = new User(userId, "John Doe", "old@example.com", 25);
        User updatedUser = new User(userId, "John Doe", newEmail, 25);

        // Stub both getUserById and updateUser methods
        when(externalApiService.getUserById(userId)).thenReturn(existingUser);
        when(externalApiService.updateUser(eq(userId), any(User.class))).thenReturn(updatedUser);

        // When: Update email
        User result = userService.updateUserEmail(userId, newEmail);

        // Then: Verify the result
        assertNotNull("Updated user should not be null", result);
        assertEquals("Email should be updated", newEmail, result.getEmail());
    }

    @Test
    public void testGetUserCount_Success() {
        // Given: Mock list of users
        List<User> users = Arrays.asList(
                new User("1", "User 1", "user1@example.com", 25),
                new User("2", "User 2", "user2@example.com", 30),
                new User("3", "User 3", "user3@example.com", 35));

        // Stub the getAllUsers method
        when(externalApiService.getAllUsers()).thenReturn(users);

        // When: Get user count
        int count = userService.getUserCount();

        // Then: Verify count
        assertEquals("User count should match", 3, count);
    }

    // ========================================
    // REQUIREMENT 2: Verify Method Calls with Specific Arguments
    // ========================================

    @Test
    public void testVerifyGetUserByIdCalledWithCorrectArguments() {
        // Given: Mock the return value
        String userId = "test-user-123";
        User mockUser = new User(userId, "Test User", "test@example.com", 30);
        when(externalApiService.getUserById(userId)).thenReturn(mockUser);

        // When: Call the service method
        userService.getUserById(userId);

        // Then: Verify the external API was called with specific arguments
        verify(externalApiService, times(1)).getUserById("test-user-123");
        verify(externalApiService, times(1)).getUserById(eq(userId));

        // Verify it was called exactly once
        verify(externalApiService, times(1)).getUserById(anyString());

        // Verify no other methods were called
        verifyNoMoreInteractions(externalApiService);
    }

    @Test
    public void testVerifyCreateUserCalledWithCorrectUser() {
        // Given: Input parameters
        String name = "New User";
        String email = "newuser@example.com";
        int age = 25;

        User createdUser = new User("new-id", name, email, age);
        when(externalApiService.createUser(any(User.class))).thenReturn(createdUser);

        // When: Create user
        userService.createUser(name, email, age);

        // Then: Verify createUser was called with correct User object
        verify(externalApiService, times(1)).createUser(argThat(user -> user.getName().equals(name) &&
                user.getEmail().equals(email) &&
                user.getAge() == age));
    }

    @Test
    public void testVerifyUpdateUserEmailCallsCorrectMethods() {
        // Given: Setup
        String userId = "update-test-123";
        String newEmail = "updated@example.com";
        User existingUser = new User(userId, "Update User", "old@example.com", 35);
        User updatedUser = new User(userId, "Update User", newEmail, 35);

        when(externalApiService.getUserById(userId)).thenReturn(existingUser);
        when(externalApiService.updateUser(eq(userId), any(User.class))).thenReturn(updatedUser);

        // When: Update email
        userService.updateUserEmail(userId, newEmail);

        // Then: Verify both methods were called in correct order
        verify(externalApiService, times(1)).getUserById(userId);
        verify(externalApiService, times(1)).updateUser(eq(userId), argThat(user -> user.getEmail().equals(newEmail)));

        // Verify the order of method calls
        var inOrder = inOrder(externalApiService);
        inOrder.verify(externalApiService).getUserById(userId);
        inOrder.verify(externalApiService).updateUser(eq(userId), any(User.class));
    }

    @Test
    public void testVerifyDeleteUserInteractions() {
        // Given: Setup
        String userId = "delete-test-456";
        User existingUser = new User(userId, "Delete User", "delete@example.com", 40);

        when(externalApiService.getUserById(userId)).thenReturn(existingUser);
        when(externalApiService.deleteUser(userId)).thenReturn(true);

        // When: Delete user
        boolean result = userService.deleteUser(userId);

        // Then: Verify interactions
        assertTrue("Delete should return true", result);

        // Verify getUserById was called first
        verify(externalApiService, times(1)).getUserById(userId);

        // Verify deleteUser was called with correct ID
        verify(externalApiService, times(1)).deleteUser(userId);

        // Verify exact number of interactions
        verify(externalApiService, times(1)).getUserById(anyString());
        verify(externalApiService, times(1)).deleteUser(anyString());
    }

    @Test
    public void testVerifyNoInteractionsWhenValidationFails() {
        // Given: Invalid input
        String invalidUserId = "";

        // When & Then: Expect exception and verify no API calls
        try {
            userService.getUserById(invalidUserId);
            fail("Should have thrown IllegalArgumentException");
        } catch (IllegalArgumentException e) {
            // Expected exception
            assertEquals("User ID cannot be null or empty", e.getMessage());
        }

        // Verify no interactions with the external API
        verifyNoInteractions(externalApiService);
    }

    @Test
    public void testVerifyMultipleMethodCallsWithDifferentArguments() {
        // Given: Multiple users
        when(externalApiService.getUserById("user1")).thenReturn(
                new User("user1", "User One", "user1@example.com", 25));
        when(externalApiService.getUserById("user2")).thenReturn(
                new User("user2", "User Two", "user2@example.com", 30));

        // When: Call method multiple times with different arguments
        userService.getUserById("user1");
        userService.getUserById("user2");
        userService.getUserById("user1"); // Call again

        // Then: Verify specific calls
        verify(externalApiService, times(2)).getUserById("user1");
        verify(externalApiService, times(1)).getUserById("user2");
        verify(externalApiService, times(3)).getUserById(anyString());

        // Verify specific arguments were used
        verify(externalApiService, times(2)).getUserById("user1");
        verify(externalApiService, times(1)).getUserById("user2");
        verify(externalApiService, never()).getUserById("user3");
    }

    // ========================================
    // Additional Edge Cases and Error Scenarios
    // ========================================

    @Test(expected = RuntimeException.class)
    public void testGetUserById_UserNotFound() {
        // Given: Mock returns null (user not found)
        String userId = "non-existent";
        when(externalApiService.getUserById(userId)).thenReturn(null);

        // When: Try to get non-existent user
        userService.getUserById(userId);

        // Then: Exception should be thrown (handled by expected annotation)
    }

    @Test(expected = IllegalArgumentException.class)
    public void testCreateUser_InvalidName() {
        // When: Try to create user with invalid name
        userService.createUser("", "email@example.com", 25);

        // Then: Exception should be thrown (handled by expected annotation)
    }

    @Test
    public void testDeleteUser_UserNotFound() {
        // Given: User doesn't exist
        String userId = "non-existent";
        when(externalApiService.getUserById(userId)).thenReturn(null);

        // When: Try to delete non-existent user
        boolean result = userService.deleteUser(userId);

        // Then: Should return false and not call deleteUser
        assertFalse("Should return false for non-existent user", result);
        verify(externalApiService, times(1)).getUserById(userId);
        verify(externalApiService, never()).deleteUser(anyString());
    }
}
