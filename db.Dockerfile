FROM kimaudwns/db:v1
EXPOSE 1521 5500
ENV DB_USER=C##admin
ENV DB_PASS=046677kk
CMD lsnrctl start && sqlplus "/ as sysdba" <<EOF
startup;
EOF
