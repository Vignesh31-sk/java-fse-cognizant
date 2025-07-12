
# Spring Learn Assignment: REST Country Web Service

## Objective
Implement a REST service in the Spring Boot application that returns India country details at the endpoint `/country`.

## Implementation Steps
1. **Create the Country Bean**
   - Java class: `com.cognizant.spring_learn.model.Country` with fields `code` and `name`.
2. **Define the Country Bean in XML**
   - File: `src/main/resources/country.xml`
   - Bean with `code = "IN"` and `name = "India"`.
3. **Load XML Configuration**
   - Add `@ImportResource("classpath:country.xml")` in `SpringLearnApplication.java`.
4. **Create the Controller**
   - Java class: `com.cognizant.spring_learn.controller.CountryController`
   - Method: `getCountryIndia()` mapped to `/country` using `@RequestMapping`.
   - Returns the India bean loaded from XML.

## How It Works
- When a GET request is made to `/country`, the controller returns the `Country` bean.
- Spring Boot automatically converts the Java object to JSON using Jackson.

## Sample Request
```
GET http://localhost:8083/country
```

## Sample Response
```json
{
  "code": "IN",
  "name": "India"
}
```

## HTTP Headers (Example)
- **Content-Type:** application/json
- **Content-Length:** 33
- **Date:** Sat, 12 Jul 2025 10:00:00 GMT
- **Server:** Apache-Coyote/1.1

## How to View HTTP Headers
- **Browser:** Open Developer Tools > Network tab > Click `/country` request > View Headers.
- **Postman:** After sending request, click the "Headers" tab in the response section.

## Notes
- The controller uses `@RestController` so the response is automatically JSON.
- The bean is loaded from XML using Spring's `@ImportResource`.
