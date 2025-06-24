## Recursive Algorithms for Financial Forecasting

### Understanding Recursion

Recursion is a programming technique where a function calls itself to solve a problem. A recursive function has two key components:
1. **Base case**: A condition that stops the recursion
2. **Recursive case**: Where the function calls itself with a modified input

Recursion can simplify the implementation of certain problems by breaking them down into smaller, similar subproblems. It's particularly useful when a problem has a naturally recursive structure, like calculating compound growth over time.

### Financial Forecasting with Recursion

In our financial forecasting tool, we use recursion to calculate the future value of an investment based on an initial value and a growth rate over multiple periods. This is a natural fit for recursion because:

- The value at period 0 is simply the initial value (base case)
- The value at any period n is the value at period n-1 multiplied by (1 + growth rate)

### Implementation Overview

Our implementation includes two versions of the future value calculation:

1. **Simple Recursive Algorithm**:
   ```java
   public static double calculateFutureValue(double initialValue, double growthRate, int periods) {
       if (periods == 0) {
           return initialValue;
       }
       return calculateFutureValue(initialValue, growthRate, periods - 1) * (1 + growthRate);
   }
   ```

2. **Optimized Recursive Algorithm with Memoization**:
   ```java
   public static double calculateFutureValueMemoized(double initialValue, double growthRate, 
                                                    int periods, double[] memo) {
       if (memo[periods] != -1) {
           return memo[periods];
       }
       if (periods == 0) {
           memo[periods] = initialValue;
           return initialValue;
       }
       double result = calculateFutureValueMemoized(initialValue, growthRate, periods - 1, memo) 
                       * (1 + growthRate);
       memo[periods] = result;
       return result;
   }
   ```

### Time Complexity Analysis

1. **Simple Recursive Algorithm**:
   - Time Complexity: O(n), where n is the number of periods
   - Each recursive call decreases the period by 1 until it reaches 0
   - No redundant calculations occur in this particular case because each value is only calculated once

2. **General Case for Recursive Algorithms**:
   - Many recursive algorithms can have exponential time complexity O(2^n) if they recalculate the same values multiple times
   - This is often the case with algorithms like calculating Fibonacci numbers

### Optimization Techniques

1. **Memoization**:
   - We use memoization (a form of dynamic programming) to store previously calculated values
   - This prevents redundant calculations if the same value is needed multiple times
   - Reduces time complexity from potentially exponential to linear

2. **Alternative Iterative Solution**:
   - While not implemented in our code, an iterative approach could also be used:
   ```java
   public static double calculateFutureValueIterative(double initialValue, double growthRate, int periods) {
       double result = initialValue;
       for (int i = 0; i < periods; i++) {
           result *= (1 + growthRate);
       }
       return result;
   }
   ```
   - The iterative solution has O(n) time complexity and uses O(1) space

### Space Complexity Considerations

1. **Simple Recursion**: O(n) space complexity due to the call stack growing with each recursive call
2. **Memoized Recursion**: O(n) space complexity for both the call stack and the memoization array
3. **Iterative Solution**: O(1) space complexity as it only needs a single variable

### When to Use Recursion vs. Iteration

- **Use recursion** when:
  - The problem is naturally recursive
  - Code clarity is more important than performance
  - The recursive depth is limited (to avoid stack overflow)

- **Use iteration** when:
  - Performance and memory usage are critical
  - The problem involves a large number of operations
  - The recursive solution would lead to excessive stack depth

In our financial forecasting example, both approaches are viable, but the iterative solution would be more efficient for large numbers of periods.

## Program Output

When running the financial forecasting program with an initial value of $1000, a growth rate of 5%, and a period of 10 years, we get the following output:

```
Future value after 10 periods: $1628.89

Step-by-step calculation:
Period 0: $1000.00
Period 1: $1050.00
Period 2: $1102.50
Period 3: $1157.63
Period 4: $1215.51
Period 5: $1276.28
Period 6: $1340.10
Period 7: $1407.10
Period 8: $1477.46
Period 9: $1551.33
Period 10: $1628.89

Using memoization:
Future value (optimized) after 10 periods: $1628.89
```

This output demonstrates:

1. The initial investment of $1000 grows to $1628.89 after 10 periods with a 5% growth rate
2. A period-by-period breakdown showing the compound growth effect
3. Confirmation that both the simple recursive and memoized approaches yield identical results
4. The power of compound growth - the initial investment increases by over 62% after 10 periods

The results match the mathematical formula for compound interest: `FV = PV × (1 + r)^n`, where:
- FV = Future Value
- PV = Present Value (initial investment)
- r = Interest/growth rate
- n = Number of periods

$1000 × (1 + 0.05)^{10} = 1000 × 1.62889... = $1628.89
