# tf-with-gcp-statefile

TF project: week7, practice3
Both - local (KIND) and remote (GCP-GKE) deployment are available here

This TF workflow creates:

- K8S cluster: local via KIND *OR* GCP-GKE
- Deploys FluxCD on K8S
- FluxCD start reconciliation with remote gut hub repo: kbot
- Both localhost KIND and GKE clusters maintain tfstate in remote GCP bucket

**Create manifest for a git source for FluxCD:**

````
flux create source git kbot \                                                                                                                            
> --url=https://github.com/silhouetteUA/kbot \
> --branch=main \
> --namespace=course \
> --export
---
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: kbot
  namespace: course
spec:
  interval: 1m0s
  ref:
    branch: main
  url: https://github.com/silhouetteUA/kbot

````


  **Create manifest for helmrelease using object created above:**

````
flux create helmrelease kbot \                                                                                                                                
> --namespace=course \
> --source=GitRepository/kbot \
> --chart="./helm" \
> --interval=1m \
> --export
---
apiVersion: helm.toolkit.fluxcd.io/v2beta2
kind: HelmRelease
metadata:
  name: kbot
  namespace: course
spec:
  chart:
    spec:
      chart: ./helm
      reconcileStrategy: ChartVersion
      sourceRef:
        kind: GitRepository
        name: kbot
  interval: 1m0s
````



Add these two YAML files to and commit the changes in order to start Flux to reconcile the state (it will create kbot app from Helm charts):
**https://github.com/silhouetteUA/kbot/tree/main/cluster/fluxcd-test/demo-namespace**
