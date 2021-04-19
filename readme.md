## Build
```shell
docker build ./ -t cube2sphere
```

## Convert
```shell
docker run --rm -v (pwd)/outputs:/outputs -it cube2sphere IMAGE_BASE_PATH OUTPUT_FILE_NAME
```

IMAGE_BASE_PATH: https://s3-ap-northeast-1.amazonaws.com/suumo-pano/photo/2b/67/123389274

