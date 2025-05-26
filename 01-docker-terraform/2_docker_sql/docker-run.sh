
docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v c:/Users/jstew/DE_projects/zoomcamp-projects/01-docker-terraform/2_docker_sql/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    postgres:13 


docker run -it \
    -e PGADMIN_DEFAULT_EMAIL='admin@admin.com' \
    -e PGADMIN_DEFAULT_PASSWORD='root' \
    -p 8080:80 \
    --network=pg-network \
    --name pgadmin \
    dpage/pgadmin4

