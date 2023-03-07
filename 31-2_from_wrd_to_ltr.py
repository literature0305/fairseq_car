import sys
from scipy.io import wavfile

wrd_dir=sys.argv[1]
ltr_dir=sys.argv[2]

assert len(sys.argv) == 3

with open(wrd_dir, 'r') as f:
    wrd = f.readlines()

ltr_to_write=[]
for line in wrd:
    line = line.replace('\n','')
    new_line=''
    for char in line:
        if char == ' ':
            new_line = new_line + ' ' + '|'
        else:
            new_line = new_line + ' ' + char
    new_line = new_line.strip()
    ltr_to_write.append(new_line + '\n')

with open(ltr_dir, 'w') as f:
    f.writelines(ltr_to_write)