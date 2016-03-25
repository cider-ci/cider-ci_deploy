Cider-CI v4  Deploy
===================

TODO:

* monitoring for services (including rabbitmq and postgresql)
* monitoring access via http

### Traits


#### Firefox ESR

```yaml
ci_trait_ansible: true
```

This trait installs an ESR version of Firefox. The executable is not in the
PATH by default. The following environment variables (the value points to the
Firefox executable) are exposed:

```
FIREFOX_ESR_PATH=/opt/firefox_45.0.1/firefox
FIREFOX_ESR_45_PATH=/opt/firefox_45.0.1/firefox
```

#### OpenJDK

This trait installs a version of the OpenJDK. The default path to java and
javac executables are not guaranteed to be set to the installed version.

This trait exposes the following environment variables which should in turn to
be used to set `JAVA_HOME` and to extend the `PATH` with `JAVA_HOME/bin` e.g.


