# Spring Data JPA with Spring Boot Project

## Overview
This project is a demonstration of **Spring Data JPA** with **Spring Boot** and **Hibernate** as the JPA provider, created as part of the "Week 3: Spring Data JPA with Hibernate" module in the Cognizant Digital Nurture 4.0 Java Full Stack Engineer (FSE) training program. The project showcases CRUD operations (Create, Read, Update, Delete) for an `Employee` entity using Spring Data JPAΓÇÖs repository interface and REST APIs, alongside a separate raw Hibernate implementation to illustrate the differences between Hibernate and Spring Data JPA.

The application uses an in-memory H2 database to store employee data and provides REST endpoints to manage employees. Additionally, a standalone `hibernate.java` class demonstrates manual persistence using raw Hibernate.


### Key Components
1. **Employee.java**:
   - An entity class representing the `employee` table with fields:
     - `id` (Integer, auto-generated primary key)
     - `name` (String, non-nullable)
     - `email` (String, non-nullable)
     - `department` (String, non-nullable)
   - Uses LombokΓÇÖs `@Data` for getters, setters, and `toString`.
   ```java
   @Data
   @Entity
   @Table(name = "employee")
   public class Employee {
       @Id
       @GeneratedValue(strategy = GenerationType.IDENTITY)
       private Integer id;
       @Column(nullable = false)
       private String name;
       @Column(nullable = false)
       private String email;
       @Column(nullable = false)
       private String department;
   }
   ```

2. **EmployeeRepository.java**:
   - A Spring Data JPA repository interface extending `JpaRepository<Employee, Integer>`, providing CRUD methods.
   - Includes a custom query method `findByEmail` to retrieve an employee by email.
   ```java
   @Repository
   public interface EmployeeRepository extends JpaRepository<Employee, Integer> {
       Employee findByEmail(String email);
   }
   ```

3. **EmployeeService.java**:
   - A service class annotated with `@Service` and `@Transactional`, handling business logic.
   - Provides methods for adding, retrieving (all, by ID, by email), and deleting employees.
   ```java
   @Service
   @Transactional
   public class EmployeeService {
       @Autowired
       private EmployeeRepository employeeRepository;
       public Employee addEmployee(Employee employee) { return employeeRepository.save(employee); }
       public List<Employee> getAllEmployees() { return employeeRepository.findAll(); }
       public Employee getEmployeeById(Integer id) { return employeeRepository.findById(id).orElse(null); }
       public Employee getEmployeeByEmail(String email) { return employeeRepository.findByEmail(email); }
       public void deleteEmployee(Integer id) { employeeRepository.deleteById(id); }
   }
   ```

4. **EmployeeController.java**:
   - A REST controller exposing endpoints under `/api/employees`:
     - `POST /api/employees`: Add a new employee.
     - `GET /api/employees`: Retrieve all employees.
     - `GET /api/employees/{id}`: Retrieve an employee by ID.
     - `DELETE /api/employees/{id}`: Delete an employee by ID.
   ```java
   @RestController
   @RequestMapping("/api/employees")
   public class EmployeeController {
       @Autowired
       private EmployeeService employeeService;
       @PostMapping
       public ResponseEntity<Employee> addEmployee(@RequestBody Employee employee) { ... }
       @GetMapping
       public ResponseEntity<List<Employee>> getAllEmployees() { ... }
       @GetMapping("/{id}")
       public ResponseEntity<Employee> getEmployeeById(@PathVariable Integer id) { ... }
       @DeleteMapping("/{id}")
       public ResponseEntity<Void> deleteEmployee(@PathVariable Integer id) { ... }
   }
   ```

5. **hibernate.java**:
   - A standalone utility class demonstrating raw Hibernate usage to save an `Employee` entity.
   - Uses `SessionFactory` and manual transaction management, not integrated with the Spring Boot application.
   ```java
   public class hibernate {
       public Integer addEmployee(Employee employee) {
           SessionFactory factory = new MetadataSources(new StandardServiceRegistryBuilder().configure().build())
                   .buildMetadata().buildSessionFactory();
           // Save employee logic
       }
   }
   ```

6. **EmployeeApplication.java**:
   - The main application class that bootstraps the Spring Boot application.
   ```java
   @SpringBootApplication
   public class EmployeeApplication {
       public static void main(String[] args) {
           SpringApplication.run(EmployeeApplication.class, args);
       }
   }
   ```

7. **application.properties** (Inferred):
   - Configures the H2 in-memory database and JPA settings. Example:
   ```properties
   spring.datasource.url=jdbc:h2:mem:testdb
   spring.datasource.driverClassName=org.h2.Driver
   spring.datasource.username=sa
   spring.datasource.password=
   spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
   spring.jpa.hibernate.ddl-auto=update
   spring.h2.console.enabled=true
   ```

## Expected Output
When you run the application:
1. **Application Startup**: The Spring Boot application starts, initializes the H2 in-memory database, and creates the `employee` table based on the `Employee` entity.
   ```
   2025-07-07 19:38:XX.XXX [main] INFO  org.springframework.boot.StartupInfoLogger - Started EmployeeApplication in X.XXX seconds
   ```

2. **REST API Testing**:
   Use Postman or cURL to test the endpoints. Example interactions:

   - **Add an Employee**:
     ```bash
     curl -X POST http://localhost:8080/api/employees -H "Content-Type: application/json" -d '{"name":"John Doe","email":"john.doe@example.com","department":"IT"}'
     ```
     **Response**:
     ```json
     {
         "id": 1,
         "name": "John Doe",
         "email": "john.doe@example.com",
         "department": "IT"
     }
     ```

   - **Get All Employees**:
     ```bash
     curl http://localhost:8080/api/employees
     ```
     **Response** (after adding employees):
     ```json
     [
         {
             "id": 1,
             "name": "John Doe",
             "email": "john.doe@example.com",
             "department": "IT"
         },
         {
             "id": 2,
             "name": "Jane Smith",
             "email": "jane.smith@example.com",
             "department": "HR"
         }
     ]
     ```

   - **Get Employee by ID**:
     ```bash
     curl http://localhost:8080/api/employees/1
     ```
     **Response**:
     ```json
     {
         "id": 1,
         "name": "John Doe",
         "email": "john.doe@example.com",
         "department": "IT"
     }
     ```

   - **Delete Employee**:
     ```bash
     curl -X DELETE http://localhost:8080/api/employees/1
     ```
     **Response**: HTTP 204 No Content

3. **H2 Database**:
   Verify data in the H2 console by querying:
   ```sql
   SELECT * FROM employee;
   ```
   Example result (after adding employees):
   ```
   ID | NAME       | EMAIL                | DEPARTMENT
   1  | John Doe   | john.doe@example.com | IT
   2  | Jane Smith | jane.smith@example.com | HR
   ```

4. **Raw Hibernate Usage**:
   The `hibernate.java` class is not integrated with the Spring Boot application. To test it, you would need to call its `addEmployee` method separately, ensuring a `hibernate.cfg.xml` file is present. Example output in a standalone context:
   ```
   Hibernate: insert into employee (department, email, name) values (?, ?, ?)
   ```

## Dependencies
The `pom.xml` (inferred) includes the following key dependencies:
- `spring-boot-starter-data-jpa`: For Spring Data JPA and Hibernate
- `spring-boot-starter-web`: For REST APIs
- `h2`: For the in-memory H2 database
- `lombok`: For boilerplate code reduction
- `spring-boot-starter-test`: For testing
