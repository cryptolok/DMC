# DMC
A simple decibel-meter converter that shows an approximate distance to a Wi-Fi device

![](https://raw.githubusercontent.com/cryptolok/DMC/master/logo.png)

Dependencies:
* **Aircrack-NG** - a pretty basic toolset for Wi-Fi analysis
	- Airodump-ng - to sniff the wireless traffic
* **Python** - whatever version, only used to simplify the calculations

## How it works

By scanning a Wi-Fi traffic, your antenna will receive different signal power levels from different hosts, measured in dBm (decibel-meter).
This power level can be converted into an approximate distance using some math based on the signal's frequency.

The basic idea is the more strong the signal, the closer you're to the host and vice versa. 

This can be mathematically formalized using [Free-space path loss](https://en.wikipedia.org/wiki/Free-space_path_loss) logarithmic attenuation :

![](https://wikimedia.org/api/rest_v1/media/math/render/svg/d67383c841df29b0a53dc71afe86ae84683232df)

147.55 is the constant which depends on the units, in our case it will be megahertz and meters, with the associated constant equal to 27.55

If we want to calculate the distance we will have to inverse the formula as follows:

![](https://raw.githubusercontent.com/cryptolok/DMC/master/formula.png)

f is the frequency of WiFi in MHz

dBm is the indicated power level

c is our FSPL constant (27.55)

Nonetheless, the following theory doesn't provide any mean to determine the number of obstacles and their nature, although, indicating the power level correctly, the distance may vary.

### HowTo

```bash
sudo apt install aircrack-ng python
chmod u+x dmc.sh
sudo ./dmc.sh 1a:2b:3c:4d:5e:6f
sudo ./dmc.sh 1A:2B:3C:4D:5E:6F 5GHz
```

The first argument is the MAC address of the device you want to calculate the distance to.

The second argument is optional, by default the frequency is 2.4GHz (with a slight offset for various channels), but it's also possible to specify 5GHz (with an even higher offset).

The script however, will temporary disable your wireless interface (wlan0 by default) because of the promiscuous mode. So you will have to restart it manually afterwards.

The result shown every 10s is the approximate distance in meters.

#### Notes

Even if you're using wireless, you're not anonymous.

> "Anonymity breeds irresponsibility."

Masi Oka
