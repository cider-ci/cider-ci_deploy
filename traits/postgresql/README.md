PostgreSQL Trait for Cider-CI
==================================================================

This role will install a dedicated PostgreSQL instance and set up access for
the `{{ci_executor_exec_user}}` user.

The instance is distinct from the default PostgreSQL instance on the system!
The default data location is under the `/tmp` directory. Everything will
be recreated from scratch after a reboot!

See the vars defined in `/traits/postgresql/defaults/main.yml` for
customization.
