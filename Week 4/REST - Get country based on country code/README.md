# Country REST Service Assignment

## Overview
This assignment implements a Spring Boot REST service that returns country details based on a country code. The country data is loaded from an XML file (`country.xml`) in the resources folder. The country code lookup is case-insensitive.

## Endpoints
- **GET /countries/{code}**
  - Returns the country details for the given country code.
  - Example: `/countries/in` or `/countries/IN`

## How It Works
- The controller receives the country code from the URL path.
- The service loads the list of countries from `country.xml`.
- It searches for a country with a matching code (case-insensitive).
- If found, it returns the country as JSON. If not found, an error is returned.

## Sample Request
```
GET http://localhost:8083/countries/in
```

## Sample Response
```
{
  "code": "IN",
  "name": "India"
}
```

## country.xml Example
```
<?xml version="1.0" encoding="UTF-8"?>
<countryList>
    <country>
        <code>IN</code>
        <name>India</name>
    </country>
    <country>
        <code>US</code>
        <name>United States</name>
    </country>
    <country>
        <code>FR</code>
        <name>France</name>
    </country>
    <!-- Add more countries as needed -->
</countryList>
```

## How to Run

1. Open a terminal and navigate to the project root directory.
2. Run the following command to start the Spring Boot application:
   - On Unix/macOS: `./mvnw spring-boot:run`
   - On Windows: `mvnw.cmd spring-boot:run`
3. Once the application is running, access the endpoint using a browser or API tool (like Postman).

---

