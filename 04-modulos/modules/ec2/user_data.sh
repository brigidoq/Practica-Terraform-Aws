#!/bin/bash
yum update -y
yum install -y httpd

# Crear página web
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>${project_name} - ${environment}</title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 40px; 
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .header { 
            background-color: #232f3e; 
            color: white;
            padding: 20px; 
            border-radius: 5px;
            text-align: center;
        }
        .content { 
            margin-top: 20px; 
            padding: 20px;
        }
        .info-box {
            background-color: #e8f4f8;
            border-left: 4px solid #00a2c7;
            padding: 15px;
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 ${project_name}</h1>
            <h2>Ambiente: ${environment}</h2>
        </div>
        <div class="content">
            <div class="info-box">
                <h3>📋 Información de la Instancia</h3>
                <p><strong>Proyecto:</strong> ${project_name}</p>
                <p><strong>Ambiente:</strong> ${environment}</p>
                <p><strong>Servidor:</strong> $(hostname)</p>
                <p><strong>IP Privada:</strong> $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)</p>
                <p><strong>Zona de Disponibilidad:</strong> $(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)</p>
                <p><strong>Fecha de Creación:</strong> $(date)</p>
            </div>
            <div class="info-box">
                <h3>🏗️ Creado con Terraform Modules</h3>
                <p>Esta instancia fue creada usando módulos de Terraform para AWS.</p>
                <p>Demuestra el poder de la infraestructura como código modular.</p>
            </div>
        </div>
    </div>
</body>
</html>
EOF

systemctl start httpd
systemctl enable httpd

# Configurar log personalizado
echo "$(date): Instancia ${project_name}-${environment} iniciada correctamente" >> /var/log/terraform-app.log