#!/bin/bash
stage=7
stop_stage=100

combined_data_dir=/home/Workspace/fairseq_car/data/HD_100
# subset=dev_clean
subset=dev_other_3
# dir_checkpoint=$combined_data_dir/checkpoint_best.pt
dir_checkpoint=$1 #outputs/2022-12-26/06-05-42/checkpoints/checkpoint_best.pt
results_path=/home/Workspace/fairseq_car/decode_results_HD100_$subset

SHELL_PATH=`pwd -P`
echo $SHELL_PATH

if [ ${stage} -le 7 ] && [ ${stop_stage} -ge 7 ]; then
    echo "stage 7: do decode (kenlm)"
    $subset=dev_other
    python /home/Workspace/fairseq_car/examples/speech_recognition/infer.py $combined_data_dir --task audio_finetuning \
    --nbest 1 --path $dir_checkpoint --gen-subset $subset --results-path $results_path --w2l-decoder kenlm \
    --lm-model 4gram_HD100_wo_blank.bin --lexicon data/HD_100/lexicon_grapheme.txt --lm-weight 4 --word-score -0.0 --sil-weight 2 --criterion ctc --labels ltr --max-tokens 4000000 \
    --post-process grapheme_v3
fi
