
Test Locally:

```shell
docker build -f Dockerfile-infra -t assignment_engine:local .
docker run -p 9000:8080 assignment_engine:local
```

```shell
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```