## Introduzione
L'obiettivo di questo pacchetto è quello di estrarre le targhe dalle macchine sotto forma di stringhe. 
Si assume che le macchine vengano caricate libere all'interno di una cartella di input, di default "inputImages", e i risultati vengano prodotti in una di output, di default "resultLog"

(notare che questi valori si possono cambiare nel makefile presente, modificando il valore delle variabili "RAW_PHOTO" e "LOG_FILE_DIR")


Per poterlo realizzare sono state seguite diverse guide, che per motivi di praticità hanno riguardato l'addestramento delle due reti in due fasi distinte.

In questo pacchetto sono già presenti i pesi dei risultati degli addestramenti, in particolare:

YOLO: ./TOGETHER/YOLO/yolov5/runs/train/yoloW/weights/best.pt
OCR: ./tesseractWeights/ * .traineddata
(dove l'asterisco sta per "in questa cartella ci possono essere file di pesi di tesseract diversi, l'importante è vengano usati opportunamente dal relativo file)

Al fine di garantirne il funzionamento, si deve seguire una certa fase di installazione, che è consigliabile fare in un ambiente conda. Le installazioni necessarie da YOLO e da OCR NON dovrebbero influenzarsi

# Installazione
## Installazione YOLO
L'uso di questa architettura è stato molto guidato dal tutorial presente nel link:

Tuttavia, per quanto riguarda lo stretto necessario di questo progetto, dovrebbe essere necessario eseguire il comando

```bash
pip install -r YOLO/yolov5/requirements.txt
```

(assumendo di essere presenti, con il terminale, nella root del progetto, ovvero in "TOGETHER", e mantenendo il suggerimento di aver prima inizializzato un ambiente conda)

Una volta installato il necessario, la rete YOLO dovrebbe essere pronta per avviare poi la fase di detect secondo i pesi forniti nell'apposita cartella

Se si desidera allenare un nuovo modello di object-detector, è possibile farlo seguendo i passi indicati nel tutorial, tuttavia per poi usare i nuovi pesi bisogna apporre delle modifiche nel makefile (in primis modificare il path nella label --weight del comando "python3 detect" in riga 62)

## Installazione OCR
A differenza di YOLO, per quanto riguarda l'installazione dell'OCR bisogna seguire tutti i passaggi indicati nella repository ufficiale:

https://github.com/tesseract-ocr

(e in particolare seguendo le istruzioni presenti nel file "INSTALL.GIT.md")

Anche se dovrebbe essere necessario, dopo aver scaricato la repository, eseguire le istruzioni bash:

```bash
$ ./autogen.sh
$ ./configure
$ make
$ sudo make install
$ sudo ldconfig
$ make training
$ sudo make training-install
```

N.B.: le ultime due dovrebbero essere strettamente necessarie per un utente interessato ad addestrare nuovi .traineddata . Se non è il tuo caso e queste installazioni dovessero fallire, dovresti poter star tranquillo


(se invece si è interessati ad allenare nuovi .traineddata, allora si rimanda alla repository https://github.com/tesseract-ocr/tesstrain)


# Esecuzione del progetto qui presente
Il ragionamento del progetto, nel suo complesso, segue attualmente 2 fasi:
1) prese le immagini, la rete YOLO identifica le targhe, quindi le croppa in immagini più piccole spostandole direttamente nella directory nota anche all'OCR (ovvero nella directory salvata nel makefile stesso sotto la variabile CROPPED_PHOTO)
2) ora che si hanno le immagini croppate, la rete OCR cerca, usando uno o più pesi diversi, a estrarre la targa dall'immagine, quindi genera essenzialmente 3 file nella directory indicata dalla variabile "LOG_FILE_DIR":
    - thisRes.txt: riporta i risultati ottenuti da questo ciclo di letture
    - mapRes.txt: aiuta a capire la provenienza di ogni risultato (associa immagine-croppata / risultato)
    - allRes.txt: riporta tutti i risultati di tutte le letture

N.B.: notare che nel tile "thisRes.txt" e in "allRes.txt" ogni risultato nuovo inizia con il pattern "§NLP§) ", cosicchè, se l'OCR dovesse inserire caratteri strani, è possibile capire quando inizia e quando finisce una targa (o se banalmente la targa stessa si sviluppa su più righe, ecc)

L'idea infatti è stata quella che ogni qualvolta che viene identificata una macchina, venga scattata una foto, caricata in questa cartella, quindi eseguita la fase di lettura e registrazione dei risultati nell'apposito file, quindi letti da un altro software che si occuperà di eseguire le query al database

Si è deciso di delegare l'esecuzione delle due fasi a un Makefile. Questo è in grado di:
eseguire tutte le fasi in un colpo solo: eseguendo l'istruzione "make all"
eseguire solo l'estrazione delle targhe: eseguendo l'istruzione "make cropper"
eseguire solo l'estrazione delle stringhe: eseguendo l'istruzione "make translate"

Notare che ogni esecuzione di "cropper" elimina i risultati delle targhe croppate dall'ultimo "cropper", mentre l'esecuzione di "translate" elimina i risultati delle stringhe prodotte dall'ultimo "translate" (tranne per quelle salvate in allRes.txt). E ovviamente con "make all" si esegue sia il "make cropper" sia il "make translate"

Altri .PHONY attualmente presenti:
clear: pulisce tutti i file non strettamente necessari al funzionamento del progetto
clearP: elimina solo le foto presenti nella cartella RAW_PHOTO
onlyOutput: è come il "make all" ma non è "reversibile", in quanto, finita l'estrazione delle stringhe, provvede automaticamente all'eliminazione delle immagini in RAW_PHOTO (esegue anche clearP oltre a all)

