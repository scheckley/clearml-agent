## Rootless clearml-agent container

An attempt to build a rootless clearml-agent container for use on openshift. Doesn't currently deploy from oc or kubectl because of course it doesn't.


```
docker build . -t scheckley/clearml-agent:latest
```


```
docker push scheckley/clearml-agent:latest
```
