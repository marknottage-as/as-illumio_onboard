# Ansible Playbooks to Onboard/Pair, and Unpair Illumio VENs with AS Linux servers

## Table Of Contents
  1. [Overview](#overview)
  2. [Onboarding](#onboarding)
  2.1 [Roles](#roles)
  3. [Unparing and Uninstalling](#unpairinganduninstalling)
  3.1 [Important Note](#importantnote)
  4. [General Notes](#generalnotes)
  5. [TODOs](#todos)


## Overview
Illumio is a network visibility & control suite that installs a shim driver ("VEN" or "virtual enforcement node") on network nodes ("workloads") allowing centrailzed Dashboarding for visibility and policy enforcement over network data flows. The VEN ("agent") is "onboarded" via shell scripts run on each endpoint or "workload."

Because in some cases there are pre-requisites, I chose to manage this "onboarding" via Ansible playbooks.

Due to a wide variety of environmental issues arising from the AS Enterprise network & remote access, I've incoroporated certain Ansible "quality of life" settings in an "ansible.cfg" local to the playbook working directory.


## Onboarding

The heavy lifting is done by `as-linux_illumio_onboard_bash.yml`

Invoke this playbook thusly:

`$ ansible-playbook -i ./hosts as-linux_illumio_onboard_bash.yml -k -K --ask-pass`

This leverages an "ansible_user" setting done in the "vars" section of the inventory file, and interactively prompts for the SSH and SUDO password.

Alternately, one could comment out "ansible_user" and include `-ansible_user="user.name` on the CLI invocation.

### ROLES
  - main.yml
  The onboarding playbook leverages a role, in `./roles/prereqs/tasks/main.yml`
  
  Based on the Illumio support matrix for RHEL and OUL, main.yml sorts through the specific package requirements for RHEL/OUL 6, 7, 8, and 9

  - TBD
  Placeholder for "check for containerized apps on server"

## Unpairing and Uninstalling
At this time, ITS Compute team doesn't appear to have access to change modes on an installed VEN -- our options are to "onboard" a VEN in "idle" mode, or, if a VEN is causing problems, to "unpair" and "uninstall" the VEN. The latter is accomplished by the `as-linux_illumio_unpair.yml` playbook, with suitable inventory file, and invoked using the same method as the onboarding playbook, i.e.:

`$ ansible-playbook -i ./hosts as-linux_illumio_unpair.yml -k -K --ask-pass`

  ### Important Note 
  When considering "unpairing and uninstalling" -- if it's determined that the Illumio VEN was inadvertently installed on a server used as a platform for Containers, this may be your only option.
  
  To-date we've encounterd several JCTE servers that turned out to be running Docker/Podman, unbeknownst to ITS Compute. The IP filtering rules on those servers appeared to have been fouled up sometime between the initial install/onboard, and changing the operating mode of the VEN from "idle" to "visibility_only" or higher -- meaning "more intrusive into the local IP filtering rules."
  
  The good news is that testing thus far has indicated a relatively simple workflow can return the Containerized application(s) to proper operation:
  - add affected server to an inventory file
  - run the unpair/uninstall playbook
  - restart the endpoint/server/"workload" network stack
  - restart Docker/Podman

## General Notes
- Some additional files are stored within the code tree, for the sake of "overall workflow portability" 

  - files/reference_only/new_inventory_seeds/ contains a PowerShell script that can be leveraged to pull servernames for inventory files directly from VMware RVtools, as well as some XLS sheets that have been manually sorted by Christy
  -  files/reference_only/hosts.* I've been using the hosts.done inventory file to attempt to keep track of which endpoints have had a successful VEN deployment, and hosts.exceptions to track endpoints that fail to onboard (lots more of these, for a variety of reasons, e.g., ITS Compute doesn't have creds, or SSH keys won't connect, or server has been decommissioned, etc.)
  - hosts_rhel87 was a specific list of exceptions due to the "could not create user" issue -- workaround has been identified by Illumio, but we're awaiting a new installer package from them.

## TODOs

  - ADD ROLE TO PRE-SCREEN FOR ANY CONTAINERIZATION SOFTWARE AND FAIL OUT IF FOUND
    * Project sponsors decided containers are "out of scope" for the project at this time
    * Special steps must be taken before VEN installation to prevent fouling up IP filtering rules for Docker/Podman/Kubernetes/etc
    * will either add this as "step 0" to current "prereqs" check, or create a new role and include it BEFORE existing prereqs check
  - implement better ansible authentication
  - TBD