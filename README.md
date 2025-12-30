```mermaid
---
title: Kubernetes Cluster Architecture
---
graph TB
    subgraph "Kubernetes Cluster"
        direction TB
        
        ingress[("Ingress<br/>NGINX Controller")]
        
        subgraph "Application"
            gw["API Gateway<br/>(YARP)"]
            us["Users Microservice"]
            ns["Notification Microservice"]
        end
        
        subgraph "Message Broker"
            mq[("RabbitMQ")]
        end
        
        subgraph "Data Layer"
            psql[("PostgreSQL")]
            redis[("Redis")]
        end
        
        %% Connections
        ingress --> gw
        
        gw -->|"HTTP<br/>/api/users/\*\*<br/>/api/reset/\**"| us
        
        us -.->|"AMQP<br/>Publish Events"| mq
        ns -.->|"AMQP<br/>Consume Events"| mq
        
        us -->|"Port 5432"| psql
        us -->|"Port 6379"| redis
        
        %% Styling
        class ingress ingressStyle
        class gw gatewayStyle
        class us,ns microserviceStyle
        class mq messageStyle
        class psql,redis databaseStyle
    end
    
    %% Style definitions
    classDef ingressStyle fill:#2e7d32,stroke:#1b5e20,stroke-width:2px,color:white
    classDef gatewayStyle fill:#1565c0,stroke:#0d47a1,stroke-width:2px,color:white
    classDef microserviceStyle fill:#6a1b9a,stroke:#4a148c,stroke-width:2px,color:white
    classDef messageStyle fill:#ff8f00,stroke:#ef6c00,stroke-width:2px,color:white
    classDef databaseStyle fill:#c62828,stroke:#b71c1c,stroke-width:2px,color:white
    classDef cluster fill:#1a237e10,stroke:#3949ab,stroke-width:2px,stroke-dasharray:5 5
```

# My Application Projects:
- [API Gateway](https://github.com/HikashiMlbb/MicroserviceExperiment.Gateway)
- [Users Microservice](https://github.com/HikashiMlbb/MicroserviceExperiment.Users)
- [Notification Microservice](https://github.com/HikashiMlbb/MicroserviceExperiment.Notification)
