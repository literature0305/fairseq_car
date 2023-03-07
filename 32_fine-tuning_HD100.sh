#!/bin/bash
stage=5
stop_stage=100

dir_trainset=/home/Workspace/fairseq/data/HD_100
dir_pretrained=/home/Workspace/fairseq/pretrained_models # dir for pretrained models
# name_model=checkpoint_best_k-wav2vec.pt # name pretrained_model (wav2vec_small.pt, wav2vec_small_10m.pt ...)
name_model=wav2vec_small.pt

# divide 1/20
num_divide_valid=20

if [ ${stage} -le 5 ] && [ ${stop_stage} -ge 5 ]; then
    echo "stage 5: prepare finetuning (we do not shuffle the input data plz shuffle it first)"
    num_lines=`cat $dir_trainset/labels.ltr | wc -l`
    num_valid=$(($num_lines / $num_divide_valid))
    num_train=$(expr $num_lines - $num_valid)

    # prepare train set
    cat $dir_trainset/labels.ltr | head -$num_train > $dir_trainset/train.ltr
    cat $dir_trainset/labels.wrd | head -$num_train > $dir_trainset/train.wrd
    cat $dir_trainset/wav_dir.tsv | head -$num_train | cut -d '/' -f -2 | head -1 > $dir_trainset/train.tsv
    cat $dir_trainset/wav_dir.tsv | head -$num_train | cut -d '/' -f 3- >> $dir_trainset/train.tsv

    # prepare dev set
    cat $dir_trainset/labels.ltr | tail -$num_valid > $dir_trainset/dev_other.ltr
    cat $dir_trainset/labels.wrd | tail -$num_valid > $dir_trainset/dev_other.wrd
    cat $dir_trainset/wav_dir.tsv | tail -$num_valid | cut -d '/' -f -2 | head -1 > $dir_trainset/dev_other.tsv
    cat $dir_trainset/wav_dir.tsv | tail -$num_valid | cut -d '/' -f 3- >> $dir_trainset/dev_other.tsv

    # make dictionary
    cat $dir_trainset/labels.ltr | sed s/' '/'\n'/g | LC_COLLATE='utf-8' sort -u | grep -v '^$' | sed s/'$'/' 1'/g > $dir_trainset/dict.ltr.txt
fi

# this script is for 4 GPU training
# for 1 GPU training 
# 1.0 edit examples/wav2vec/config/finetuning/base_100h.yaml file (distributed_world_size: 4 -> 1)
# 2.0 CUDA_VISIBLE_DEVICES=0,1,2,3 -> CUDA_VISIBLE_DEVICES=0
if [ ${stage} -le 6 ] && [ ${stop_stage} -ge 6 ]; then
    echo "stage 6: do finetuning (vanilla)"
    CUDA_VISIBLE_DEVICES=0,1,2,3 fairseq-hydra-train \
        task.data=$dir_trainset \
        model.w2v_path=$dir_pretrained/$name_model \
        --config-dir examples/wav2vec/config/finetuning \
        --config-name base_100h
fi


