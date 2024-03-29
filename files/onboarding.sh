rm -fr /opt/illumio_ven_data/tmp &&
umask 026 &&
  # use next 2 to replace umask command, if it's missing on workloads
mkdir -p /opt/illumio_ven_data/tmp &&
  #chmod -R 751 /opt/illumio_ven_data/tmp &&
# need to use --insecure curl on legacy systems with outdated certs
curl --tlsv1 "https://us-scp7.illum.io:443/api/v22/software/ven/image?pair_script=pair.sh&profile_id=1683" -o /opt/illumio_ven_data/tmp/pair.sh &&
#curl -k "https://us-scp7.illum.io:443/api/v22/software/ven/image?pair_script=pair.sh&profile_id=1683" -o /opt/illumio_ven_data/tmp/pair.sh &&
chmod +x /opt/illumio_ven_data/tmp/pair.sh &&
# if troubleshooting a specific endpoint, remove code that deletes pair.sh after it's run
# vi /opt/illumio_ven_data/tmp/pair.sh &&
#/opt/illumio_ven_data/tmp/pair.sh --insecure --management-server us-scp7.illum.io:443 --activation-code 170083d32da56bb7b614ddac49867845eb806b58b86fa86f2629f80a69c2d6397dbf88fc26ebbe6bd
/opt/illumio_ven_data/tmp/pair.sh --management-server us-scp7.illum.io:443 --activation-code 170083d32da56bb7b614ddac49867845eb806b58b86fa86f2629f80a69c2d6397dbf88fc26ebbe6bd
