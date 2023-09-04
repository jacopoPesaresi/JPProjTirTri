import cv2 
import pytesseract
#import preprocessing
import os

os.environ["TESSDATA_PREFIX"] = os.environ["LANG_STORED"]

tessdataUsed = []
langs = os.listdir(os.environ["LANG_STORED"]) #dove storicizzo i .traineddata

sss = os.environ["LANGUAGES"] # quelli che desidero per questa esecuzione
ss = list(sss.split())
for s in ss:
    print("Cerco", s, ":")
    ext = ".traineddata"
    try:
        langs.index(s + ext)
        print("Linguaggio", s, "trovato; \n")
        tessdataUsed.append(s)
    except:
        print("Linguaggio", s, "NON trovato; \n")
    

croppedLPdir = os.environ["CROPPED_PHOTO"] + "/" + os.environ["FINISHPATH_CROPPED_PHOTO"]

#print(tessdataUsed)

#### OCR SCRIPT ####

logDir = os.environ["LOG_FILE_DIR"]
#logDir = "resultLog"

thisOutFileName = "thisRes.txt"
mapOutFileName = "mapRes.txt"
allOutFileName = "allRes.txt"

thisLogs = [thisOutFileName, mapOutFileName]
allLogs = [allOutFileName]
Logs = [thisOutFileName, allOutFileName]

f = open(logDir + "/" + thisOutFileName, 'w')
f.write("\n")
f.close()
f = open(logDir + "/" + mapOutFileName, 'w')
f.write("\n")
f.close()


def printOnMap(toPrint, imageName, language):
    f = open(logDir + "/" + mapOutFileName, 'a')
    f.write(language + ") " + imageName + " -> " + toPrint + "\n")
    f.close()

def printSeparatorOnMap(amount):
    sep = "#" * amount + "\n"
    if amount > 10:
        sep = "\n " + sep
    
    f = open(logDir + "/" + mapOutFileName, 'a')
    f.write(sep)
    f.close()

def managePrints(toPrint):
    print(toPrint)
    for logN in Logs:
        f = open(logDir + "/" + logN, 'a')
        f.write("§NLP§) " + toPrint + "\n")
        f.close()
    

def manageConversion(path):
    #print(path)
    img = cv2.imread(path)
    #gray = preprocessing.get_grayscale(img)
    #thresh = preprocessing.thresholding(gray)
    #opening = preprocessing.opening(gray)
    #canny = preprocessing.canny(gray)
    #aaa = [img, gray, thresh, opening, canny]
    typeImages = [img]
    #lll = ["jjj", "lat", "com", "nda", "ndb"]
    #lll = ["eng", "nna", "nnb", "nnc"]
    #lll = ["eng", "jpt"]#, "nnb", "nnc"]
    languages = tessdataUsed
    custom_config = r'--oem 3 --psm 6'
    for i in typeImages:
        for l in languages:
            result = pytesseract.image_to_string(i, config=custom_config, lang=l) #jpt
            managePrints(result)
            printOnMap(result, path, l)
        printSeparatorOnMap(5)
    printSeparatorOnMap(11)

    

croppedLPimages = os.listdir(croppedLPdir)

for f in croppedLPimages:
    manageConversion(croppedLPdir + "/" + f)
