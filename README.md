# Terraform source for use with Proxmox instances

## Getting started
To get started you need to configure the Proxmox instance using the following [guide](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs#creating-the-connection-via-username-and-password).

*Adding the user/role and setting the password*
```
pveum role add TerraformProv -privs "Datastore.AllocateSpace Datastore.AllocateTemplate Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify VM.Allocate VM.Audit VM.Clone VM.Config.CDROM VM.Config.Cloudinit VM.Config.CPU VM.Config.Disk VM.Config.HWType VM.Config.Memory VM.Config.Network VM.Config.Options VM.Migrate VM.Monitor VM.PowerMgmt SDN.Use"
pveum user add terraform-prov@pve --password <password>
pveum aclmod / -user terraform-prov@pve -role TerraformProv
```

The root password should be enough but **using an API token is more preferable**, set one using the [instrucstions under - #2 Determine Authentication Method (use API keys)](https://austinsnerdythings.com/2021/09/01/how-to-deploy-vms-in-proxmox-with-terraform/)

A few important things here to note
* Save the password you used to configure the user during this process
* If you are going to use an API token the same goes
* The password **cannot** contain any special characters