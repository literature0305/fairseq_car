import sys
import hgtk

wrd_dir=sys.argv[1]
ltr_dir=sys.argv[2]

assert len(sys.argv) == 3

with open(wrd_dir, 'r') as f:
    lines = f.readlines()

ltr_to_write=[]

for line in lines:
    word = line.replace('\n','')
    if len(word) == 0:
        continue
    decomped_line = hgtk.text.decompose(word)
    decomped_line = ' '.join(decomped_line)
    ltr_to_write.append(word + '\t' + decomped_line + ' |' + '\n')

with open(ltr_dir, 'w') as f:
    f.writelines(ltr_to_write)