FROM swiftarm/swift:5.5.2-focal-multi-arch
WORKDIR /app
COPY Package.swift Package.swift
COPY Package.resolved Package.resolved
RUN swift package resolve
COPY . .
CMD swift run
