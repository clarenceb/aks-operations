#!/bin/bash

kubectl apply -f gremlins/gremlin-1.yaml

# Issue: invalid container image repo/name:tag
# Symptom: This will cause an ImagePullBackOff for the front end pod
# Effect: Service Unavailable, cannot use the front end
# Detection:
# - kubectl get pods
# - kubectl get deploy -o wide
# - kubectl describe pod/azure-vote-front-XXXXXXXXXX
# - kubectl logs pod/azure-vote-front-XXXXXXXXXX
# - kubectl diff -f apps/azure-vote/
# - Check container in Azure Portal Container Insights (live data, status, etc.)
# - Log Analytics:
# KubeEvents
# | where TimeGenerated > ago(24h)
# | where Reason in ("Failed")
# | summarize count() by Reason, bin(TimeGenerated, 5m)
# | render areachart
# Fix:
# - Change image to a valid one: kubectl apply -f apps/azure-vote/azure-vote-front.deploy.yaml
# Improvements:
# - gremlin-1b.yaml: Add readiness and liveness probes, see: https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/