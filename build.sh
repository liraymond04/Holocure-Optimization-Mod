#!/bin/bash

docker buildx build --network host --output type=local,dest=build .