FROM kimaudwns/db:v1
EXPOSE 1521 5500
ENV DB_USER=admin
ENV DB_PASS=046677kk
ENV ORACLE_SID=ORCLCDB
CMD lsnrctl start && sqlplus "/ as sysdba" <<EOF
startup;
EOF
