#!/bin/bash

helm3 package k8s-webdav --destination ./docs
helm3 repo index docs --url https://danuk.github.io/k8s-webdav

