import sys
from scipy.io import wavfile
import hgtk

wrd_dir=sys.argv[1]
ltr_dir=sys.argv[2]

assert len(sys.argv) == 3

#cho-sung 19
l_f=['ㄱ','ㄲ','ㄴ','ㄷ','ㄸ','ㄹ','ㅁ','ㅂ','ㅃ','ㅅ','ㅆ','ㅇ','ㅈ','ㅉ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ']
#jung-sung 21
l_m=['ㅏ','ㅐ','ㅑ','ㅒ','ㅓ','ㅔ','ㅕ','ㅖ','ㅗ','ㅘ','ㅙ','ㅚ','ㅛ','ㅜ','ㅝ','ㅞ','ㅟ','ㅠ','ㅡ','ㅢ','ㅣ']
#jong-sung 27
l_e=['ㄱ','ㄲ','ㄳ','ㄴ','ㄵ','ㄶ','ㄷ','ㄹ','ㄺ','ㄻ','ㄼ','ㄽ','ㄾ','ㄿ','ㅀ','ㅁ','ㅂ','ㅄ','ㅅ','ㅆ','ㅇ','ㅈ','ㅊ','ㅋ','ㅌ','ㅍ','ㅎ']
#num
num=['1','2','3','4','5','6','7','8','9','0']

with open(wrd_dir, 'r') as f:
    lines = f.readlines()

ltr_to_write=[]

for line in lines:
    new_line = line[0:len(line)-1]

    ### decompose line with hgtk by cho-jung-jong sung
    ### e.g) 각 -> ㄱ ㅏ ㄱ
    decomped_line = hgtk.text.decompose(line)

    ### make phone sequence from decomposed line
    ### e.g) ㄱ ㅏ ㄱ -> f0 m0 e0
    ### e.g) ㄱ ㅏ ㄴ -> f0 m0 e3
    for i in range(0,len(decomped_line)-1):
        if decomped_line[i] in l_m:
            new_line = new_line + ' m' + str(l_m.index(decomped_line[i]))
        elif decomped_line[i+1] in l_m:
            new_line = new_line + ' f' + str(l_f.index(decomped_line[i]))
        elif decomped_line[i] in l_e:
            new_line = new_line + ' e' + str(l_e.index(decomped_line[i]))
        elif decomped_line[i] in num:
            new_line = new_line + ' n' + decomped_line[i]
        elif decomped_line[i] == 'ᴥ':
            new_line = new_line
        elif decomped_line[i] == ' ':
            new_line = new_line + ' |'
        else:
            new_line = new_line + ' ' + decomped_line[i]
    if decomped_line[-1] in l_m:
        new_line1 = new_line + ' m' + str(l_m.index(decomped_line[-1]))
    elif decomped_line[-1] in l_e:
        new_line1 = new_line + ' e' + str(l_e.index(decomped_line[-1]))
    else:
        new_line1 = new_line# + decomped_line[-1]
    ltr_to_write.append(new_line1[len(line):] + '\n')

with open(ltr_dir, 'w') as f:
    f.writelines(ltr_to_write)
