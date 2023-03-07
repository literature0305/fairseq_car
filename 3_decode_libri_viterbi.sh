#!/bin/bash
stage=-1
stop_stage=100

combined_data_dir=/home/Workspace/fairseq/data/combined_data
# subset=dev_clean
subsets="test_clean test_other dev_clean dev_other"
dir_checkpoint=$1 #/home/Workspace/fairseq/outputs/2023-01-30/03-56-36/errlog033_w2v_libri100_0.1kd-minimal-detach_emb-0_residual/checkpoint_best.pt
results_path=/home/Workspace/fairseq/decode_results_$subset
SHELL_PATH=`pwd -P`
echo $SHELL_PATH

if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
    echo "stage 1: do decode (viterbi)"
    for subset in $subsets; do
        echo "Start decode $subset"
        python /home/Workspace/fairseq/examples/speech_recognition/infer.py $combined_data_dir --task audio_finetuning \
        --nbest 1 --path $dir_checkpoint --gen-subset $subset --results-path $results_path --w2l-decoder viterbi \
        --lm-weight 2 --word-score -1 --sil-weight 0 --criterion ctc --labels ltr --max-tokens 4000000 \
        --post-process letter
    done
fi
