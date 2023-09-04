import os

langs = os.listdir(os.environ["LANG_STORED"])

print(langs)

sss = os.environ["LANGUAGES"]
ss = list(sss.split())
print("Nel makefile è presente: ", ss)
for s in ss:
    print("Cerco", s, ":")
    ext = ".traineddata"
    s = s + ext
    try:
        langs.index(s)
        print("Linguaggio", s, "trovato; \n")
    except:
        print("Linguaggio", s, "NON trovato; \n")
    
    
    #print("Founded tesseract weights: ", s)