#!/bin/bash
stage=-1
stop_stage=1000

data_dir=/DB/HD_100
prepaired_data_dir=data/HD_100
input_wav_scp=${prepaired_data_dir}/wav.scp
input_text_scp=${prepaired_data_dir}/text

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    # echo "stage 1: Prepare tsv option 1 find in $data_dir (not used)"
    # python examples/wav2vec/wav2vec_manifest.py $datadir --dest $prepaired_data_dir --ext wav --valid-percent 0
    # mv $prepaired_data_dir/train.tsv $prepaired_data_dir/wav_dir.tsv

    echo "stage 1: Prepare tsv option 2 using $input_wav_scp"
    output_tsv=`echo $input_wav_scp | sed s/'wav\.scp'/'wav_dir\.tsv'/g`
    python 31-1_from_scp_to_tsv.py $input_wav_scp $output_tsv
fi

if [ ${stage} -le 4 ] && [ ${stop_stage} -ge 4 ]; then
    echo "stage 4: Prepare grapheme labels"
    input_wrd=`echo $input_wav_scp | sed s/'wav\.scp'/'labels\.wrd'/g`
    output_ltr=`echo $input_wav_scp | sed s/'wav\.scp'/'labels\.ltr'/g`
    cat $input_text_scp | sed s/'\t'/' '/g | cut -d ' ' -f 2- > $input_wrd
    # python 31-2_from_wrd_to_ltr.py $input_wrd $output_ltr
    python 31-2_from_wrd_to_ltr_grapheme.py $input_wrd $output_ltr
fi

if [ ${stage} -le 5 ] && [ ${stop_stage} -ge 5 ]; then
    echo "stage 4: Prepare grapheme lexicon"
    input_wrd=`echo $input_wav_scp | sed s/'wav\.scp'/'labels\.wrd'/g`
    input_wrd2=`echo $input_wav_scp | sed s/'wav\.scp'/'word'/g`
    output_lexicon=`echo $input_wav_scp | sed s/'wav\.scp'/'lexicon_grapheme\.txt'/g`
    cat $input_wrd | sed s/' '/'\n'/g | LC_COLLATE='utf-8' sort -u > $input_wrd2
    python 31-3_from_wrd_to_lexicon_grapheme.py $input_wrd2 $output_lexicon
fi
