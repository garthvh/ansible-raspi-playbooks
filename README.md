# Ansible Playbooks for Raspberry Pi setup

This is my collection of some simple playbooks, templates and tasks for setup and configuration of my assorted raspberry pi boards and projects. Many common raspberry pi configuration options can now be set using the raspi-config noint mode, for anything else I have found the Ansible [lineinfile](http://docs.ansible.com/ansible/lineinfile_module.html) module is perfect for automating Raspberry Pi setup since much of the configuration is done via text files.

The goal is to do as little manual setup of my raspberry pi projects as possible as well as creating a record of the setup and configuration that can be run again if there is a problem with the SD card, or if I need build another copy of the project. 

So far I have found an easy way in Ansible to complete every step of the setup for my projects. There are a ton of well documented modules in ansible and I was able to easily handle apt, many raspi-config options, git, boot/config.txt settings, making reusable tasks and handlers, setting up wifi with a template, and collecting sensitive inputs with prompts.

##  PiBakery
The first step now for all devices is setting up the sd card basics with [PiBakery](https://www.pibakery.org/) a code blocks pi sd card setup app which is available on Windows, Mac and Linux.  This lets you configure wifi, a public ssh key, locale, keyboard and hostname without having to connect or power on the pi. My settings for PiBakery are available at [here](https://github.com/garthvh/ansible-raspi-playbooks/blob/master/pibakery/pibakery_new.xml). If your project is not too complex, you may be able to save all the required settings to xml using PiBakery and not even have to use Ansible.  

![PiBakery  Screenshot](https://garthvh.com/assets/img/ansible/pibakery.png)

## Ansible Semaphore
Semaphore is an open source GUI for ansible that is an alternative to the Ansible Tower product offered by redhat. I run it in a container and prefir it 

![Semaphore Task Templates Screenshot](https://garthvh.com/assets/img/semaphore/semaphore_task_templates.png)


I have been using semaphore and a mariadb database deployed to docker containers on my NAS device.  For playbooks that use vars_prompts I am passing the prompt variable into the playbook using the "Extra CLI Arguments" box on the semaphore task template. Using the -e (extra vars) CLI argument I am passing in the vars that would be prompted for when running the playbook in bash. I use PiBakery instead of the inital setup script now, but I have kept the new-default playbook up to date.

    ["-e","hostname='your_hostname' wifi_ssid='your_ssid' wifi_password='your_pass'"]

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
+ Set the hostname

You can run the playbook with the following command:

    ansible-playbook -i ~/ansible/hosts playbooks/new-default.yml

The playbook will prompt you for the following items during setup:

+ Hostname
+ WiFi SSID
+ WiFi password

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