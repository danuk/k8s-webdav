#!/bin/bash

helm package k8s-webdav --destination ./docs
helm repo index docs --url https://danuk.github.io/k8s-webdav

