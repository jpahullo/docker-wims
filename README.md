# WIMS

This docker image contains [WIMS (Web Interactive Multipurpose Server)](https://wimsedu.info/) together with additional support software (Gnuplot, Graphviz, Povray, PARI/GP, Maxima, Octave, GAP, Yacas, Macaulay2 and others). The log directory of WIMS is exported as a volume. I hope this is the only directory we need to preserve when rebuilding containers. It seems to be enough, at least for classes and general configuration.

At startup, the `log/logo.jpeg` file is copied into `public_html/logo.jpeg`, in order to ease the installation of an institutional logo. If `log/logo.jpeg` does not exist, then `public_html/logo.jpeg` is deleted.

The image also contains sSMTP and some additional mail utilities, which allow WIMS to send emails trough a relay host. The behaviour of sSMTP is controlled by the following environment variables:
  * `SSMTP_MAILHUB`: address of the relay host
  * `SSMTP_HOSTNAME`: hostname which should appear as the originating host of emails

The image may be used behind a reverse proxy by setting the environment variable `REVERSE_PROXY` to its IP address. This will instruct WIMS to trust the `X-Forwarded-For` and `X-Forwarded-Proto` headers coming from the reverse proxy. Unfortunately, this image lacks support for TLS when WIMS does not run behind a proxy.

## Example deployment

This an example of `docker-compose.yml` usable for deployment of the image trough Docker Compose:

```yaml
version: '3.2'

volumes:
  wims:

services:
  app:
    image: amatogianluca/wims
    security_opt:
      - seccomp:unconfined
    hostname: wims
    restart: always
    volumes:
      - wims:/home/wims/log:Z
    environment:
      - SSMTP_MAILHUB=<relay host>
      - SSMTP_HOSTNAME=<originating hostname>
      - REVERSE_PROXY=yes
    ports:
      - 127.0.0.1:10000:80
```
Since Maxima uses the `personality` system call, which is normally banned within a container, we need a custom seccomp profile, or to disable seccomp altogether (the solution adopted in the example, although it is not the one I would recommend). The page [Seccomp security profiles for Docker](https://docs.docker.com/engine/security/seccomp/) gives more details on seccomp profiles.

 In the example above, the HTTP port of the container is exported as port 10000 in localhost. It can be later remapped to the `/wims` directory of the host using a reverse proxy, as in the following snippet of an Apache config file:

 ```apache
 <Location /wims>
  ProxyPass http://127.0.0.1:10000/wims
  ProxyPassReverse http://127.0.0.1:10000/wims
  ProxyPreserveHost On
  RequestHeader set X-Forwarded-Proto https
</Location>
```

Note the use of `RequestHeader set X-Forwarded-Proto https` to make WIMS believe to be operating in HTTPS, even if the internal connection between the proxy and the WIMS server is HTTP. Obviously, the host must use HTTPS with the external world for the previous snippet to work.
