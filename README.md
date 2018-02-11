# Ansible Playbooks for Raspberry Pi setup

Some simple playbooks, templates and tasks for setup and configuration of my assorted raspberry pi boards and projects. I have found the Ansible [lineinfile](http://docs.ansible.com/ansible/lineinfile_module.html) module is perfect for automating Raspberry Pi setup since most of the configuration is done via text files.

The goal is to do as little manual setup of my raspberry pi projects as possible as well as creating a record of the setup and configuration that could be run again if there was a problem with the SD card, or if I build another copy of the project. 

All of the setup can be done remotely over the network without login, I found that using ethernet was the best way to set up new projects. Just make sure you add an empty file named `ssh` in the `/boot` directory of the RPI before you plug the micro sd into the RPi. This will enable SSH access right off the bat.

### SSH Keys for login
A SSH key is used to automatically login to each device being managed. 

Set up a public/private keypair on the controller computer you will be running ansible from.

    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub

On each device the initial setup script will manage the SSH key for you.

### Ansible hosts file
I have an ansible host file ~/ansible/hosts set up with all of my device hostnames.

    # Hostnames for devices 

    [defaultdevices]
    192.168.1.xxx
    [defaultdevices:vars]
    ansible_user=pi
    ansible_ssh_pass=raspberry

## Raspbian and RetroPie default Installations
The first step of my setup workflow is to run the base_setup.yml playbook from the playbooks folder.  

This playbook asumes you have the latest version of [raspbian](https://www.raspberrypi.org/downloads/raspbian/) installed on a SD card and connected to the network via ethernet. Be sure that you've put an empty file with the name `ssh` in the root (`/`) boot directory so ssh will be toggled on automatically. Otherwise you'll have to connect peripherals to set everything up. If you do not have a formatted SD card, you can follow the instructions in the section below entiteld "Mounting an OS"

The base_setup.yml playbook will do the following for hosts listed in the [defaultdevices] section:

+ Expand the filesystem
+ Set Internationalization Options
    * Language
    * Keyboard
    * Culture
    * Timezone
+ Set up ssh keys
+ Update and Upgrade apt packages
+ Install the latest version of python (or the version of your preference)
+ Install base python modules (like virtualenv and virtualenvwrapper)
+ Put the ssh key in place
+ Set the hostname

You will need to add the default "raspberry" password and pi user info for the default devices only in your ansible hosts file since this script will put the SSH key in place.

    [defaultdevices] # Default hostnames for raspbian and retropie devices 
    192.168.1.xxx
    [defaultdevices:vars]
    ansible_user=pi
    ansible_ssh_pass=raspberry

You can run the playbook with the following command:

    ansible-playbook playbooks/base_setup.yml -i hosts --ask-pass --become -c paramiko

The playbook will prompt you for the following items during setup:

+ Hostname
+ SSH Key
+ Preferred python version (other than 2.7)

## Mounting an OS
Download an RPi OS image [here](https://www.raspberrypi.org/downloads/).

Follow the OS installation instructions [here](https://www.raspberrypi.org/documentation/installation/installing-images/README.md). There are pecific instructions for MacOS process [here](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md).

Download [Etcher](https://etcher.io/) for a GUI install. Command line instructions [here](https://www.raspberrypi.org/documentation/installation/installing-images/mac.md) if not using GUI (advanced).

Once mounted, add an empty file named `ssh` in the root directory (see the 3rd item in [this guide](https://www.raspberrypi.org/documentation/remote-access/ssh/) for more info on why this is needed.