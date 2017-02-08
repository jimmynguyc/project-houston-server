# project-houston-controllers
This project is about controlling Air Conditioner with Raspberry Pi 3 using LIRC library which can be installed using the following command:
```
sudo apt-get install lirc
```
But before executing this command it is better to make sure that everything is up to date by running the following commands:
```
sudo apt-get update
sudo apt-get upgrade
sudo rpi-update
```
If rpi modules are not installed then you can easily install it by running:
```
sudo apt-get install rpi-update
```
Now you are all set to go to the next stage, but in order to be on the safe side, it is better to reboot your pi by running:
```
sudo reboot
```
After installing lirc you can check start or stop it by typing following command:
```
sudo /etc/init.d/lirc start
sudo /etc/init.d/lirc stop
```
The output of the following commands should look something like this:

start:
```
[ ok ] Starting lirc (via systemctl): lirc.service.
```
stop:
```
[ ok ] Stopping lirc (via systemctl): lirc.service.
```
Once lirc is running the the fun part starts. Since I already got the signal from universal remote using arduino, Analysis IR did the rest. 
The codes for Arduino Receiver are inside of Arduino folder.

And then copy the row and paste it in AnalysisIR and convert it to lircd.conf file, which can be found in Air_Conditioner_LIRC_Files and the filename is etc_lirc_lircd.

After that, gpio pins should be specified in two files, boot/config.txt and /etc/modules-load.d/lirc_rpi.conf. For most of the tutorials they use /etc/modules file, but apparently in this case it was not reading the file, so had to safe it this way. This two files can be found in Air_Conditioner_LIRC_Files folder as well.
Then there is one more file that needs to be specified is /etc/lirc/hardware.conf, which contanst all the settings we need to run the irsend command.

After adding updating and adding all this four files into place, now we can run irsend command:
```
sudo lircd
sudo irsend SEND_ONCE Daikin OFF
```
sudo lircd was run in order to start lircd running, but since it's already autonomous, we don't need to run it every time.

That's it for lirc irsend command! Now let's discuss the Apache Server side installation:

```
sudo sudo apt-get install apache2 -y
```
Once installation is done, the default page can be accessed using the ip adrress of the pi or http://localhost/

In order to run the irsend command over web and get the state of it using light sensor, which will indicate whether the aircon is on or off, two python scripts were created, which can be found inside of the Apache folder. 

Well, for now that's it. 

Later add more info. :D
