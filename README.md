# tf-with-gcp-statefile
Basic TF project with state file located on GCP bucket

Both - local (KIND) and remote (GCP-GKE) deployment are available here


***Create manifest for a git source for FluxCD:***


flux create source git kbot \                                                                                                                            
> --url=https://github.com/silhouetteUA/kbot \
> --branch=main \
> --namespace=demo \
> --export
---
apiVersion: source.toolkit.fluxcd.io/v1
kind: GitRepository
metadata:
  name: kbot
  namespace: demo
spec:
  interval: 1m0s
  ref:
    branch: main
  url: https://github.com/silhouetteUA/kbot



  ***Create manifest for helmrelease using object created above:***


flux create helmrelease kbot \                                                                                                                                
> --namespace=demo \
> --source=GitRepository/kbot \
> --chart="./helm" \
> --interval=1m \
> --export
---
apiVersion: helm.toolkit.fluxcd.io/v2beta2
kind: HelmRelease
metadata:
  name: kbot
  namespace: demo
spec:
  chart:
    spec:
      chart: ./helm
      reconcileStrategy: ChartVersion
      sourceRef:
        kind: GitRepository
        name: kbot
  interval: 1m0s




  
