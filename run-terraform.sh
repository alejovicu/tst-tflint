#!/usr/bin/env bash

docker run -it --rm -v $(pwd):/data broadinstitute/terraform $*