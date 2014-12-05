# cheat.el
Provide a handy emacs interface to cheat.

cheat allows you to create and view interactive cheatsheets on the
command-line. It was designed to help remind *nix system
administrators of options for commands that they use frequently,
but not frequently enough to remember.

See [cheat](https://github.com/chrisallenlane/cheat) for details on cheat itself.

## Installation
+ Install [cheat](https://github.com/chrisallenlane/cheat) first
```
sudo apt-get install python2.7 python2.7-dev python3.2 python3.2-dev
sudo apt-get install build-essential libssl-dev libevent-dev libjpeg-dev libxml2-dev libxslt-dev
sudo apt-get install python-pip
sudo pip install docopt pygments
cd ~
git clone https://github.com/chrisallenlane/cheat.git cheat
cd cheat
sudo python setup.py install
```

+ Install cheat.el
```
;; add cheat.el to your load path
(require 'cheat)
```

## Usage
`[M-x]`+`cheat`+`[Return]`+`tar`+`[Return]`
```
# To extract an uncompressed archive:
tar -xvf /path/to/foo.tar

# To create an uncompressed archive:
tar -cvf /path/to/foo.tar /path/to/foo/

# To extract a .gz archive:
tar -xzvf /path/to/foo.tgz

# To create a .gz archive:
tar -czvf /path/to/foo.tgz /path/to/foo/

# To list the content of an .gz archive:
tar -ztvf /path/to/foo.tgz

# To extract a .bz2 archive:
tar -xjvf /path/to/foo.tgz

# To create a .bz2 archive:
tar -cjvf /path/to/foo.tgz /path/to/foo/

# To list the content of an .bz2 archive:
tar -jtvf /path/to/foo.tgz

# To create a .gz archive and exclude all jpg,gif,... from the tgz
tar czvf /path/to/foo.tgz --exclude=\*.{jpg,gif,png,wmv,flv,tar.gz,zip} /path/to/foo/

```

## Functions
+ `cheat`                      show cheatsheet
+ `cheat-add-current-buffer`   Add current buffer to cheatsheets
+ `cheat-command`
+ `cheat-directories`          List directories on CHEATPATH
+ `cheat-edit`                 Edit cheatsheet
+ `cheat-list`                 List cheatsheets
+ `cheat-save-current-buffer`  Save current buffer to cheatsheets
+ `cheat-search`               Search cheatsheets for <keyword
+ `cheat-version`              Print the version number
