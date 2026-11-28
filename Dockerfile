FROM swift:6.4.3@sha256:e0f67c4120502628d4ced5058df25d334332e21501ae1a0797fd0c0a96486e79
WORKDIR /app
COPY Package.swift Package.swift
COPY Package.resolved Package.resolved
RUN swift package resolve
COPY . .
CMD swift run
