# vinstallwp

## Description
vinstallwp is simple bash script to install WordPress on server runing Hestia or Vesta control panel server - Hestia is recommended. This script requires edits to be ready for production usage.
## Requirements
- [WP-CLI](https://wp-cli.org/) installed globally
- REST API enabled
- User must be created manually - this part can be automated but then php scripts must be placed on another server.
- Access to bash enabled for a user

Create file `$HESTIA/data/packages/$package.sh` containing
```bash
mkdir $HOMEDIR/$user/.wp-cli
chown $user:$user $HOMEDIR/$user/.wp-cli
```
where `$package` represents name of package selected for the user and make this file executable. with `chmod +x $HESTIA/data/packages/$package.sh`.

