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

if [ ${stage} -le 2 ] && [ ${stop_stage} -ge 2 ]; then
    echo "stage 2: Prepare letter labels"
    output_wrd=`echo $input_wav_scp | sed s/'wav\.scp'/'labels\.wrd'/g`
    output_ltr=`echo $input_wav_scp | sed s/'wav\.scp'/'labels\.ltr'/g`
    cat $input_text_scp | sed s/'\t'/' '/g | cut -d ' ' -f 2- > $output_wrd
    python 31-2_from_wrd_to_ltr.py $output_wrd $output_ltr
fi