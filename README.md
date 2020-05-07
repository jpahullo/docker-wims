This image contains WIMS (Web Interactive Multipurpose Server) and many additional software (Maxima, GAP, Povary, Macaulay2, ...). It also contains SSMTP to allow sending email trough a relay host.

The behaviour is controlled by the following environment variables:

    SSMTP_MAILHUB: address of the relay host
    SSMTP_HOSTNAME: hostname which should appear as the originating host of emails

The log directory of WIMS is exported as a volume. Moreover, to ease installation of a logo, if there is a file nameed logo.jpeg in the log directory, it is copied in the public_html directory at startup.
