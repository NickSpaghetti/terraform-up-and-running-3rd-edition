#!/bin/zsh
cat > index.html << EOF
<h1>Hello, World<h1>
<p>Db address: ${db_address}</p>
<p>Db port: ${db_port}</p>
EOF

nohup busybox httpd -f -p ${server_port}&