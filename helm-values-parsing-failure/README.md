# helm-values-parsing-failure

## 目的

既存の Helm Chart を Rancher 向けのカスタマイズ (questions.yml 等の作成) をせずに Catalog App としてデプロイしたい

- Chart に与えるパラメータは Helm の values.yml として管理し、Rancher でデプロイする場合もこれをそのまま渡したい
- Chart を置くリポジトリの構造は Helm でもそのまま使用できる形を維持したい

## 問題

values.yml に ```[]map[string]interface {}``` な値が含まれていると、Rancher server 側で以下のようなエラーを起こしてデプロイに失敗する

例:
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

## 環境

* Rancher v2.1.8
* Rancher CLI v2.2.0

## 再現手順

**Rancher で失敗する**

1. Rancher でこのリポジトリを Custom Catalog として追加する
   - Name: rancher-support
   - Catalog URL: https://github.com/sishihara/cases.git
   - Branch: master
   - Kind: Helm
2. override-values.yml を与えてデプロイする
   - CLI の場合
     ```
     $ curl -LO https://raw.githubusercontent.com/sishihara/cases/master/helm-values-parsing-failure/override-values.yml
     $ rancher apps install --values override-values.yml rancher-support-sample sample
     ```
3. デプロイに失敗することを確認する
   - Rancher server のログに上述のスタックトレースが出力されていること
   - ```rancher apps install``` が完了しない、あるいは完了するまでに長い時間がかかること
     - エラーの件数は少なくともリストの項目数に依存している模様。forum の問題と同じ？ https://forums.rancher.com/t/problem-deploying-helm-chart-with-array-of-hash-for-values/13459

**Helm で成功する**

1. helm repo add でこのリポジトリを追加する
   - ```helm repo add rancher-support https://raw.githubusercontent.com/sishihara/cases/master/helm-values-parsing-failure/build/charts```
2. override-values.yml を与えてデプロイする
   - ```$ helm install -n sample rancher-support/sample -f override-values.yml```
3. デプロイが成功することを確認する
   - ```helm install``` がすぐに完了すること
   
