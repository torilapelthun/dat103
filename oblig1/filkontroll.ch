#! /bin/bash
filename=$1
interval=$2

echo Starter monitorering av filen $filename

waitForFileToExist() {
    while ! stat $filename 2>1 > /dev/null
    do
        sleep $interval
    done
    echo Filen $filename ble opprettet
}

waitForFileToChange() {
    changed=false;
    deleted=false;
    modified=`stat -c %Y $filename`
        while ! $changed && ! $deleted
        do
            if ! stat $filename 2>1 > /dev/null
            then
                deleted=true
                echo Filen $filename er slettet
            elif ((modified!=`stat -c %Y $filename`))
            then
                changed=true
                echo Filen $filename er endret
            else
                sleep $interval
            fi
        done
}

if stat $filename 2>1 > /dev/null
then
    waitForFileToChange
else
    waitForFileToExist
fi
