input_text_wo_space_uniq='data/HD_100/words_uniq'
output_char_seq='data/HD_100/characters'

with open(input_text_wo_space_uniq, 'r') as f:
    lines = f.readlines()

lexicon = []

for line in lines:
    line = line.replace('\n','')
    for idx, char in enumerate(line):
        if idx ==0:
            new_line = char
        else:
            new_line = new_line + ' ' + char
    new_line = new_line + '\n'
    lexicon.append(new_line)

with open(output_char_seq, 'w') as f:
    f.writelines(lexicon)