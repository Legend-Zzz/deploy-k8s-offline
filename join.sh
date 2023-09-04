#!/bin/bash
work_dir=$(dirname $(readlink -f $0))

cat ${work_dir}/kubeadminit.txt | grep -A 4 "join.*control-plane" > ${work_dir}/master-join-token.sh 2>/dev/null

sed -i '1,2d' ${work_dir}master-join-token.sh 2>/dev/null


cat ${work_dir}/kubeadminit.txt | grep -A 4 "join.*worker" > ${work_dir}/node-join-token.sh 2>/dev/null

sed -i '1,2d' ${work_dir}/node-join-token.sh 2>/dev/null



