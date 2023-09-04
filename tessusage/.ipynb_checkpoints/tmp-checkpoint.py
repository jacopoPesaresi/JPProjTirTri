import os

sss = os.environ["LANGUAGES"]
ss = sss.split()
print("Nel makefile è presente: ", sss)
for s in ss:
    print("Cerco", s, ":")
    #print("Founded tesseract weights: ", s)