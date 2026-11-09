FROM swift:5.7.0@sha256:473744e71c112bb20fe897a3e0d985a6cb8aed98b6a9ae1461df5cf36214cb11
WORKDIR /app
COPY Package.swift Package.swift
COPY Package.resolved Package.resolved
RUN swift package resolve
COPY . .
CMD swift run
