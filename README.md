# MtProxy + BBR + SSR

This makefile only support ubuntu/debian

## Build before
```bash
$ make dep
$ make bbr-test
```
If tcp_bbr no support

```bash
$ make bbr-init
```

## Build
```bash
$ make init
$ make ssr-init
```
## MtProxy Open
```bash
$ make mt-open
```
## SSR Open
```bash
$ make bbr-open
```