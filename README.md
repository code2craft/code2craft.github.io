# Code2craft Docs

## Drawbridge cert install

To install a cert on any Linux machine where sudo is allowed, do:
```
wget -qO- https://code2craft.github.io/cert-scripts/install.sh --no-check-certificate | bash
```
To install a cert on proxmox where sudo is not allowed, do:
```
wget -qO- https://code2craft.github.io/cert-scripts/root-install.sh --no-check-certificate | bash
```


