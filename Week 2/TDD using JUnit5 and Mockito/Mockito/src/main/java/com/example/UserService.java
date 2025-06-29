package com.example;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Service class that depends on an external API
 */
public class UserService {

    private final ExternalApiService externalApiService;

    public UserService(ExternalApiService externalApiService) {
        this.externalApiService = externalApiService;
    }

    /**
     * Get user by ID with validation
     */
    public User getUserById(String userId) {
        if (userId == null || userId.trim().isEmpty()) {
            throw new IllegalArgumentException("User ID cannot be null or empty");
        }

        User user = externalApiService.getUserById(userId);
        if (user == null) {
            throw new RuntimeException("User not found with ID: " + userId);
        }

        return user;
    }

    /**
     * Get all adult users (age >= 18)
     */
    public List<User> getAllAdultUsers() {
        List<User> allUsers = externalApiService.getAllUsers();
        return allUsers.stream()
                .filter(user -> user.getAge() >= 18)
                .collect(Collectors.toList());
    }

    /**
     * Create a new user with validation
     */
    public User createUser(String name, String email, int age) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Name cannot be null or empty");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be null or empty");
        }
        if (age < 0) {
            throw new IllegalArgumentException("Age cannot be negative");
        }

        User newUser = new User(name, email, age);
        return externalApiService.createUser(newUser);
    }

    /**
     * Update user email
     */
    public User updateUserEmail(String userId, String newEmail) {
        if (userId == null || userId.trim().isEmpty()) {
            throw new IllegalArgumentException("User ID cannot be null or empty");
        }
        if (newEmail == null || newEmail.trim().isEmpty()) {
            throw new IllegalArgumentException("Email cannot be null or empty");
        }

        // First get the existing user
        User existingUser = externalApiService.getUserById(userId);
        if (existingUser == null) {
            throw new RuntimeException("User not found with ID: " + userId);
        }

        // Update the email
        existingUser.setEmail(newEmail);

        // Call the API to update
        return externalApiService.updateUser(userId, existingUser);
    }

    /**
     * Delete user with confirmation
     */
    public boolean deleteUser(String userId) {
        if (userId == null || userId.trim().isEmpty()) {
            throw new IllegalArgumentException("User ID cannot be null or empty");
        }

        // Check if user exists first
        User existingUser = externalApiService.getUserById(userId);
        if (existingUser == null) {
            return false; // User doesn't exist
        }

        // Delete the user
        return externalApiService.deleteUser(userId);
    }

    /**
     * Get user count
     */
    public int getUserCount() {
        List<User> users = externalApiService.getAllUsers();
        return users != null ? users.size() : 0;
    }
}
