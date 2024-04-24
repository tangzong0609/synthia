FROM python:3.12.3-bullseye

SHELL ["/bin/bash", "-c"]
WORKDIR /app
COPY src /app/src
COPY env /app/env
COPY pyproject.toml /app
COPY poetry.lock /app
COPY README.md /app

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
# RUN . "$HOME/.cargo/env"
# ENV PATH="$HOME/.cargo/bin:$PATH"
RUN curl -sSL https://install.python-poetry.org | python3 - -y

ENV PATH="~/.local/share/pypoetry/venv/bin:${PATH}"
RUN . "$HOME/.cargo/env" && poetry install

#CMD ["tail", "-f", "/dev/null"]
CMD ["/bin/bash"]

#ENTRYPOINT [ "bash", "-c", "poetry" ]
#RUN PATH="~/.local/share/pypoetry/venv/bin:$PATH" && poetry install

