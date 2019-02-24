# Automated Raspberry Pi Setup and Updates

This is my collection of some pibakery xml, and ansible playbooks for setup and configuration of my assorted raspberry pi projects. Many common raspberry pi configuration options can be set using the raspi-config noint (non-interactive) mode and for anything else I have found the Ansible [lineinfile](http://docs.ansible.com/ansible/lineinfile_module.html) module is perfect for automating configuration that is done via text files.

The goal is to do as little manual setup of my raspberry pi projects as possible as well as creating a record of the setup and configuration that can be run again if there is a problem with the SD card, or if I need build more copies of a project. 

There is an easy built in way in Ansible to complete every step of the setup for my projects. There are a ton of well documented modules in ansible and I was able to easily handle apt, many raspi-config options, git, boot/config.txt settings, making reusable tasks and handlers, setting up wifi with a template, and collecting sensitive inputs with prompts.

## Prepare the SD Card using  PiBakery
The first step now for all devices is setting up the sd card basics with [PiBakery](https://www.pibakery.org/) a code blocks pi sd card setup app which is available on Windows, Mac and Linux.  This lets you configure wifi, a public ssh key, locale, keyboard and hostname without having to connect or power on the pi. My settings for PiBakery are available at [here](https://github.com/garthvh/ansible-raspi-playbooks/blob/master/pibakery/pibakery_new.xml). If your project is not too complex, you may be able to save all the required settings to xml using PiBakery and not even have to use Ansible.  

![PiBakery  Screenshot](https://garthvh.com/assets/img/ansible/pibakery.png)

## Ansible Semaphore
[Semaphore](https://github.com/ansible-semaphore/semaphore) is an open source web ui for ansible that is an alternative to the Ansible Tower product offered by redhat. I run it in a container and find it a better fit for my home network than tower which needs a more powerful server and has device limits. Semaphore has a simple ui that maps nicely to the structures in Ansible and tracks playbook runs and groups inventory in sensible ways.

![Semaphore Task Templates Screenshot](https://garthvh.com/assets/img/semaphore/semaphore_task_templates.png)

All of my playbooks run fine with or without a Semaphore server, I use it because it lets me keep better track of when playbooks run on what devices.

 For playbooks that use vars_prompts I am passing the prompt variable into the playbook using the "Extra CLI Arguments" box on the semaphore task template. Using the -e (extra vars) CLI argument I am passing in the vars that would be prompted for when running the playbook in bash. I use PiBakery instead of the inital setup script now, but I have kept the new-default playbook up to date.

    ["-e","hostname='your_hostname' wifi_ssid='your_ssid' wifi_password='your_pass'"]

## Project Playbooks wiki
I have added the individual project playbook documentation to the [wiki for this repo](https://github.com/garthvh/ansible-raspi-playbooks/wiki/Playbooks-Wiki).

## Creating additional playbooks
I am happy to accept pull requests for additional playbooks or tasks for Pi projects