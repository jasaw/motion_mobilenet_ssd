MOBILENET_SSD_CAFFEMODEL   = MobileNetSSD_deploy.caffemodel
MOBILENET_SSD_PROTOTXT     = MobileNetSSD_deploy.prototxt
MOBILENET_SSD_GRAPH        = MobileNetSSD.graph
MOBILENET_SSD_PROTOTXT_URL = https://raw.githubusercontent.com/chuanqi305/MobileNet-SSD/923b3128f25262b5010cef67e4fb9e4b6728ae7b/voc/MobileNetSSD_deploy.prototxt
MOBILENET_SSD_CAFFEMODEL_GOOGLEDOC_ID = 0B3gersZ2cHIxRm5PMWRoTkdHdHc
MOBILENET_SSD_CAFFEMODEL_URL = https://docs.google.com/uc?export=download&id=$(MOBILENET_SSD_CAFFEMODEL_GOOGLEDOC_ID)

all: $(MOBILENET_SSD_GRAPH)

$(MOBILENET_SSD_PROTOTXT):
	@echo "Downloading MobileNet SSD Prototxt file"
	@wget -P . -O $(MOBILENET_SSD_PROTOTXT) https://raw.githubusercontent.com/chuanqi305/MobileNet-SSD/923b3128f25262b5010cef67e4fb9e4b6728ae7b/voc/MobileNetSSD_deploy.prototxt

$(MOBILENET_SSD_CAFFEMODEL):
	@touch /tmp/cookies.txt
	@wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate $(MOBILENET_SSD_CAFFEMODEL_URL) -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=$(MOBILENET_SSD_CAFFEMODEL_GOOGLEDOC_ID)" -O ${MOBILENET_SSD_CAFFEMODEL}
	@rm -f /tmp/cookies.txt

$(MOBILENET_SSD_GRAPH): $(MOBILENET_SSD_CAFFEMODEL) $(MOBILENET_SSD_PROTOTXT)
	@echo "Compiling the trained MobileNet SSD model..."
	@echo "--------------------------------------------------------------------------------"
	@mvNCCompile -w $(MOBILENET_SSD_CAFFEMODEL) -o $(MOBILENET_SSD_GRAPH) -s 12 $(MOBILENET_SSD_PROTOTXT)
	@echo "--------------------------------------------------------------------------------"
	@echo "Trained MobileNet SSD model has been compiled."
	@echo
