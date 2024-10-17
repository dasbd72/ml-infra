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

### First Time Setup

1. Set the environment variables in `env/env.sh` and source the file

    ```bash
    source env/env.sh
    ```
  
2. Build and start the services:

    ```bash
    docker-compose up -d mlflow --build
    ```

3. Access the Minio UI at <http://localhost:9000> and login with the credentials in `env/env.sh` and create keys for MLflow
4. Modify `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` in `env/env.sh` with the keys created in Minio and source the file again

    ```bash
    source env/env.sh
    ```

5. Restart the services:

    ```bash
    docker-compose down
    docker-compose up -d mlflow
    ```

6. Access the MLflow UI at <http://localhost:5001> and login with the default credentials

    ```bash
    Username: admin
    Password: admin
    ```

### To reuse the services

1. Source the environment variables `env/env.sh`

    ```bash
    source env/env.sh
    ```

2. Start the services:

    ```bash
    docker-compose up -d mlflow
    ```

### Authentication

1. Attach to the `mlflow` container, or run under a Python environment

    ```bash
    docker exec -it ml-infra-mlflow-1 python
    # or
    python
    ```

2. Example code to create a user and update the user as an admin

    ```python
    import os
    from mlflow.server import get_app_client
    from mlflow.server.auth.client import AuthServiceClient

    os.environ["MLFLOW_TRACKING_USERNAME"] = "admin"
    os.environ["MLFLOW_TRACKING_PASSWORD"] = "admin"
    tracking_uri = "http://localhost:5001/"
    auth_client: AuthServiceClient = get_app_client(
      "basic-auth", tracking_uri=tracking_uri
    )
    auth_client.create_user(username="YOUR_USERNAME", password="YOUR_PASSWORD")
    auth_client.update_user_admin(username="YOUR_USERNAME", is_admin=True)
    ```

## References

- <https://github.com/sachua/mlflow-docker-compose/blob/master/docker-compose.yml>
