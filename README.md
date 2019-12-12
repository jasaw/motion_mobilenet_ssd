# MobileNet SSD model for Motion software

MobileNet SSD model here is intended for use with Intel's [Movidius Neural Compute Stick](https://www.movidius.com) hardware, Intel's [OpenVINO framework](https://software.intel.com/en-us/openvino-toolkit), and [Motion](https://github.com/Motion-Project/motion) software.

Upstream Motion currently only supports pixel change detection algorithm. To use motion with a different detection algorithm like neural network based detection, you could try my [alt_detection motion branch](https://github.com/jasaw/motion/tree/alt_detection) that supports alternate detection plugin. This alternate detection plugin is a generic interface that allows users to use any detection library they want. If you wish to use my MobileNetSSD detection library, head to my [lib_openvino_ssd project](https://github.com/jasaw/lib_openvino_ssd).


## Pre-trained MobileNet SSD files

I downloaded the pre-trained MobileNet SSD files from https://github.com/chuanqi305/MobileNet-SSD and converted them into OpenVINO supported formats (bin and xml files). Note that only full version of OpenVINO comes with model optimizer that does the model conversion.

* Caffe model was from here: https://drive.google.com/open?id=0B3gersZ2cHIxRm5PMWRoTkdHdHc
* Prototxt file was from here: https://raw.githubusercontent.com/chuanqi305/MobileNet-SSD/923b3128f25262b5010cef67e4fb9e4b6728ae7b/voc/MobileNetSSD_deploy.prototxt

To generate the MobileNet SSD graph file, run:

`python3 /opt/intel/openvino/deployment_tools/model_optimizer/mo.py --input_model MobileNetSSD_deploy.caffemodel --data_type FP16 --output_dir . --mean_values [127.5,127.5,127.5] --scale_values [127.5]`

MobileNetSSD expects the input BGR values from 0 to 1, so we add `--mean_values [127.5,127.5,127.5] --scale_values [127.5]` to scale it to 0 - 255.



## How to install and run motion software with MobileNetSSD alternate detection library

1. Install OpenVINO raspbian release (2019-R3) on your Raspberry Pi. Follow the [instructions](https://docs.openvinotoolkit.org/latest/_docs_install_guides_installing_openvino_raspbian.html). Alternatively, you could download the OpenVINO raspbian release [here](https://download.01.org/opencv/2019/openvinotoolkit/) and unpack into `/opt/intel/openvino` directory.
    - `sudo mkdir -p /opt/intel/openvino`
    - `sudo tar -xf  l_openvino_toolkit_runtime_raspbian_p_<version>.tgz --strip 1 -C /opt/intel/openvino`
2. Git clone the [lib_openvino_ssd](https://github.com/jasaw/lib_openvino_ssd) library.
    - `git clone https://github.com/jasaw/lib_openvino_ssd`
3. Build the lib_openvino_ssd library.
    - Install dependencies. `sudo apt-get install libjpeg libavutil-dev libswscale-dev`
    - `cd lib_openvino_ssd`
    - `make -j4`
4. Test the lib_openvino_ssd library.
    - `cd openvino_ssd_test`
    - `make -j4`
    - Copy a few jpg files with people in the images.
    - Edit `../libopenvino.conf` to make sure the **MODEL_BIN** and **MODEL_XML** point to the MobileNetSSD_deploy.bin and MobileNetSSD_deploy.xml respectively.
    - Test the SSD library by running `./ssd_test -l ../libopenvinossd.so -c ../libopenvino.conf photo_1.jpg photo_2.jpg`. Make sure your NCS stick is connected.
    - If the test is successful, it will output png files with the detection result drawn on the png image.
5. Git clone my motion [alt_detection motion branch](https://github.com/jasaw/motion/tree/alt_detection).
    - `git clone -b alt_detection https://github.com/jasaw/motion.git`
6. Build and install motion.
    - Install dependencies. `sudo apt-get install autoconf automake build-essential pkgconf libtool libzip-dev libjpeg-dev git libavformat-dev libavcodec-dev libavutil-dev libswscale-dev libavdevice-dev libwebp-dev gettext libmicrohttpd-dev`
    - `cd motion`
    - `autoreconf -fiv`
    - `./configure`
    - `make -j4`
    - `sudo make install`
7. Specify which alternate detection library to load by adding the below lines in `motion.conf` file.
    - `alt_detection_library /home/pi/lib_openvino_ssd/libopenvinossd.so`
    - `alt_detection_conf_file /home/pi/lib_openvino_ssd/libopenvino.conf`
8. Specify which camera to use alternate detection by adding the below lines in the camera config file, e.g.  `camera-1.conf` file.
    - `alt_detection_enable on`
    - `alt_detection_threshold 75`
