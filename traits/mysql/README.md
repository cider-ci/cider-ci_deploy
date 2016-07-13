
MySQL / MariaDB Trait for Cider-CI
==================================================================

This role will install  MySQL, respectively MariaDB, and set up access
for the `{{ci_executor_exec_user}}` user.

The environment variables `MYSQL_PASSWORD` and `MYSQL_USER` should be evaluated
to access the database.

The default is to install the MySQL variant. Set
`ci_executor_trait_mysql_variant: mariadb` to install MariaDB instead. The
trait is nevertheless named MySQL!

