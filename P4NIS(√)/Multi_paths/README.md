
Before using the 4G LTE module, you need revise, make and install the Linux kernel.

* Change the Linux kernel .config file.
```
sudo make mrproper 
sudo make clean
```

* make sure the following funcitions are supported
```
CONFIG_USB_SERIAL=y
CONFIG_USB_SERIAL_WWAN=y
CONFIG_USB_SERIAL_OPTION=y
CONFIG_USB_USBNET=y
```

* revise the Linux kernel codes
```
## option.c
#define SIMCOM_SIM7600_VID 0x1E0E
#define SIMCOM_SIM7600_PID 0x9001

## add option_ids 
{ USB_DEVICE(SIMCOM_SIM7600_VID, SIMCOM_SIM7600_PID)}, /*SIM7600 */

## filter interface 5
/* sim7600 */
if (serial->dev->descriptor.idVendor == SIMCOM_SIM7600_VID &&
serial->dev->descriptor.idProduct == SIMCOM_SIM7600_PID &&
serial->interface->cur_altsetting->desc.bInterfaceNumber == 5 )
return -ENODEV;

## add simcom_wwan.c

## Makefile
obj-$(CONFIG_USB_USBNET) += usbnet.o simcom_wwan.o

```

* make the Linux kernel
```
make -j4
```

* install the Linux kernel modules
```
make modules_install
```

** If the modules are installed successfully, the syslog file will include the following messages.**
```
usb 1-1: new high speed USB device using rt3xxx-ehci and address 2
option 1-1:1.0: GSM modem (1-port) converter detected
usb 1-1: GSM modem (1-port) converter now attached to ttyUSB0
option 1-1:1.1: GSM modem (1-port) converter detected
usb 1-1: GSM modem (1-port) converter now attached to ttyUSB1
option 1-1:1.2: GSM modem (1-port) converter detected
usb 1-1: GSM modem (1-port) converter now attached to ttyUSB2
option 1-1:1.3: GSM modem (1-port) converter detected
usb 1-1: GSM modem (1-port) converter now attached to ttyUSB3
option 1-1:1.4: GSM modem (1-port) converter detected
usb 1-1: GSM modem (1-port) converter now attached to ttyUSB4
```
