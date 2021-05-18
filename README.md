Cider-CI v4  Deploy
===================



## Traits

### git-crypt

See the [traits/git-crypt/README](traits/git-crypt/README.md).


### LXD Containers

See the [traits/lxd/README](traits/lxd/README.md).

### MySQL / MariaDB

See the [traits/mysql/README](traits/mysql/README.md).


### PostgreSQL

See the [traits/postgresql/README](traits/postgresql/README.md).




## Examples

### Installing a new FF ESR version via a Trait

```
python3 -m venv py-venv
source py-venv/bin/activate
pip install -r requirements.txt
ansible-playbook -i ../../ZHdK/inventory/hosts_ci2.yml traits_play.yml -t ci_executor_trait_firefox_esr_78
```

### Registering an executor

```
ansible-playbook -i ../../ZHdK/inventory/hosts_ci2 executors-deploy_play.yml -l ci-fun-swiss-01 -t register-executor -e 'ci_master_secret=SECRET'
```
