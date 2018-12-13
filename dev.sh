#!/bin/bash
docker run --rm -it -v C:$(pwd):C:/code -w C:/code chocolateyfest/chocolatey powershell
