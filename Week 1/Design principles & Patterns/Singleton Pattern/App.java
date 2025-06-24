public class App {
    public static void main(String[] args) {
        // Test the Singleton implementation
        System.out.println("Testing Singleton Pattern with Logger class");

        // Get logger instances
        Logger logger1 = Logger.getInstance();
        Logger logger2 = Logger.getInstance();

        // Test if both references point to the same object
        if (logger1 == logger2) {
            System.out.println("Singleton works! Both variables contain the same instance.");
        } else {
            System.out.println("Singleton failed! Variables contain different instances.");
        }

        // Use the logger
        logger1.log("This is a log message from logger1");
        logger2.log("This is a log message from logger2");
    }
}

/**
 * Logger class implementing the Singleton design pattern.
 * This ensures only one instance of Logger exists throughout the application.
 */
class Logger {
    // Private static variable to hold the single instance of Logger
    private static Logger instance;

    // Private constructor to prevent instantiation from outside the class
    private Logger() {
        System.out.println("Logger instance created");
    }

    /**
     * Public static method to get the single instance of Logger
     * If the instance doesn't exist, it creates one; otherwise, returns existing
     * instance
     * 
     * @return The single instance of Logger
     */
    public static Logger getInstance() {
        if (instance == null) {
            instance = new Logger();
        }
        return instance;
    }

    /**
     * Method to log messages
     * 
     * @param message The message to be logged
     */
    public void log(String message) {
        System.out.println("LOG: " + message);
    }
}
