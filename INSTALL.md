## Installation

How to install Pxy on local machine:

1) Remember to deploy "proxycheck.php" to you favourite public server (http + https)

2) clone pxy repository and then edit configuration file

```bash
# clone repository
git clone https://github.com/bunk3r/pxy

# copy pxyconfig.dist into pxyconfig
cp pxyconfig.dist pxyconfig

# edit config
vi pxyconfig

# run
./pxy.sh -h
```
3) first time remeber to configure you shodan API key with

```bash
shodan init 'YOUKEY'
```

## License

PXY is licensed under the MIT License. See [LICENSE](LICENSE) for the full license text.
