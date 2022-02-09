#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
Help(){
        printf "\nPlease indicate the gitlab version to update \n \nSyntax: update_gitlab.sh --toVersion XX.XX.XX \n\n" 
}

while [[ "$#" -gt 0 ]]; do
    case $1 in
        -t|--toVersion) toVersion="$2"; shift ;;
    esac
    shift
done

if [ -z $toVersion ]
        then Help; exit
fi

ee=$(grep "gitlab-ee" /opt/gitlab/version-manifest.txt | awk '{print $2}')
ce=$(grep "gitlab-ce" /opt/gitlab/version-manifest.txt | awk '{print $2}')
type=""
currentVersion=""
if [ ${#ee} -ge 2 ]
        then type="ee"; currentVersion=$ee
fi

if [ ${#ce} -ge 2 ]
        then type="ce"; currentVersion=$ce
fi

if [ -z $type ]
        then echo "The type of installation could not be obtained (CE/EE)"; exit
fi

if [ ${#currentVersion} -ge 2 ]
        then
        currentMayorVersion=$(echo "$currentVersion" | awk -F\. '{print $1}'); toMayorVersion=$(echo "$toVersion" | awk -F\. '{print $1}')
        if [[ $currentMayorVersion == $toMayorVersion ]]
                then
                apt update
                apt install -y gitlab-$type=$toVersion-$type.0
        else
                echo "Only can update minor versions of $currentMayorVersion"
        fi
fi
