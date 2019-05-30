FROM ruby:2.6.1 as builder

WORKDIR /build
COPY . .
RUN gem build moonrelay.gemspec
RUN mv moonrelay*.gem moonrelay.gem

FROM ruby:2.6.1

COPY --from=builder /build/moonrelay.gem .
RUN gem install moonrelay.gem
ENTRYPOINT [ "/bin/bash" ]
