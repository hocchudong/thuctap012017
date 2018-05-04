#! /bin/bash

# In ra man hinh cac thong bao

echocolor(){
	printf "\n \n"
	echo -e "\e[1;31m =>  $1 \e[0m"
}

echocolorbg(){
	printf "\n \n"
	echo -e "\e[1;47m\e[1;31m ##### $1 ##### \e[0m"
}

# Ham chinh sua cac file cau hinh
## Ham add de them cac thong so trong cac section cua file cau hinh

function ops_add {
	crudini --set $1 $2 $3 $4
}

### Cach dung
### Cu phap
### ops_add FILE_NAME SECTION PARAMETER VAULE

## Ham del de xoa mot gia tri thong so trong section

function ops_del {
	crudini --del $1 $2 $3
}

### Cu phap
### ops_del FILE_NAME SECTION PARAMETER
