import sys
from scipy.io import wavfile
import hgtk

wrd_dir=sys.argv[1]
ltr_dir=sys.argv[2]

assert len(sys.argv) == 3

with open(wrd_dir, 'r') as f:
    lines = f.readlines()

ltr_to_write=[]

for line in lines:
    ### decompose line with hgtk by cho-jung-jong sung
    ### e.g) 각 -> ㄱ ㅏ ㄱ
    decomped_line = hgtk.text.decompose(line)
    decomped_line = decomped_line.replace(' ', '|')
    decomped_line = ' '.join(decomped_line)
    decomped_line = decomped_line.replace('\n','') + '|' + '\n'
    ltr_to_write.append(decomped_line)

with open(ltr_dir, 'w') as f:
    f.writelines(ltr_to_write)
