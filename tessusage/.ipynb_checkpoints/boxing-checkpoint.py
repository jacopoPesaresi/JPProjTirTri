import cv2
import pytesseract

f = 'AB02EGM.png'
p = "tmp/"
ok = p + f

img = cv2.imread(ok)
custom_config = r'--oem 3 --psm 6'

a = pytesseract.image_to_string(img, config=custom_config)
print(ok, " -> ", a)

h, w, c = img.shape
boxes = pytesseract.image_to_boxes(img) 
for b in boxes.splitlines():
    b = b.split(' ')
    img = cv2.rectangle(img, (int(b[1]), h - int(b[2])), (int(b[3]), h - int(b[4])), (0, 255, 0), 2)

# cv2.imshow('img', img)
# cv2.waitKey(0)

#img = cv2.imread(ok)
# Adding custom options
a = pytesseract.image_to_string(img, config=custom_config)
print(ok, " -> ", a)