import cv2 
import pytesseract
import preprocessing
import os

def printme(aaa):
    print(aaa)
    f = open(dirlog + "/" + logfilename, 'a')
    f.write(aaa + "\n")
    f.close()
    

def modss(f):
    img = cv2.imread(ok)
    gray = preprocessing.get_grayscale(img)
    thresh = preprocessing.thresholding(gray)
    opening = preprocessing.opening(gray)
    canny = preprocessing.canny(gray)

    aaa = [img, gray, thresh, opening, canny]
    #aaa = [img]
    #lll = ["jjj", "lat", "com", "nda", "ndb"]
    lll = ["eng", "nna", "nnb", "nnc"]
    #lll = ["eng", "jpt"]#, "nnb", "nnc"]
    custom_config = r'--oem 3 --psm 6'

    for a in aaa:
        for l in lll:
            b = pytesseract.image_to_string(a, config=custom_config, lang=l) #jpt
            #printme(aaa)
            #print(l + ") " + f + " -> " + b + "\n")
            printme(l + ") " + f + " -> " + b)
        printme("####")#print("####")
    printme("############################")#print("############################")
        
        # c = pytesseract.image_to_string(a, config=custom_config, lang="lat") #jpt
        # print(f, " -> ", c)

        # d = pytesseract.image_to_string(a, config=custom_config, lang="com") #jpt
        # print(f, " -> ", d)

        # e = pytesseract.image_to_string(a, config=custom_config, lang="nda") #jpt
        # print(f, " -> ", e)
        
    
    # Adding custom options
    
    # a = 
    # print(f, " -> ", a)
    # a = pytesseract.image_to_string(gray, config=custom_config, lang="jjj")
    # print(f, " -> ", a)
    # a = pytesseract.image_to_string(thresh, config=custom_config, lang="jjj")
    # print(f, " -> ", a)
    # a = pytesseract.image_to_string(opening, config=custom_config, lang="jjj")
    # print(f, " -> ", a)
    # a = pytesseract.image_to_string(canny, config=custom_config, lang="jjj") #ocr_jpt_001+eng
    # print(f, " -> ", a)
    

dirname = "ttt2"
dirlog = "LOG"



ff = os.listdir(dirname)
amount = len(os.listdir(dirlog))
print(amount)
logfilename =  "log" + str(amount) + ".txt"
#print(ff)

for f in ff:
    ok = dirname + "/" + f
    modss(ok)

print(pytesseract.get_languages() )
print(pytesseract.get_tesseract_version())
print("log) " + logfilename)

#printme("ciao")
# img = cv2.imread('AA32LXS.png')

# # Adding custom options
# custom_config = r'--oem 3 --psm 6'
# a = pytesseract.image_to_string(img, config=custom_config)
# print(a)

