# InterAACtionBox-AFSR

The purpose is to build the installation of InterAACtionBox.

### Overview

Part of the InterAACtionBox project.

### Use
* Clone and enter this repository with:
  * `git clone https://github.com/AFSR/InterAACtionBox-AFSR`.
  * `cd InterAACtionBox-AFSR`.
  
* Rum livemedia-creator with:
  * `sudo livemedia-creator --ks InterAACtionBox.ks --logfile /tmp/lmc-logs/livemedia-out.log --no-virt --resultdir /tmp/lmc --project InterAACtionBox-AFSR --make-iso --volid InterAACtionBox-AFSR --iso-only --isoname InterAACtionBox-AFSR-live.iso --releasever 24 --image-name InterAACtionBox-AFSR-live --macboot`
  
* Burn the iso file on your USB with:
  * `sudo dd bs=1M if=InterAACtionBox-AFSR-live.iso of=/dev/sdx conv=fdatasync status=progress`.

* Boot InterAACtionBox from USB
