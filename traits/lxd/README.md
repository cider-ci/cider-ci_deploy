LXC/LXD Contaiers Trait for Cider-CI
==================================================================

This role will install LXD and set up access for the `{{ci_executor_exec_user}}`
via the command line and API.

This trait is disabled by default. Set `ci_executor_trait_lxd` to be true to
install this trait.

This trail will work on **Ubuntu Xenial systems only**. LXD is not included in
Debian Jessie. Nothing will happen on Debian Jessie executors!

## API

This role will setup API access for the `{{ci_executor_exec_user}}`. The
address access point is customized (it conflicts with the port used by the
Cider-CI executor process) and exposed via the LXC_API_ADDRESS environment
variable.

Further a key and corresponding certificate are created in the default
locations. See also
<https://www.stgraber.org/2016/04/18/lxd-api-direct-interaction/>.


## Recommended Customization

It is highly recommended to use a ZFS storage pool for containers. Such
a configuration is not included in this role since it is highly customized.
This role will not overwrite the customized storage settings.

