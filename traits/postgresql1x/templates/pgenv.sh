export 'PG{{ci_executor_trait_postgresql_version_major}}USER'='{{ci_executor_trait_postgresql_exec_user}}'
export 'PG{{ci_executor_trait_postgresql_version_major}}PORT'='{{ci_executor_trait_postgresql_port}}'
export 'PG{{ci_executor_trait_postgresql_version_major}}PASSWORD'='{{ci_executor_trait_postgresql_exec_user_password}}'
export 'PG{{ci_executor_trait_postgresql_version_major}}DATABASE'='{{ci_executor_trait_postgresql_exec_user}}'

{% if ci_executor_trait_postgresql_is_pg_default  %}

export 'PGUSER'='{{ci_executor_trait_postgresql_exec_user}}'
export 'PGPORT'='{{ci_executor_trait_postgresql_port}}'
export 'PGPASSWORD'='{{ci_executor_trait_postgresql_exec_user_password}}'
export 'PGDATABASE'='{{ci_executor_trait_postgresql_exec_user}}'

{% endif %}
