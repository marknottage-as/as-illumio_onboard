rm -fr /opt/illumio_ven_data/tmp &&
umask 026 &&
mkdir -p /opt/illumio_ven_data/tmp &&
#curl --tlsv1 "https://us-scp7.illum.io:443/api/v22/software/ven/image?pair_script=pair.sh&profile_id=1683" -o /opt/illumio_ven_data/tmp/prepare.sh &&
curl --insecure "https://us-scp7.illum.io:443/api/v22/software/ven/image?pair_script=pair.sh&profile_id=1683" -o /opt/illumio_ven_data/tmp/prepare.sh &&
chmod +x /opt/illumio_ven_data/tmp/prepare.sh &&
# vi /opt/illumio_ven_data/tmp/pair.sh &&
/opt/illumio_ven_data/tmp/prepare.sh --management-server us-scp7.illum.io:443 --activation-code 170083d32da56bb7b614ddac49867845eb806b58b86fa86f2629f80a69c2d6397dbf88fc26ebbe6bd
