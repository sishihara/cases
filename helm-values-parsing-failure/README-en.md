# helm-values-parsing-failure

## Issue description

I have a Helm chart that has attributes defined as a list of maps in values.yml like:

```
list_of_map:
  - foo: one
    bar: two
  - foo: three
    bar: four
  # and so on...
```

**When deploying this chart as Rancher catalog app, too many errors occurred in rancher server and it cannot complete deploying. How to avoid this error and successfully deploy this chart?**

Here is an example of error log printed by rancher server (also you can look it as error message on rancher web ui). This log is repeated almost infinitely.

```
rancher-547d9f8c57-5z4wd rancher 2019/05/09 05:30:51 [ERROR] AppController p-lxjk9/<**masked**> [helm-controller] failed with : helm template failed. panic: interface conversion: interface {} is nil, not map[string]interface {}        
rancher-547d9f8c57-5z4wd rancher
rancher-547d9f8c57-5z4wd rancher goroutine 1 [running]:
rancher-547d9f8c57-5z4wd rancher k8s.io/helm/pkg/strvals.(*parser).listItem(0xc42077ae20, 0xc42077afc0, 0x2, 0x2, 0x0, 0x1, 0x5b, 0x0, 0x0, 0x412627)                                                                                        
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/pkg/strvals/parser.go:291 +0x1078
rancher-547d9f8c57-5z4wd rancher k8s.io/helm/pkg/strvals.(*parser).key(0xc42077ae20, 0xc420716300, 0xc4209773b0, 0xb)
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/pkg/strvals/parser.go:177 +0xcaa
rancher-547d9f8c57-5z4wd rancher k8s.io/helm/pkg/strvals.(*parser).key(0xc42077ae20, 0xc42076dad0, 0x0, 0x0)
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/pkg/strvals/parser.go:215 +0x1ca
rancher-547d9f8c57-5z4wd rancher k8s.io/helm/pkg/strvals.(*parser).parse(0xc42077ae20, 0xc42076dad0, 0x2300)
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/pkg/strvals/parser.go:133 +0x38
rancher-547d9f8c57-5z4wd rancher k8s.io/helm/pkg/strvals.ParseInto(0x7ffc661e23d8, 0x23a5, 0xc42076dad0, 0x0, 0xc42076dad0)                                                                                                                  
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/pkg/strvals/parser.go:85 +0xbf
rancher-547d9f8c57-5z4wd rancher main.vals(0x0, 0x0, 0x0, 0xc420346d90, 0x1, 0x1, 0x22b9790, 0x0, 0x0, 0x22b9790, ...)
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/cmd/helm/install.go:382 +0x4e5
rancher-547d9f8c57-5z4wd rancher main.(*templateCmd).run(0xc4200d0600, 0xc420738000, 0xc4201928c0, 0x1, 0x7, 0x0, 0x0)
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/cmd/helm/template.go:137 +0x24b
rancher-547d9f8c57-5z4wd rancher main.(*templateCmd).(main.run)-fm(0xc420738000, 0xc4201928c0, 0x1, 0x7, 0x0, 0x0)
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/cmd/helm/template.go:92 +0x52
rancher-547d9f8c57-5z4wd rancher k8s.io/helm/vendor/github.com/spf13/cobra.(*Command).execute(0xc420738000, 0xc420192690, 0x7, 0x7, 0xc420738000, 0xc420192690)                                                                              
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/vendor/github.com/spf13/cobra/command.go:599 +0x3e8                                                                                                    
rancher-547d9f8c57-5z4wd rancher k8s.io/helm/vendor/github.com/spf13/cobra.(*Command).ExecuteC(0xc4207b6000, 0xc420738000, 0xc420738900, 0xc420738d80)                                                                                       
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/vendor/github.com/spf13/cobra/command.go:689 +0x2fe                                                                                                    
rancher-547d9f8c57-5z4wd rancher k8s.io/helm/vendor/github.com/spf13/cobra.(*Command).Execute(0xc4207b6000, 0x8, 0x8)
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/vendor/github.com/spf13/cobra/command.go:648 +0x2b                                                                                                     
rancher-547d9f8c57-5z4wd rancher main.main()
rancher-547d9f8c57-5z4wd rancher        /home/cjellick/gprojects/helm/src/k8s.io/helm/cmd/helm/helm.go:161 +0x79
rancher-547d9f8c57-5z4wd rancher : exit status 2
```

Additionaly, I want the solution satisfies requirements describe below. It comes from our environment.

- No need (acceptable if it's little) to customize the chart for Rancher catalog (writing many in questions/answer.yml). The chart is already completed as a Helm chart so creating them causes duplicated managing of chart attributes

## Environment

* Rancher v2.1.8
* Rancher CLI v2.2.0

## Step to reproduce

**fail with Rancher**

1. Add this repository as a Custom Catalog
   - Name: rancher-support
   - Catalog URL: https://github.com/sishihara/cases.git
   - Branch: master
   - Kind: Helm
2. Deploy this sample with Helm values (override-values.yml)
   - In case of using rancher-cli
     ```
     $ curl -LO https://raw.githubusercontent.com/sishihara/cases/master/helm-values-parsing-failure/override-values.yml
     $ rancher apps install --values override-values.yml rancher-support-sample sample
     ```
3. Confirm to fail deploying
   - Check rancher-server logs and confirm that Helm's errors are printed (especially the stacktrace noted above)
   - Confirm the command ```rancher apps install ...``` cannot be completed, or it takes too long time to complete.
     - It seems to depend on size of attributes list. More attributes cause more errors and finally it cannot complete
       - related issue: https://forums.rancher.com/t/problem-deploying-helm-chart-with-array-of-hash-for-values/13459

**success with Helm**

1. Add this repository as a Helm repository
   - ```helm repo add rancher-support https://raw.githubusercontent.com/sishihara/cases/master/helm-values-parsing-failure/build/charts```
2. Deploy this sample with override-values.yml
   - ```$ helm install -n sample rancher-support/sample -f override-values.yml```
3. Confirm to suceed deploying
   
