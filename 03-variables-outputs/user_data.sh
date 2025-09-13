#!/bin/bash
yum update -y
yum install -y httpd

# Crear página web personalizada
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${app_name} - ${environment}</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background-color: #f0f0f0; padding: 20px; border-radius: 5px; }
        .content { margin-top: 20px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>¡Hola desde ${app_name}!</h1>
        <h2>Instancia #${instance_number}</h2>
    </div>
    <div class="content">
        <p><strong>Ambiente:</strong> ${environment}</p>
        <p><strong>Aplicación:</strong> ${app_name}</p>
        <p><strong>Instancia:</strong> ${instance_number}</p>
        <p><strong>Creado con:</strong> Terraform</p>
        <p><strong>Fecha:</strong> $(date)</p>
    </div>
</body>
</html>
EOF

systemctl start httpd
systemctl enable httpd