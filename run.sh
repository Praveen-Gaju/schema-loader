## creating /app folder and doing schema setup as per requirement
git clone https://github.com/Praveen-Gaju/$2.git /app
cd /app

## schema types mongo and mysql
case $1 in
  mongo)
    curl -L https://truststore.pki.rds.amazonaws.com/us-east-1/us-east-1-bundle.pem -o /app/rds-combined-ca-bundle.pem
    mongo --ssl \
    --host $(aws ssm get-parameter --name ${env}.docdb.endpoint --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g'):27017 \
    --sslCAFile /app/rds-combined-ca-bundle.pem \
    --username $(aws ssm get-parameter --name ${env}.docdb.user --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
    --password $(aws ssm get-parameter --name ${env}.docdb.password --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') </app/schema/${2}.js
    ;;
  mysql)
    mysql -h $(aws ssm get-parameter --name ${env}.rds.endpoint --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
    -u$(aws ssm get-parameter --name ${env}.rds.user --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') \
    -p$(aws ssm get-parameter --name ${env}.rds.password --with-decryption | jq '.Parameter.Value' | sed -e 's/"//g') < /app/schema/${2}.sql
    ;;
  *)
    echo schema loading supported only for mongo and mysql
    exit 1
    ;;
esac