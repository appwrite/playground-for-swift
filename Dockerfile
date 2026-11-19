FROM swift:6.4.2@sha256:0384f00cf80f81064a907c249a0ad56a1648906f65075a95b1827e88de666e21
WORKDIR /app
COPY Package.swift Package.swift
COPY Package.resolved Package.resolved
RUN swift package resolve
COPY . .
CMD swift run
