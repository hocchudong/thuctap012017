#!/bin/bash

#Author Son Do Xuan


# Ham dinh nghia mau cho cac thong bao in ra man hinh
function echocolor {
    echo "$(tput setaf 2)##### $1 #####$(tput sgr0)"
}


# Ham sua file config cua OpenStack
## Ham add 
function ops_add {
	crudini --set $1 $2 $3 $4
}
### Cach dung
### Cu phap
### ops_add PATH_FILE SECTION PARAMETER VAULE

## Ham del
function ops_del {
	crudini --del $1 $2 $3
}