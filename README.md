# Inception Project

## Overview
Inception is a System Administration project from 42 School focused on virtualization and containerization using Docker. The project requires setting up a small infrastructure of different services using Docker Compose. The main goal is to understand containerization, virtualization, and how to orchestrate multiple services to work together.

## Project Requirements

### Mandatory Part
- Build a small infrastructure composed of different services under specific rules
- Each service must run in a dedicated container
- Containers must be built using Docker Compose
- Each container must use Alpine or Debian as the base image
- Write your own Dockerfiles for each service, which must be called in the docker-compose.yml

### Services
The project requires setting up the following services:

1. **NGINX**: Web server with TLS/SSL
2. **WordPress**: Content Management System
3. **MariaDB**: Database server
4. **Redis** (optional): Caching system
5. **FTP** (optional): File Transfer Protocol server
6. **Adminer** (optional): Database management tool
7. **Static Website** (optional): A simple website

### Network Structure
- All containers must be on the same docker-compose network
- Containers must restart in case of a crash

## Technical Requirements

### NGINX Container
- The only entry point to the infrastructure
- Must handle TLS/SSL connections using self-signed certificates
- Must redirect to WordPress website

### WordPress Container
- Must contain WordPress with all necessary dependencies
- Should not contain NGINX
- Must use PHP-FPM as the PHP processor
- Must connect to MariaDB database

### MariaDB Container
- Must contain MariaDB database
- Database must be persistent even if the container is stopped/restarted
- Volumes must be used for database persistence

### Volumes
- A volume for the WordPress database
- A volume for WordPress website files

### Docker Network
- Set up a Docker network that establishes connection between containers
- Container names, usernames, and passwords must be defined in a `.env` file

## Project Structure

```
inception/
│
├── docker-compose.yml          # Docker Compose configuration
├── .env                        # Environment variables file
│
├── srcs/                       # Source directory 
│   ├── requirements/           # Configuration files for each service
│   │   ├── nginx/              # NGINX configuration
│   │   │   ├── Dockerfile      # NGINX Dockerfile
│   │   │   ├── conf/           # NGINX config files
│   │   │   │   └── nginx.conf  # NGINX configuration
│   │   │   └── tools/          # Scripts for NGINX
│   │   │
│   │   ├── wordpress/          # WordPress configuration
│   │   │   ├── Dockerfile      # WordPress Dockerfile
│   │   │   └── tools/          # Scripts for WordPress
│   │   │
│   │   ├── mariadb/            # MariaDB configuration
│   │   │   ├── Dockerfile      # MariaDB Dockerfile
│   │   │   ├── conf/           # MariaDB config files
│   │   │   └── tools/          # Scripts for MariaDB
│   │   │   
│   │   └── ... (optional services)
│   │
│   └── .env                    # Environment variables (copy of root .env)
│
└── Makefile                    # Automation for building and managing containers
```

## Setup Instructions

### Prerequisites
- Docker and Docker Compose installed
- Basic understanding of containerization concepts
- Basic Linux command-line knowledge

### Steps to Run the Project

1. Clone the repository:
   ```bash
   git clone <repository_url> inception
   cd inception
   ```

2. Create and configure the `.env` file with required variables

3. Build and start the containers:
   ```bash
   make
   ```
   
   or with Docker Compose directly:
   ```bash
   docker-compose up --build
   ```

4. Access WordPress:
   - Open your browser and navigate to: `https://your_login.42.fr`

5. To stop all containers:
   ```bash
   make down
   ```
   
   or with Docker Compose directly:
   ```bash
   docker-compose down
   ```

## Docker and Docker Compose Concepts Used

### Docker
- **Dockerfile**: Script containing instructions to build a Docker image
- **Image**: Blueprint for containers
- **Container**: Running instance of an image
- **Volume**: Persistent data storage for containers
- **Network**: Communication system between containers

### Docker Compose
- **Services**: Container definitions
- **Networks**: Communication between containers
- **Volumes**: Persistent data storage
- **Environment variables**: Configuration settings

## Learning Outcomes
By completing this project, you will gain:

1. Practical experience with Docker and Docker Compose
2. Understanding of system administration concepts
3. Knowledge of how to containerize web applications
4. Experience configuring web servers, databases, and CMS
5. Skills in setting up secure SSL/TLS communication
6. Ability to create persistent data solutions
7. Experience with environment isolation and virtualization

## Common Issues and Troubleshooting

### Container Communication Issues
- Ensure all services are on the same Docker network
- Check service names in docker-compose.yml match the hostnames used in configurations

### Database Connection Problems
- Verify database credentials in the .env file
- Ensure MariaDB service is fully started before WordPress attempts to connect

### SSL Certificate Issues
- Check certificate and key paths in NGINX configuration
- Ensure certificates are properly generated

### Volume Persistence
- Verify volume mounts in docker-compose.yml
- Check permissions on volume directories

## Advanced Tasks
For additional challenges, consider implementing:

1. Load balancing between multiple WordPress instances
2. Automated backup system for the database
3. Monitoring using Prometheus and Grafana
4. CI/CD pipeline for automatic deployment

## Resources
- [How Docker Works](https://www.freecodecamp.org/news/how-docker-containers-work/)
  
- [Docker Volumes]([https://docs.docker.com/](https://semaphore.io/blog/docker-volumes))
  
- [Docker Network]([https://docs.docker.com/compose/](https://medium.com/the-metricfire-blog/understanding-docker-networking-9f81244cf824))
  
- [How NGINX Works ]([https://nginx.org/en/docs/](https://www.solo.io/topics/nginx))
  
- [SSL]([https://wordpress.org/documentation/](https://medium.com/codenx/technology-security-22641732382f))
