package com.example;

import static org.junit.Assert.assertEquals;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

public class CalculatorTests {

    private Calculator calculator;

    @Before
    public void setUp() {
        calculator = new Calculator();
    }

    @After
    public void tearDown() {
        calculator = null;
    }

    @Test
    public void testAdd_PositiveNumbers() {

        int result = calculator.add(2, 3);
        assertEquals(5, result);
    }

    @Test
    public void testAdd_NegativeNumbers() {

        int result = calculator.add(-2, -3);
        assertEquals(-5, result);
    }

    @Test
    public void testAdd_PositiveAndNegative() {

        int result = calculator.add(5, -3);
        assertEquals(2, result);
    }

    @Test
    public void testAdd_WithZero() {

        int result = calculator.add(0, 7);
        assertEquals(7, result);
    }
}