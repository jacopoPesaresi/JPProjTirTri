export

LANGUAGES=abc abf abh aaa
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
	@echo "    all       		Estrazione delle targhe-stringe dalle immagini inserite in "${RAW_PHOTO}""
	@echo "              		I risultati vengono salvati in "${LOG_FILE_DIR}""
	@echo "    onlyOutput		Funziona come "all" ma le immagini in "${RAW_PHOTO}" saranno eliminate"
	@echo "    cropper       	Ritaglio delle targhe in "${CROPPED_PHOTO}" dalle immagini inserite in "${RAW_PHOTO}""
	@echo "    translate       	Trascrizione delle targhe-immagine contenute in "${CROPPED_PHOTO}" "
	@echo "              		in targe-stringe salvate in "${LOG_FILE_DIR}""
	@echo "    clearAll        	Pulisce tutti i file, anche le foto in "${RAW_PHOTO}""
	@echo "    clear        	Pulisce tutti i file generati"
	@echo "    clearP          	Pulisce le immagini inserite in "${RAW_PHOTO}""
	@echo "    clearL          	Pulisce i file di log contenuti in "${LOG_FILE_DIR}""
	@echo "    checkLanguage	Controlla che i linguaggi che si vogliono usare specificati in questo Makefile"
	@echo "              		siano effettivamente presenti all'interno di ${LANG_STORED}"
	@echo ""
	@echo "  Variables"
	@echo ""
	@echo "    RAW_PHOTO		Directory dove vengono messe le foto da cui estrarre le informazioni. Now: ${RAW_PHOTO}"
	@echo "    CROPPED_PHOTO	Directory dove vengono salvate le targhe-immagini ritagliate dalle foto."
	@echo " 			Now: ${CROPPED_PHOTO}/${YOLO_RES}/crops/license plate"
	@echo "    LOG_FILE_DIR	Directory dove vengono salvati i log-file, nonchè i risultati. Now: ${LOG_FILE_DIR}"
	@echo "    LANG_STORED		Directory dove vengono salvati i pesi della rete Tesseract. Now: ${LANG_STORED}"
	

# END-EVAL

default:
ifeq (4.2, $(firstword $(sort $(MAKE_VERSION) 4.2)))
   # stuff that requires make-3.81 or higher
	@echo "    Welcome to JP YOLO+OCR LP reader"
else
	$(error This version of GNU Make is too low ($(MAKE_VERSION)). Check your path, or upgrade to 4.2 or newer.)
endif

.PHONY: help all onlyOutput cropper transalte clear clearP checkLanguage cropperDebug

translate:
	python3 tessusage/byCroppedLPtoString.py
    
cropper:
	-rm -r ${CROPPED_PHOTO}/*
	#mv ${CROPPED_PHOTO}/* tessusage/backup #se si vogliono salvare le foto precedenti
	cd YOLO/yolov5; python detect.py --source ../../${RAW_PHOTO} --weights runs/train/yoloW/weights/best.pt --conf 0.25 --name ${YOLO_RES} --save-crop --nosave --project ../../${CROPPED_PHOTO}

all:
	make cropper
	make translate

onlyOutput:
	make all
	make clearP

clearAll:
	make clear
	make clearP

clear:
	make clearL
	-rm -r ${CROPPED_PHOTO}/*

clearP:
	-rm -r ${RAW_PHOTO}/*

clearL:
	-rm -r ${LOG_FILE_DIR}/*

checkLanguage:
	python3 tessusage/checker.py

cropperDebug:
	-rm -r ${CROPPED_PHOTO}/*
	#mv ${CROPPED_PHOTO}/* tessusage/backup #se si vogliono salvare le foto precedenti
	#-rm -r ${CROPPED_PHOTO}/* #per resettare sempre il processo
	cd YOLO/yolov5; python detect.py --source ../../${RAW_PHOTO} --weights runs/train/yoloW/weights/best.pt --conf 0.25 --name ${YOLO_RES} --save-crop --project ../../${CROPPED_PHOTO}
	#mv YOLO/yolov5/runs/detect/${YOLO_RES}/crops/license\ plate/* ${CROPPED_PHOTO}