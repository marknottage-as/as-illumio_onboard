# as-illumio_onboard
--Ansible Playbooks to Onboard/Pair, and Unpair Illumio VENs with AS Linux servers

Illumio is a network visibility & control suite that installs a shim driver ("VEN" or "virtual enforcement node") on network nodes ("workloads") allowing centrailzed Dashboarding for visibility and policy enforcement over network data flows. The VEN ("agent") is "onboarded" via shell scripts run on each endpoint or "workload."

Because in some cases there are pre-requisites, I chose to manage this "onboarding" via Ansible playbooks.

Due to a wide variety of environmental issues arising from the AS Enterprise network & remote access, I've incoroporated certain Ansible "quality of life" settings in an "ansible.cfg" local to the playbook working directory.


--ONBOARDING

The heavy lifting is done by "as-linux_illumio_onboard_bash.yml"

Invoke this playbook thusly:

$ ansible-playbook -i ./hosts as-linux_illumio_onboard_bash.yml -k -K --ask-pass

This leverages an "ansible_user" setting done in the "vars" section of the inventory file, and interactively prompts for the SSH and SUDO password.

Alternately, one could comment out "ansible_user" and include -ansible_user="user.name" on the CLI invokation.

-ROLES
The onboarding playbook leverages a role, in ./roles/prereqs/tasks/main.yml

Based on the Illumio support matrix for RHEL and OUL, main.yml sorts through the specific package requirements for RHEL/OUL 6, 7, 8, and 9


--UNPAIRING / UNINSTALLING
At this time, ITS Compute team doesn't appear to have access to change modes on an installed VEN -- our options are to "onboard" a VEN in "idle" mode, or, if a VEN is causing problems, to "unpair" and "uninstall" the VEN. The latter is accomplished by the "as-linux_illumio_unpair.yml" playbook, with suitable inventory file, and invoked using the same method as the onboarding playbook.

--NOTES
- Some additional files are stored within the code tree, for the sake of "overall workflow portability" 

  - files/reference_only/new_inventory_seeds/ contains a PowerShell script that can be leveraged to pull servernames for inventory files directly from VMware RVtools, as well as some XLS sheets that have been manually sorted by Christy
  -  files/reference_only/hosts.* I've been using the hosts.done inventory file to attempt to keep track of which endpoints have had a successful VEN deployment, and hosts.exceptions to track endpoints that fail to onboard (lots more of these, for a variety of reasons, e.g., ITS Compute doesn't have creds, or SSH keys won't connect, or server has been decommissioned, etc.)
  - hosts_rhel87 was a specific list of exceptions due to the "could not create user" issue -- workaround has been identified by Illumio, but we're awaiting a new installer package from them.

--TODO

  - ADD ROLE TO PRE-SCREEN FOR ANY CONTAINERIZATION SOFTWARE AND FAIL OUT IF FOUND
    * Project sponsors decided containers are "out of scope" for the project at this time
    * Special steps must be taken before VEN installation to prevent fouling up IP filtering rules for Docker/Podman/Kubernetes/etc
    * will either add this as "step 0" to current "prereqs" check, or create a new role and include it BEFORE existing prereqs check
  - implement better ansible authentication
  - TBD