package com.example;

import java.util.List;

/**
 * Interface representing an external API service
 */
public interface ExternalApiService {

    /**
     * Fetches user data from external API
     * 
     * @param userId the user ID
     * @return User object
     */
    User getUserById(String userId);

    /**
     * Fetches all users from external API
     * 
     * @return List of users
     */
    List<User> getAllUsers();

    /**
     * Creates a new user via external API
     * 
     * @param user the user to create
     * @return created user with ID
     */
    User createUser(User user);

    /**
     * Updates user data via external API
     * 
     * @param userId the user ID
     * @param user   updated user data
     * @return updated user
     */
    User updateUser(String userId, User user);

    /**
     * Deletes a user via external API
     * 
     * @param userId the user ID
     * @return true if successful
     */
    boolean deleteUser(String userId);
}
