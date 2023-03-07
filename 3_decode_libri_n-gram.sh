#!/bin/bash
stage=-1
stop_stage=100

combined_data_dir=/home/Workspace/fairseq/data/combined_data
# subset=dev_clean
subsets="test_clean test_other dev_clean dev_other"
# dir_checkpoint=$combined_data_dir/checkpoint_best.pt
dir_checkpoint=$1 #/home/Workspace/fairseq/outputs/2023-01-09/05-00-26/checkpoints/checkpoint_best.pt
results_path=/home/Workspace/fairseq/decode_results_$subset
dir_lm_3gram=$2 #/home/Workspace/fairseq/libri_3gram.arpa
dir_lm_4gram=$3 #/home/Workspace/fairseq/libri_4gram.arpa
dir_lexicon=$4 #/home/Workspace/fairseq/libri_lexicon.txt
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

if [ ${stage} -le 2 ] && [ ${stop_stage} -ge 2 ]; then
    echo "stage 2: do decode (3gram)"
    for subset in $subsets; do
        python examples/speech_recognition/infer.py $combined_data_dir --task audio_finetuning \
        --nbest 1 --path $dir_checkpoint --gen-subset $subset --results-path /path/to/save/results/for/sclite --w2l-decoder kenlm \
        --lm-model $dir_lm_4gram --lexicon=$dir_lexicon --lm-weight 2 --word-score -1 --sil-weight 0 --criterion ctc --labels ltr --max-tokens 4000000 \
        --post-process letter
fi

if [ ${stage} -le 3 ] && [ ${stop_stage} -ge 3 ]; then
    echo "stage 3: do decode (4gram)"
    for subset in $subsets; do
        python examples/speech_recognition/infer.py $combined_data_dir --task audio_finetuning \
        --nbest 1 --path $dir_checkpoint --gen-subset $subset --results-path /path/to/save/results/for/sclite --w2l-decoder kenlm \
        --lm-model $dir_lm_3gram --lexicon=$dir_lexicon --lm-weight 2 --word-score -1 --sil-weight 0 --criterion ctc --labels ltr --max-tokens 4000000 \
        --post-process letter
fi