FROM swift:5.7.0
WORKDIR /app
COPY Package.swift Package.swift
COPY Package.resolved Package.resolved
RUN swift package resolve
COPY . .
CMD swift run
