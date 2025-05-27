docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    --network=pg-network \
    --name pg-database \
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

 URL="C:\Users\jstew\DE_projects\zoomcamp-projects\01-docker-terraform\2_docker_sql\yellow_tripdata_2021-01.csv"

python ingest-data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url="$URL"

docker build -t taxi-ingest:v001 .

docker run -it \
  --network=pg-network \
  -v "C:\Users\jstew\DE_projects\zoomcamp-projects\01-docker-terraform\2_docker_sql\yellow_tripdata_2021-01.csv:/data/yellow_tripdata_2021-01.csv" \
  taxi-ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url="/data/yellow_tripdata_2021-01.csv"

docker run -it \
  --network=pg-network \
  -v "C:/Users/jstew/DE_projects/zoomcamp-projects/01-docker-terraform/2_docker_sql/yellow_tripdata_2021-01.csv:/data/yellow_tripdata_2021-01.csv" \
  taxi-ingest:v001 \
  --user=root \
  --password=root \
  --host=pg-database \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url="http://host.docker.internal:8000/yellow_tripdata_2021-01.csv"





