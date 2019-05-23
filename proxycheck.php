<?php

if(     $_SERVER['HTTP_X_FORWARDED_FOR']||
        $_SERVER['HTTP_VIA']||
        $_SERVER['HTTP_CLIENT_IP']||
        $_SERVER['HTTP_PROXY_CONNECTION']||
        $_SERVER['FORWARDED_FOR']||
        $_SERVER['X_FORWARDED_FOR']||
        $_SERVER['X_HTTP_FORWARDED_FOR']||
        $_SERVER['HTTP_FORWARDED']||
        $_SERVER['ACCPROXYWS']||
        $_SERVER['CDN-SRC-IP']||
        $_SERVER['CLIENT-IP']||
        $_SERVER['CLIENT_IP']||
        $_SERVER['CUDA_CLIIP']||
        $_SERVER['FORWARDED']||
        $_SERVER['FORWARDED-FOR']||
        $_SERVER['REMOTE-HOST']||
        $_SERVER['X-CLIENT-IP']||
        $_SERVER['X-COMING-FROM']||
        $_SERVER['X-FORWARDED']||
        $_SERVER['X-FORWARDED-FOR']||
        $_SERVER['X-FORWARDED-FOR-IP']||
        $_SERVER['X-FORWARDED-HOST']||
        $_SERVER['X-FORWARDED-SERVER']||
        $_SERVER['X-HOST']||
        $_SERVER['X-NETWORK-INFO']||
        $_SERVER['X-NOKIA-REMOTESOCKET']||
        $_SERVER['X-PROXYUSER-IP']||
        $_SERVER['X-QIHOO-IP']||
        $_SERVER['X-REAL-IP']||
        $_SERVER['XCNOOL_FORWARDED_FOR']||
        $_SERVER['XCNOOL_REMOTE_ADDR']        )
        {
                echo "L2 PROXY\n";
        }

elseif (
        $_SERVER['MT-PROXY-ID']||
        $_SERVER['PROXY-AGENT']||
        $_SERVER['PROXY-CONNECTION']||
        $_SERVER['SURROGATE-CAPABILITY']||
        $_SERVER['VIA']||
        $_SERVER['X-ACCEPT-ENCODING']||
        $_SERVER['X-ARR-LOG-ID']||
        $_SERVER['X-AUTHENTICATED-USER']||
        $_SERVER['X-BLUECOAT-VIA']||
        $_SERVER['X-CACHE']||
        $_SERVER['X-CID-HASH']||
        $_SERVER['X-CONTENT-OPT']||
        $_SERVER['X-D-FORWARDER']||
        $_SERVER['X-FIKKER']||
        $_SERVER['X-FORWARDED-PORT']||
        $_SERVER['X-FORWARDED-PROTO']||
        $_SERVER['X-IMFORWARDS']||
        $_SERVER['X-LOOP-CONTROL']||
        $_SERVER['X-MATO-PARAM']||
        $_SERVER['X-NAI-ID']||
        $_SERVER['X-NOKIA-GATEWAY-ID']||
        $_SERVER['X-NOKIA-LOCALSOCKET']||
        $_SERVER['X-ORIGINAL-URL']||
        $_SERVER['X-PROXY-ID']||
        $_SERVER['X-ROAMING']||
        $_SERVER['X-TEAMSITE-PREREMAP']||
        $_SERVER['X-TINYPROXY']||
        $_SERVER['X-TURBOPAGE']||
        $_SERVER['X-VARNISH']||
        $_SERVER['X-VIA']||
        $_SERVER['X-WAP-PROFILE']||
        $_SERVER['X-WRPROXY-ID']||
        $_SERVER['X-XFF-0']||
        $_SERVER['XROXY-CONNECTION']        )
        {
                echo "L3 PROXY\n";
        }

else
        {
                echo "ELITE PROXY\n";
                exit;
        }

print_r($_SERVER);
exit;

?>

