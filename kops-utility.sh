#!/bin/bash

export NAME=manzonikubecluster.k8s.local
export KOPS_STATE_STORE=s3://kops-manzoni-bucket

echo 'Kubernetes KOPS Utility Tool: '
options=(
    "Create kubernetes cluster" \
    "Edit kubenetes cluster" \
    "Validate the cluster" \
    "Delete the cluster" \
    "Quit" \
)
select opt in "${options[@]}"
do
    case $opt in
        "Create kubernetes cluster")
            aws-vault exec kops --no-session -- \
                kops create cluster \
                    --zones us-east-2a \
                    --node-size t2.small \
                    --master-size t2.small \
                    --node-count 2 \
                    --master-count 1 \
                    ${NAME}

            aws-vault exec kops --no-session -- \
                kops update cluster ${NAME} --yes
            ;;
        "Edit kubenetes cluster")
            aws-vault exec kops --no-session -- \
                kops edit cluster ${NAME}

            aws-vault exec kops --no-session -- \
                kops update cluster ${NAME} --yes

            aws-vault exec kops --no-session -- \
                kops rolling-update cluster ${NAME} --yes
            ;;
        "Validate the cluster")
            kubectl get nodes

            aws-vault exec kops --no-session -- \
                kops validate cluster

            kubectl -n kube-system get po
            ;;
        "Delete the cluster")
            aws-vault exec kops --no-session -- \
                kops delete cluster --name ${NAME} --yes
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done


