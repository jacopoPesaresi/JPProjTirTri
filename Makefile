export

LANGUAGES=abc abf abh
LANG_STORED = tesseractWeights

RAW_PHOTO = inputImages
CROPPED_PHOTO = tessusage/croppedLP

LOG_FILE_DIR = resultLog

YOLO_RES = yoloR

FINISHPATH_CROPPED_PHOTO = ${YOLO_RES}/crops/license plate

help: default
	@echo ""
	@echo "  Targets"
	@echo ""
	@echo "    all       		Given photo into ${RAW_PHOTO}, i'll recognize them into strings. "
	@echo "              		See log file into ${LOG_FILE_DIR}"
	@echo "    onlyOutput		As all but images in ${RAW_PHOTO} will be eliminated"
	@echo "    cropper       	Given photo into ${RAW_PHOTO}, i'll crop them and put results into ${CROPPED_PHOTO}"
	@echo "    translate       	Given cropped photo into ${RAW_PHOTO}, i'll crop them"
	@echo "    clear           	Clear all produces file"
	@echo "    clearP          	Clear all gived images into ${RAWPHOTO}"
	@echo "    checkLanguage	Check that insered language in 
	@echo ""
	@echo "  Variables"
	@echo ""
	@echo "    RAW_PHOTO		Directory where put photos. Now: ${RAW_PHOTO}"
	@echo "    CROPPED_PHOTO	Directory where will summon cropped photos summoned by YOLO. Now: ${CROPPED_PHOTO}/${YOLO_RES}/crops/license plate"
	@echo "    LOG_FILE_DIR	Directory where will saved results. Now: ${LOG_FILE_DIR}"
	

# END-EVAL

default:
ifeq (4.2, $(firstword $(sort $(MAKE_VERSION) 4.2)))
   # stuff that requires make-3.81 or higher
	@echo "    Welcome to JP YOLO+OCR LP reader"
else
	$(error This version of GNU Make is too low ($(MAKE_VERSION)). Check your path, or upgrade to 4.2 or newer.)
endif

.PHONY: help all onlyOutput cropper transalte clear clearP checkLanguage

translate:
	python3 tessusage/byCroppedLPtoString.py
    
cropper:
	-rm -r ${CROPPED_PHOTO}/*
	#mv ${CROPPED_PHOTO}/* tessusage/backup #se si vogliono salvare le foto precedenti
	#-rm -r ${CROPPED_PHOTO}/* #per resettare sempre il processo
	cd YOLO/yolov5; python detect.py --source ../../${RAW_PHOTO} --weights runs/train/yoloW/weights/best.pt --conf 0.25 --name ${YOLO_RES} --save-crop --nosave --project ../../${CROPPED_PHOTO}
	#mv YOLO/yolov5/runs/detect/${YOLO_RES}/crops/license\ plate/* ${CROPPED_PHOTO}

all:
	make cropper
	make translate

onlyOutput:
	make all
	make clearP

clear:
	-rm resultLog/*
	-rm resultLog/*

clearP:
	-rm -r ${RAW_PHOTO}/*

checkLanguage:
	python3 tessusage/checker.py
