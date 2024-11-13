# Production-ready WIMS docker image

This is the starting point for having your production-ready
WIMS docker image.

# What it provides?

The skeleton for you to customize it with your own configuration and files.

Even though it is an skeleton, you can start it "as is" to check it.

# Does it need volumes?

Yes. It is defined to use bind volumes to keep files between service restarts.

For this production-ready version, there is a warm-up phase ONLY for the 
first time the WIMS service is started, where the volume used to bind
`/home/wims/log/` is populated with the initial content from the WIMS image.

This is done this way, since the source directory from the host used in 
bind volumes override the content of the target directory on the container.
It is expected that you will bind and empty directory for that.

The other volume is for `/home/wims/public_html/modules/devel`, but this
directory on the WIMS docker image is empty. So it does not need any
warm up phase.

# Why providing this version on the `/prod` directory?

All these files are though to help you this way:

1. You can build in local by yourself the base WIMS image, using the base /Dockerfile.
2. You, then, can build by yourself the production-ready WIMS image,
 extending the base image, with your own customizations.

For this reason, here there is a copy of some significative files
that will be overriden and other you can add to be overrided, too.

# Customize corporate logo

In this version, there is no logo.jpeg by default. You have to define
it in the Dockerfile or mounting it on the docker-compose.yml.
