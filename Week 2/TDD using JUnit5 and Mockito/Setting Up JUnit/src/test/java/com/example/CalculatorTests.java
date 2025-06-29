package com.example;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

public class CalculatorTests {

    @Test
    public void testAdd() {
        Calculator calculator = new Calculator();
        int result = calculator.add(2, 3);
        assertEquals(5, result);
    }

    @Test
    public void testAssertTrue() {
        Calculator calculator = new Calculator();
        assertTrue(calculator.add(1, 1) == 2);
    }

    @Test
    public void testAssertFalse() {
        Calculator calculator = new Calculator();
        assertFalse(calculator.add(2, 2) == 5);
    }

    @Test
    public void testAssertNull() {
        Calculator calculator = new Calculator();
        Object result = calculator.getNull();
        assertNull(result);
    }

    @Test
    public void testAssertNotNull() {
        Calculator calculator = new Calculator();
        Object result = calculator.getNotNull();
        assertNotNull(result);
    }

}
