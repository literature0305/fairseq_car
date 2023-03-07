import sys
from scipy.io import wavfile

wav_scp_dir=sys.argv[1]
tsv_dir=sys.argv[2]

assert len(sys.argv) == 3

with open(wav_scp_dir, 'r') as f:
    wav_scp = f.readlines()

tsv_to_write=[]
for line in wav_scp:
    line = line.replace('\n','').replace('\t',' ')
    line = line.split(' ')
    wav_dir = line[1]
    fs, data = wavfile.read(wav_dir)
    new_line = wav_dir + '\t' +  str(len(data)) + '\n'
    tsv_to_write.append(new_line)

with open(tsv_dir, 'w') as f:
    f.writelines(tsv_to_write)