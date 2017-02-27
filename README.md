# Quickstart

```bash
docker run -d --name fitnesse -p 2222:8080 bzon/adop-fitnesse
```

# Quickstart with Sample Petclinic App for Demo

```bash
./compose up -d
```

# Running with Selenium Grid stack only

```bash
docker-compose up -d
```

# Access the Applications

- FitNesse - http://localhost:2222  
- Selenium Grid - http://localhost:4444
- PetClinic - http://localhost:9966/petclinic  
- PetClinic Swagger UI - http://localhost:9966/petclinic/swagger-ui.html  
- MySQL - localhost:3306/petclinic  
