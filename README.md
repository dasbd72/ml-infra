# ML Infra

A simple machine learning infrastructure for training and logging models.

## Docker Compose Services

- `minio`
  - Image: `minio/minio:RELEASE.2024-10-02T17-50-41Z-cpuv1`
  - Ports:
    - 9000:9000
    - 9001:9001
  - Environment Variables:
    - `MINIO_ROOT_USER`
    - `MINIO_ROOT_PASSWORD`
- `db`
  - Image: `postgres:16.4-bullseye`
  - Ports:
    - 5432:5432
  - Environment Variables:
    - `POSTGRES_USER`
    - `POSTGRES_PASSWORD`
    - `POSTGRES_DB`
- `mlflow`
  - Image: Builds from `dockerfile` in `./mlflow`
  - Ports:
    - 5001:5001
  - Environment Variables:
    - `MINIO_ROOT_USER`
    - `MINIO_ROOT_PASSWORD`
    - `POSTGRES_USER`
    - `POSTGRES_PASSWORD`
    - `POSTGRES_DB`

## Usage

1. Set the environment variables in `env/env.sh`

    ```bash
    source env/env.sh
    ```

2. Start the services:

    ```bash
    docker-compose up -d --build
    ```

3. Access the Minio UI at <http://localhost:9000> and login with the credentials in `env/env.sh`
4. Access the MLflow UI at <http://localhost:5001> and login with the credentials in `env/env.sh`

## References

- <https://github.com/sachua/mlflow-docker-compose/blob/master/docker-compose.yml>
