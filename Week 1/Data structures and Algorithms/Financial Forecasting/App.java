package w1;

public class App {
    /**
     * Main method to demonstrate the financial forecasting tool
     */
    public static void main(String[] args) {
        // Example parameters
        double initialValue = 1000.0;
        double growthRate = 0.05; // 5% growth rate
        int periods = 10; // 10 years

        // Calculate future value using recursion
        double futureValue = calculateFutureValue(initialValue, growthRate, periods);
        System.out.println("Future value after " + periods + " periods: $" + String.format("%.2f", futureValue));

        // Show step-by-step calculation
        System.out.println("\nStep-by-step calculation:");
        for (int i = 0; i <= periods; i++) {
            double value = calculateFutureValue(initialValue, growthRate, i);
            System.out.println("Period " + i + ": $" + String.format("%.2f", value));
        }

        // Demonstrate the optimized version with memoization
        System.out.println("\nUsing memoization:");
        double[] memo = new double[periods + 1];
        for (int i = 0; i < memo.length; i++) {
            memo[i] = -1; // Initialize with a sentinel value
        }
        double optimizedValue = calculateFutureValueMemoized(initialValue, growthRate, periods, memo);
        System.out.println(
                "Future value (optimized) after " + periods + " periods: $" + String.format("%.2f", optimizedValue));
    }

    /**
     * Recursive method to calculate future value
     * 
     * @param initialValue The starting value
     * @param growthRate   The rate of growth per period (e.g., 0.05 for 5%)
     * @param periods      The number of periods to calculate for
     * @return The calculated future value
     */
    public static double calculateFutureValue(double initialValue, double growthRate, int periods) {
        // Base case: if periods is 0, return the initial value
        if (periods == 0) {
            return initialValue;
        }

        // Recursive case: future value is previous value plus growth
        return calculateFutureValue(initialValue, growthRate, periods - 1) * (1 + growthRate);
    }

    /**
     * Optimized recursive method using memoization to avoid redundant calculations
     * 
     * @param initialValue The starting value
     * @param growthRate   The rate of growth per period
     * @param periods      The number of periods to calculate for
     * @param memo         Array to store previously calculated values
     * @return The calculated future value
     */
    public static double calculateFutureValueMemoized(double initialValue, double growthRate, int periods,
            double[] memo) {
        // If value is already calculated, return it
        if (memo[periods] != -1) {
            return memo[periods];
        }

        // Base case: if periods is 0, return the initial value
        if (periods == 0) {
            memo[periods] = initialValue;
            return initialValue;
        }

        // Recursive case with memoization
        double result = calculateFutureValueMemoized(initialValue, growthRate, periods - 1, memo) * (1 + growthRate);
        memo[periods] = result;
        return result;
    }
}
