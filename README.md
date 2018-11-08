# MobileNet SSD model for Motion software

MobileNet SSD model here is intended for use with Intel's [Movidius Neural Compute Stick](https://www.movidius.com) and [Motion](https://github.com/Motion-Project/motion) software.

Upstream Motion software currently does not support Movidius yet, but if you are looking to try out Motion with Movidius support, head to my [movidius branch](https://github.com/jasaw/motion/tree/movidius).

## How to install and run my movidius branch motion software

1. Install Movidius NCSDKv2. Follow the [installation manual](https://movidius.github.io/ncsdk/install.html). Note that the NCSDKv2 may screw up your existing libraries, so I recommend trying this on a sacrificial machine. Alternatively, you could try installing just the API by running `sudo make api` (I have **not** tested this one).
2. Git clone the [movidius branch](https://github.com/jasaw/motion/tree/movidius) into any directory you like.
3. Go into the directory and run:
    - `autoreconf -fiv`
    - `./configure`
    - `make`
    - `sudo make install`
4. Download the [MobileNet SSD graph file](https://github.com/jasaw/motion_mobilenet_ssd/raw/master/MobileNetSSD.graph).
5. Add MVNC related configuration items to `thread-1.conf` file.
    - `mvnc_enable on` : This will bypass the original motion detection algorithm and use MVNC instead.
    - `mvnc_graph_path MobileNetSSD.graph` : Path to MobileNetSSD graph. Other neural net models are not supported.
    - `mvnc_classification person,cat,dog,car` : A comma separated classes of objects to detect.
    - `mvnc_threshold 75` : This is confidence threshold in percentage, which takes a range from 0 to 100 as integer. A detected person is only considered valid if the neural net confidence level is above this threshold. `75` seems like a good starting point.


## MobileNet SSD graph file

* [MobileNet SSD graph file for Movidius NCS](https://github.com/jasaw/motion_mobilenet_ssd/raw/master/MobileNetSSD.graph)


## Pre-trained MobileNet SSD files

I downloaded the pre-trained MobileNet SSD files from https://github.com/chuanqi305/MobileNet-SSD and compiled them into a graph file.

* Caffe model was from here: https://drive.google.com/open?id=0B3gersZ2cHIxRm5PMWRoTkdHdHc
* Prototxt file was from here: https://raw.githubusercontent.com/chuanqi305/MobileNet-SSD/923b3128f25262b5010cef67e4fb9e4b6728ae7b/voc/MobileNetSSD_deploy.prototxt

To generate the MobileNet SSD graph file, go to motion directory and run:

`make MobileNetSSD.graph`
