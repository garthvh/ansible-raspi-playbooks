# Ansible Playbooks for Raspberry Pi setup

Some simple playbooks, templates and tasks for setup and configuration of my assorted raspberry pi boards and projects. I have found the Ansible [lineinfile](http://docs.ansible.com/ansible/lineinfile_module.html) module is perfect for automating Raspberry Pi setup since most of the configuration is done via text files.

![Astro Pi Playbook Screenshot](https://garthvh.com/assets/img/ansible/ansible_screenshot.png)

The goal is to do as little manual setup of my raspberry pi projects as possible as well as creating a record of the setup and configuration that could be run again if there was a problem with the SD card, or if I build another copy of the project. 

All of the setup can be done remotely over the network without login, I found that using ethernet was the best way to set up new projects. For Pi Zero and A+ projects without an ethernet port I use a USB ethernet adaptor to do the initial setup. One of the best parts of using ansible for setups is that I can avoid the need to connect a monitor or keyboard for everything but Raspbian Pixel based projects. I have used prompts to collect sensitive data, so it is not stored in the repository.

So far I have found an easy way in Ansible to complete every step of the setup for my projects. There are a ton of well documented modules in ansible and I was able to easily handle apt, git boot/config.txt settings, making reusable tasks and handlers, setting up wifi with a template, installing the SSH key and collecting sensitive inputs with prompts.

## Ansible Semaphore
![Semaphore Task Templates Screenshot](https://garthvh.com/assets/img/semaphore/semaphore_task_templates.png)

All of the playbooks in the repo with the exception of the distribute_ssh playbook are now compatable with the latest version of ansible and work with ansible semaphore.

## Ansible Controller and SSH Keys Setup
I am using a Raspberry Pi 2 B+ model as a server for ansible, I pull down the repository via git and run ansible commands over SSH.

### SSH Keys for login
A SSH key is used to automatically login to each device being managed. 

Set up a public/private keypair on the controller computer you will be running ansible from.

    ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
    cat ~/.ssh/id_rsa.pub

On each device the initial setup script will manage the SSH key for you.

### Ansible hosts file
I have an ansible host file ~/ansible/hosts set up with all of my device hostnames.

    # Hostnames for devices 

    [defaultdevices] # Default hostnames for raspbian and retropie devices 
    retropie
    raspberrypi
    [defaultdevices:vars]
    ansible_user=pi
    ansible_ssh_pass=raspberry

    [picades]    
    elsies-arcade
    markos-arcade
    [picades:vars]
    ansible_user=pi

    [pocketpigrrls]
    elsie-pocket-pigrrl
    violet-pocket-pigrrl
    [pocketpigrrls:vars]
    ansible_user=pi

    [nesclassics]
    vh-pi-nes
    plumis-pi-nes
    millet-pi-nes
    [nesclassics:vars]
    ansible_user=pi

    [projects]
    astro-pi
    alexa-pi-vending
    pi-camera-motion
    pi-camera-timelapse
    pix-e-gif-cam
    [projects:vars]
    ansible_user=pi

    [clusternodes]
    p[1:4]
    [clusternodes:vars]
    ansible_user=pi 

Once the hosts file is in place the ansible controller is all set up and ready to use.

## Raspbian and RetroPie default Installations
The first step of my setup workflow is to run the new-default.yml playbook from the playbooks folder.  

This playbook asumes you have the latest version of [RetroPie](https://retropie.org.uk/download/) or [raspbian](https://www.raspberrypi.org/downloads/raspbian/) installed on a SD card and connected to the network via ethernet.

The new-default.yml playbook will do the following for hosts named "raspberrypi" or "retropie":

+ Expand the filesystem
+ Set Internationalization Options
    * Language
    * Keyboard
    * Culture
    * Timezone
+ Setup WiFi
    * Set WiFi Country
+ Update and Upgrade apt packages
+ Put the ssh key in place
+ Set the hostname

You will need to add the default "raspberry" password and pi user info for the default devices only in your ansible hosts file since this script will put the SSH key in place.

    [defaultdevices] # Default hostnames for raspbian and retropie devices 
    retropie
    raspberrypi
    [defaultdevices:vars]
    ansible_user=pi
    ansible_ssh_pass=raspberry

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/new-default.yml

The playbook will prompt you for the following items during setup:

+ Hostname
+ WiFi SSID
+ WiFi password
+ SSH Key

For Raspbian Pixel based projects I still have to connect the project to a keyboard and monitor once to enable SSH and I2C. 

## Project Playbooks
Each playbook does the remaining setup for each different project using the SSH key installed by the new-default.yml playbook to login.

### Alexa Pi Vending Machine
Housed in the [venduino](http://www.retrobuiltgames.com/diy-kits-shop/venduino/) laser cut wood case there are 5 buttons (4 on the front one on the back), 12 RGB LEDs, 4 continuous rotation servos, an Adafruit servo driver board, a Nokia LCD and a USB CM108 microphone.

![Alexa Pi Vending ](https://garthvh.com/assets/img/ansible/alexa_pi_vending.jpg)

The playbook will prompt you for the following items during setup:

+ Amazon ProductID
+ Amazon ClientID
+ Amazon ClientSecret

This playbook will:

+ Update and Upgrade apt packages
+ Configure boot/config.txt values
+ Download build and install various required libraries for the screen, lights and servos
+ Download and configure with prompt data the Amazon Alexa setup script


### AstroPi - Raspbian Pixel Image
Playbook to set up an AstroPi, this playbook will complete all the steps in the software setup from the [tutorial](https://www.raspberrypi.org/learning/astro-pi-flight-case/worksheet2/) this script will:

+ Update and Upgrade apt packages
+ Configure boot/config.txt values
+ Download the astropi-keys.dtbo file
+ Download astro pi python test file

![AstroPi](https://garthvh.com/assets/img/ansible/astropi.jpg)

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/setup-astropi.yml

### Clusterhat Nodes - Node Images downloaded from [ClusterHat.com](http://clusterhat.com)
Playbook to update nodes in the Clusterhat after writing the SD card, this script will:

+ Expand the filesystem
+ Set Internationalization Options
+ Update and Upgrade apt packages

![ClusterHAT](https://garthvh.com/assets/img/ansible/clusterhat.jpg)

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/setup-clusterhat-nodes.yml

### Mini Nes - RetroPie Image
+ Update and Upgrade apt packages
+ Configure option values in /boot/config.txt file.
    * Audio
    * GPU Memory Split
    * HDMI Screen Settings
+ Configure option values in /etc/rc.local file.

![Mini SNES](https://garthvh.com/assets/img/ansible/mini_snes.jpg)

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/setup-mini-snes.yml

### Motion Security Camera - Raspbian Lite Image
Installs motion dependancies and installs the raspberry pi specific motion binary.

![Pi Cam](https://garthvh.com/assets/img/ansible/picam.jpg)

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/setup-camera-motion.yml

### Pi-Cade - RetroPie Image
Complete setup playbook for the Pi-Cade.

![Pi-Cade](https://garthvh.com/assets/img/ansible/pi-cade.jpg)

+ Update and Upgrade apt packages
+ Configure option values in /boot/config.txt file.
    * Audio
    * GPU Memory Split
    * HDMI Screen Settings
    * USB current for screen
+ Setup [Adafruit Retrogame](https://github.com/adafruit/Adafruit-Retrogame) for GPIO Joystick and buttons
    + Download and Install
    + Set retrogame permissions
    + Put the appropriate retrogame.cfg file in place
    + Set up Retrogame UDEV rule
    + Configure /etc/rc.local

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/setup-retropie-pi-cade.yml

### PIX-E Gif Camera - Raspbian Lite Image

Runs all of the software steps from the [PIX-E Gif Camera](https://community.makezine.com/share/nick-brewer/pix-e-gif-camera-323965) tutorial at make.

![PIX-E](https://garthvh.com/assets/img/ansible/pix-e_1.jpg)

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/setup-camera-pix-e-gif.yml

### Pocket Pigrrl - RetroPie Image Pi 1/Zero

Complete setup playbook for the [Pocket Pigrrl](https://learn.adafruit.com/pocket-pigrrl/overview) from Adafruit.

![Pocket Pigrrls](https://garthvh.com/assets/img/ansible/pocket_pigrrl.jpg)

+ Update and Upgrade apt packages
+ Configure option values in /boot/config.txt file.
    * Audio
    * GPU Memory Split
    * Screen Settings
+ Setup [Adafruit Retrogame](https://github.com/adafruit/Adafruit-Retrogame) for GPIO buttons
    + Download and Install
    + Set retrogame permissions
    + Put the appropriate retrogame.cfg file in place
    + Set up Retrogame UDEV rule
    + Configure /etc/rc.local

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/setup-retropie-pocket-pigrrl.yml

### Wearable Time Lapse Camera - Raspbian Lite Image

Runs all of the software steps from the hard way in the [Wearable Time Lapse Camera](https://learn.adafruit.com/raspberry-pi-wearable-time-lapse-camera/overview) tutorial at Adafruit.

![Wearable Time Lapse Camera](https://garthvh.com/assets/img/ansible/wearable_timelapse_camera.jpg)

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/setup-camera-timelapse.yml

## Creating additional playbooks
I am happy to accept pull requests for additional playbooks or tasks for Pi projects