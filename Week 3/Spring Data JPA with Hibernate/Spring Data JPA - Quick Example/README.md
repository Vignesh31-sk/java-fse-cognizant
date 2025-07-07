# Spring Data JPA - Quick Example Project

## Overview
This project is a minimal demonstration of **Spring Data JPA** with **Spring Boot** and **Hibernate** as the JPA provider, created as part of the "Week 3: Spring Data JPA with Hibernate" module in the Cognizant Digital Nurture 4.0 Java Full Stack Engineer (FSE) training program. The project showcases a simple use case of retrieving a list of `Country` entities from an in-memory H2 database using Spring Data JPAΓÇÖs repository interface.

The application defines a `Country` entity, a repository for data access, a service layer for business logic, and a main application class that demonstrates fetching all countries and logging the results.

### Key Components
1. **Country.java**:
   - An entity class representing the `country` table with fields:
     - `code` (String, primary key, mapped to `co_code`)
     - `name` (String, mapped to `co_name`)
   - Includes getters, setters, and a `toString` method for logging.
   ```java
   @Entity
   @Table(name = "country")
   public class Country {
       @Id
       @Column(name = "co_code")
       private String code;
       @Column(name = "co_name")
       private String name;
       // Getters, setters, toString
   }
   ```

2. **CountryRepository.java** (Inferred):
   - A Spring Data JPA repository interface extending `JpaRepository<Country, String>`, providing the `findAll` method to retrieve all countries.
   ```java
   public interface CountryRepository extends JpaRepository<Country, String> {
   }
   ```

3. **CountryService.java**:
   - A service class annotated with `@Service` that uses `CountryRepository` to fetch all countries.
   - The `getAllCountries` method is transactional and returns a list of `Country` entities.
   ```java
   @Service
   public class CountryService {
       @Autowired
       private CountryRepository countryRepository;
       @Transactional
       public List<Country> getAllCountries() {
           return countryRepository.findAll();
       }
   }
   ```

4. **OrmLearnApplication.java**:
   - The main application class annotated with `@SpringBootApplication`.
   - Initializes the Spring context, retrieves the `CountryService` bean, and calls `testGetAllCountries` to fetch and log all countries.
   ```java
   @SpringBootApplication
   public class OrmLearnApplication {
       private static final Logger LOGGER = LoggerFactory.getLogger(OrmLearnApplication.class);
       private static CountryService countryService;
       public static void main(String[] args) {
           ApplicationContext context = SpringApplication.run(OrmLearnApplication.class, args);
           LOGGER.info("Inside main");
           countryService = context.getBean(CountryService.class);
           testGetAllCountries();
       }
       private static void testGetAllCountries() {
           LOGGER.info("Start");
           List<Country> countries = countryService.getAllCountries();
           LOGGER.debug("countries={}", countries);
           LOGGER.info("End");
       }
   }
   ```

5. **OrmLearnApplicationTests.java**:
   - A test class to verify that the Spring context loads correctly.
   ```java
   @SpringBootTest
   class OrmLearnApplicationTests {
       @Test
       void contextLoads() {
       }
   }
   ```

6. **application.properties** (Inferred):
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
1. **Application Startup**: The Spring Boot application starts, initializes the H2 in-memory database, and creates the `country` table based on the `Country` entity.
2. **Console Output**: The `testGetAllCountries` method fetches all countries and logs them. If the database is empty, the output will be an empty list:
   ```
   2025-07-07 19:34:XX.XXX [main] INFO  com.cognizant.orm_learn.OrmLearnApplication - Inside main
   2025-07-07 19:34:XX.XXX [main] INFO  com.cognizant.orm_learn.OrmLearnApplication - Start
   2025-07-07 19:34:XX.XXX [main] DEBUG com.cognizant.orm_learn.OrmLearnApplication - countries=[]
   2025-07-07 19:34:XX.XXX [main] INFO  com.cognizant.orm_learn.OrmLearnApplication - End
   ```
   If you insert sample data (e.g., via H2 console), the output might look like:
   ```
   2025-07-07 19:34:XX.XXX [main] INFO  com.cognizant.orm_learn.OrmLearnApplication - Inside main
   2025-07-07 19:34:XX.XXX [main] INFO  com.cognizant.orm_learn.OrmLearnApplication - Start
   Hibernate: select country0_.co_code as co_code1_0_, country0_.co_name as co_name2_0_ from country country0_
   2025-07-07 19:34:XX.XXX [main] DEBUG com.cognizant.orm_learn.OrmLearnApplication - countries=[Country [code=US, name=United States], Country [code=IN, name=India]]
   2025-07-07 19:34:XX.XXX [main] INFO  com.cognizant.orm_learn.OrmLearnApplication - End
   ```

3. **H2 Database**: You can verify the data in the H2 console by querying:
   ```sql
   SELECT * FROM country;
   ```

## Dependencies
The `pom.xml` (inferred) includes the following key dependencies:
- `spring-boot-starter-data-jpa`: For Spring Data JPA and Hibernate
- `h2`: For the in-memory H2 database
- `spring-boot-starter-test`: For testing
- `slf4j-api`: For logging
