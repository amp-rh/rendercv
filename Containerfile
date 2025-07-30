FROM scratch as src
ADD . .

FROM redhat/ubi9-micro AS base
WORKDIR /app
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/
COPY --from=src . .

FROM base as build
ENV UV_COMPILE_BYTECODE 1
RUN <<EOF
  uv sync --locked
  uv build --wheel
EOF

FROM base AS install
ENV VERSION 2.3
COPY --from=build /app/dist/*.whl .
RUN <<EOF
  uv venv
  uv tool install .[full]
EOF

FROM install AS run
WORKDIR /tmp
ENTRYPOINT ["uv", "tool", "run", "rendercv"]
