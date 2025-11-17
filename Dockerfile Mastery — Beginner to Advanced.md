# Dockerfile Mastery — Beginner to Advanced

> A comprehensive, example-heavy guide to Dockerfiles, formatted as Markdown for Obsidian. Each section includes explanation, best practices, and **5 examples** you can copy-paste and test.

---

## Table of Contents

1. Introduction & prerequisites
2. Dockerfile basics
   - `FROM`
   - `RUN`
   - `CMD` vs `ENTRYPOINT`
   - `LABEL`
   - `ENV`
   - `ARG`
   - `COPY` and `ADD`
   - `WORKDIR`
   - `USER`
   - `VOLUME`
   - `EXPOSE`
   - `HEALTHCHECK`
   - `STOPSIGNAL`
   - `SHELL`
3. Build context and `.dockerignore`
4. Multi-stage builds
5. Caching, layers & optimization
6. Secrets, build args and BuildKit features
7. Image size, provenance & security best practices
8. Advanced patterns and real-world examples
9. Troubleshooting & debugging
10. Cheat sheet & quick reference

---

## 1. Introduction & prerequisites

**What this guide assumes:** basic familiarity with the command line, Docker installed (Docker Desktop or engine), and an editor (Obsidian will render this Markdown nicely).

**How to run examples:**

- Save a Dockerfile alongside any referenced files.
- Run `docker build -t <tag> .` in the directory containing the Dockerfile.
- Run the image with `docker run --rm -it <tag>` and add `-p` or `-v` flags as the examples require.

---

## 2. Dockerfile basics

### `FROM` — base image

`FROM` is mandatory and must be the first non-comment instruction. It sets the base image for subsequent commands.

**Key notes:**

- You can reference images by name and tag (e.g., `python:3.11-slim`).
- Use digests for immutable builds (e.g., `alpine@sha256:...`).
- Multi-stage builds use multiple `FROM` instructions.

#### 5 Examples — `FROM`

1. Simple official image

```Dockerfile
FROM alpine:3.19
CMD ["/bin/sh"]
```

2. Specific tag for reproducibility

```Dockerfile
FROM node:18.17.1
WORKDIR /app
COPY . .
RUN npm ci
CMD ["node", "index.js"]
```

3. Using a digest (immutable)

```Dockerfile
FROM alpine@sha256:3f7e6e...  # replace with real digest
RUN echo "immutable base"
```

4. Multi-stage start (named stage)

```Dockerfile
FROM golang:1.21 as builder
WORKDIR /src
COPY . .
RUN go build -o /out/app ./...
```

5. Platform selection (Buildx / BuildKit aware)

```Dockerfile
# hint only — used during build with --platform flag
FROM --platform=$BUILDPLATFORM ubuntu:24.04
RUN uname -m && echo "built for $BUILDPLATFORM"
```

---

### `RUN` — execute commands during build

`RUN` executes shell commands and commits the result to the image as a new layer.

**Best practices:**

- Combine related steps in a single `RUN` to reduce layers.
- Use `&&` and `\` line breaks for readability.
- Clean package caches (e.g., `apt-get clean` or `rm -rf /var/lib/apt/lists/*`).

#### 5 Examples — `RUN`

1. Installing packages (Alpine)

```Dockerfile
FROM alpine:3.19
RUN apk add --no-cache bash curl
CMD ["bash"]
```

2. Debian/Ubuntu package install with cleanup

```Dockerfile
FROM ubuntu:24.04
RUN apt-get update \
 && apt-get install -y --no-install-recommends ca-certificates curl \
 && rm -rf /var/lib/apt/lists/*
```

3. Chaining build steps

```Dockerfile
FROM node:18
WORKDIR /app
COPY package*.json ./
RUN npm ci --production && npm cache clean --force
COPY . .
```

4. Creating files and setting permissions

```Dockerfile
FROM alpine
RUN addgroup -S app && adduser -S -G app app \
 && mkdir /data && chown app:app /data
USER app
```

5. Using bash -c with conditions (complex step)

```Dockerfile
FROM ubuntu
RUN bash -c 'if [ -f /etc/debian_version ]; then echo debian; else echo unknown; fi'
```

---

### `CMD` vs `ENTRYPOINT`

- `CMD` provides default arguments to `docker run` or a default command if `ENTRYPOINT` is not set.
- `ENTRYPOINT` sets the fixed executable and `CMD` provides default args to it.
- Both have exec form (JSON array) and shell form (string). Prefer exec form for predictable behavior.

#### 5 Examples — `CMD` and `ENTRYPOINT`

1. Simple CMD (exec form)

```Dockerfile
FROM python:3.11-slim
COPY app.py /app/app.py
CMD ["python", "/app/app.py"]
```

2. ENTRYPOINT with CMD as default args

```Dockerfile
FROM alpine
ENTRYPOINT ["/bin/sh", "-c"]
CMD ["echo hello from entrypoint"]
```

3. Entrypoint + overrideable CMD

```Dockerfile
FROM ubuntu
ENTRYPOINT ["/usr/bin/myserver"]
CMD ["--port", "8080"]
```

4. Shell form (less recommended)

```Dockerfile
FROM busybox
CMD echo "hello"
```

5. Using exec form to receive `docker run` parameters

```Dockerfile
FROM golang:1.21
COPY app /usr/local/bin/app
ENTRYPOINT ["/usr/local/bin/app"]
# docker run image --help will pass --help to the app
```

---

### `LABEL`

Metadata for images. Use keys like `maintainer`, `org.opencontainers.image.*` for provenance.

#### 5 Examples — `LABEL`

1. Simple maintainer label

```Dockerfile
FROM alpine
LABEL maintainer="Sagar Duvva <you@example.com>"
```

2. Multiple labels

```Dockerfile
LABEL org.opencontainers.image.title="my-app" \
      org.opencontainers.image.version="1.0.0"
```

3. Using label for build info

```Dockerfile
ARG BUILD_DATE
ARG VCS_REF
LABEL org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.revision=$VCS_REF
```

4. JSON-style label (exec-friendly)

```Dockerfile
LABEL version="1.0" description="A small demo image"
```

5. Labels for automated scanners

```Dockerfile
LABEL com.example.vendor="acme" com.example.license="MIT"
```

---

### `ENV` — environment variables persisted in image

`ENV` sets environment variables available at build time and runtime (in the image). Use `ARG` for build-only values.

#### 5 Examples — `ENV`

1. Simple ENV

```Dockerfile
FROM node
ENV NODE_ENV=production
CMD ["node","app.js"]
```

2. ENV referencing other ENVs

```Dockerfile
FROM python
ENV APP_HOME=/app
WORKDIR $APP_HOME
```

3. Multi-line ENV

```Dockerfile
FROM alpine
ENV DB_HOST=postgres \
    DB_PORT=5432 \
    DB_USER=app
```

4. Sensitive-ish variable (not secret, still in image)

```Dockerfile
FROM nginx
ENV API_ENDPOINT=https://api.example.com
```

5. Use ENV to reduce duplication

```Dockerfile
FROM golang
ENV GOPATH=/go
ENV PATH=$PATH:$GOPATH/bin
```

---

### `ARG` — build arguments (build-time only)

`ARG` values are available during build and can have defaults. They are not persisted in the final runtime image unless also declared with `ENV`.

#### 5 Examples — `ARG`

1. Basic ARG with default

```Dockerfile
FROM alpine
ARG TARGETPLATFORM=linux/amd64
RUN echo "building for $TARGETPLATFORM"
```

2. Using ARG to pass versions

```Dockerfile
ARG NODE_VERSION=18
FROM node:${NODE_VERSION}
```

3. Secure-ish build token (still visible in image history unless using BuildKit secrets)

```Dockerfile
ARG GITHUB_TOKEN
RUN echo $GITHUB_TOKEN > /tmp/token.txt
```

4. Promote ARG to ENV if needed at runtime

```Dockerfile
ARG APP_ENV=production
ENV APP_ENV=$APP_ENV
```

5. Using ARG in multi-stage builds

```Dockerfile
ARG BASE=python:3.11-slim
FROM ${BASE} as runtime
```

---

### `COPY` and `ADD`

- `COPY` copies files from build context into the image. Prefer `COPY` for clarity.
- `ADD` can also extract local tar archives and fetch remote URLs (avoid remote fetch in Dockerfile for reproducibility).

#### 5 Examples — `COPY` and `ADD`

1. Simple copy

```Dockerfile
FROM alpine
WORKDIR /app
COPY . /app
```

2. Copy with files and patterns

```Dockerfile
COPY package.json package-lock.json /app/
```

3. Using `.dockerignore` to limit context (see later)

```Dockerfile
# Dockerfile
FROM node
WORKDIR /app
COPY . .
RUN npm ci --only=production
```

4. ADD to extract tar (local)

```Dockerfile
FROM alpine
ADD app.tar.gz /opt/app
```

5. ADD remote (not recommended)

```Dockerfile
# unreproducible if the remote changes
FROM alpine
ADD https://example.com/somefile /tmp/somefile
```

---

### `WORKDIR`

Sets working directory. If it doesn't exist, Docker will create it.

#### 5 Examples — `WORKDIR`

1. Basic WORKDIR

```Dockerfile
FROM node
WORKDIR /usr/src/app
COPY . .
CMD ["node","index.js"]
```

2. Multiple WORKDIRs (changes context)

```Dockerfile
FROM python
WORKDIR /app
COPY . .
WORKDIR /app/subdir
RUN ls -la
```

3. Using ENV with WORKDIR

```Dockerfile
FROM alpine
ENV APP_DIR=/srv/app
WORKDIR $APP_DIR
```

4. Relative WORKDIR

```Dockerfile
FROM ubuntu
WORKDIR /opt
WORKDIR app
# path becomes /opt/app
```

5. RUN will use WORKDIR

```Dockerfile
FROM alpine
WORKDIR /app
RUN touch hello.txt
```

---

### `USER`

Switches user for subsequent commands and at runtime. Avoid running as root in production images.

#### 5 Examples — `USER`

1. Create and switch to a user

```Dockerfile
FROM alpine
RUN adduser -D appuser
USER appuser
CMD ["/bin/sh"]
```

2. Specify UID\:GID

```Dockerfile
FROM ubuntu
RUN groupadd -r app && useradd -r -g app app
USER app
```

3. Use USER only at runtime, keep build root

```Dockerfile
FROM node
RUN npm ci --production
USER node
CMD ["node","server.js"]
```

4. Mix permissions change before switching

```Dockerfile
FROM alpine
RUN adduser -D app && mkdir /data && chown app:app /data
USER app
```

5. Revert to root later (possible but usually avoid)

```Dockerfile
FROM ubuntu
RUN useradd -m developer
USER developer
# do some user tasks
USER root
RUN apt-get update
```

---

### `VOLUME` and `EXPOSE`

- `VOLUME` declares mount points for runtime; it affects caching and persistence.
- `EXPOSE` documents ports and can inform tooling — does not publish them to host by itself.

#### 5 Examples — `VOLUME` & `EXPOSE`

1. Simple EXPOSE

```Dockerfile
FROM nginx
EXPOSE 80
```

2. Volume for persistent app data

```Dockerfile
FROM postgres:15
VOLUME ["/var/lib/postgresql/data"]
```

3. Named mountpoint example

```Dockerfile
FROM alpine
VOLUME /cache
RUN echo "cache dir" > /cache/readme.txt
```

4. EXPOSE multiple ports

```Dockerfile
FROM myapp
EXPOSE 8080 9090
```

5. Combining EXPOSE and default CMD

```Dockerfile
FROM node
WORKDIR /app
COPY . .
EXPOSE 3000
CMD ["node","server.js"]
```

---

### `HEALTHCHECK`

Probes used by Docker to determine container health. Use `NONE` to disable inherited checks.

#### 5 Examples — `HEALTHCHECK`

1. Simple curl healthcheck

```Dockerfile
FROM alpine
RUN apk add --no-cache curl
HEALTHCHECK --interval=30s --timeout=5s --retries=3 CMD curl -f http://localhost:8080/health || exit 1
```

2. Use a script for healthcheck

```Dockerfile
FROM alpine
COPY healthcheck.sh /usr/local/bin/healthcheck
HEALTHCHECK CMD ["/usr/local/bin/healthcheck"]
```

3. Disable healthcheck

```Dockerfile
FROM nginx
HEALTHCHECK NONE
```

4. Lightweight tcp check with nc (netcat)

```Dockerfile
FROM alpine
RUN apk add --no-cache busybox-extras
HEALTHCHECK CMD nc -z localhost 22 || exit 1
```

5. Dockerfile hea
