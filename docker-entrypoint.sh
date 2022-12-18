#!/bin/bash

# Si el directorio /StoreAPI existe
if [ -d "/StoreAPI" ]; then
    # Si el directorio /StoreAPI est
    if [ -z "$(ls -A /StoreAPI)" ]; then
        cp -r /StoreAPI-bkp/. /StoreAPI;
    fi

    php artisan serve;
fi
