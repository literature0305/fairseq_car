#!/bin/bash
stage=7
stop_stage=100

combined_data_dir=/home/Workspace/fairseq/data/HD_100
# subset=dev_clean
subset=dev_other
# dir_checkpoint=$combined_data_dir/checkpoint_best.pt
dir_checkpoint=outputs/2022-10-21/15-16-30/checkpoints/checkpoint_best.pt # check point for baseline
results_path=/home/Workspace/fairseq/decode_results_HD100_$subset

SHELL_PATH=`pwd -P`
echo $SHELL_PATH

if [ ${stage} -le 7 ] && [ ${stop_stage} -ge 7 ]; then
    echo "stage 7: do decode (kenlm)"
    $subset=dev_other
    python /home/Workspace/fairseq/examples/speech_recognition/infer.py $combined_data_dir --task audio_finetuning \
    --nbest 1 --path $dir_checkpoint --gen-subset $subset --results-path $results_path --w2l-decoder kenlm \
    --lm-model 4gram_HD100_wo_blank.bin --lexicon data/HD_100/lexicon.txt --lm-weight 2 --word-score -1 --sil-weight 0 --criterion ctc --labels ltr --max-tokens 4000000 \
    --post-process letter
fi

# if [ ${stage} -le 7 ] && [ ${stop_stage} -ge 7 ]; then
#     echo "stage 7: do decode (viterbi)"
#     python /home/Workspace/fairseq/examples/speech_recognition/infer.py $combined_data_dir --task audio_finetuning \
#     --nbest 1 --path $dir_checkpoint --gen-subset $subset --results-path $results_path --w2l-decoder viterbi \
#     --lm-weight 2 --word-score -1 --sil-weight 0 --criterion ctc --labels ltr --max-tokens 4000000 \
#     --post-process letter
# fi