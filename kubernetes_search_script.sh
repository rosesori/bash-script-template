# #!/bin/bash

# This script will:
# * Search kubernetes resources based on script arguments
# ------------------------------------------------------------------------------------

# Take in script arguments
fruit="$1"
env="$2"

# Set fruit type
if [ "$fruit" = "help" ]; then
    printf "Usage:\n\t./bash_script_template [apple|banana|peach] [celery|broccoli|asparagus]"
    printf "\nExample usage:\n\t$./bash_script_template apple asparagus\n"
    exit 1
elif [ "$fruit" = "apple" ]; then
    FRUIT_COLOR="red"
elif [ "$fruit" = "banana" ]; then
    FRUIT_COLOR="yellow"
elif [ "$fruit" = "peach" ]; then
    FRUIT_COLOR="pink"
fi
echo "- Fruit color: $FRUIT_COLOR"

# Set Kube context and namespace based on env argument
if [ "$env" = "dev" ]; then
    KUBE_CONTEXT="dev"
    KUBE_NAMESPACE="default"
elif [ "$env" = "prod" ]; then
    KUBE_CONTEXT="prod"
    KUBE_NAMESPACE="default"
fi
echo "- Kubernetes context: $KUBE_CONTEXT"
echo "- Kubernetes namespace: $KUBE_NAMESPACE"

CURR_EPOCH_TIME="$(date +%s)"
OUTPUT_FILE_NAME="$env-$FRUIT_COLOR-$CURR_EPOCH_TIME.txt"
echo "- Output file name: $OUTPUT_FILE_NAME"

for pod in $(kubectl --context=$KUBE_CONTEXT --namespace=$KUBE_NAMESPACE get pods --no-headers | awk '{print $1}' | grep "$FRUIT_COLOR"); do uuid_str=$(kubectl --context=$KUBE_CONTEXT --namespace=$KUBE_NAMESPACE describe pod $pod | grep uuid); echo "${uuid_str:19}"; done > $OUTPUT_FILE_NAME
