## Build
```shell
docker build ./ -t cube2sphere
```

## Start
```shell
docker run -p {PORT}:8080 -it cube2sphere
```

## Run convert
```shell
curl -X GET 'http://localhost:{PORT}/?baseUrl={IMAGE_BASE_PATH}' -o sphere.jpg
```

IMAGE_BASE_PATH: https://s3-ap-northeast-1.amazonaws.com/suumo-pano/photo/2b/67/123389274

