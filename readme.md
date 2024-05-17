## Rootless clearml-agent container

An attempt to build a rootless clearml-agent container for use on openshift. 

Currently it needs integration of nvidia cuda drivers, or possibly stfc systems are fubar.

```
docker build . -t scheckley/clearml-agent:latest
```


```
docker push scheckley/clearml-agent:latest
```
