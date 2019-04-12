LXC/LXD Contaiers Trait for Cider-CI
==================================================================

This role will install LXD and set up access for the `{{ci_executor_exec_user}}`
via the command line and API.

This trait is disabled by default. Set `ci_executor_trait_lxd` to be true to
install this trait.


## API

This role will setup API access for the `{{ci_executor_exec_user}}`. The
address access point is customized (it conflicts with the port used by the
Cider-CI executor process) and exposed via the LXC_API_ADDRESS environment
variable.

Further a key and corresponding certificate are created in the default
locations. See also
<https://www.stgraber.org/2016/04/18/lxd-api-direct-interaction/>.

