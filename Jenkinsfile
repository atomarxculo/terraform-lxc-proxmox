pipeline {
    agent any

    parameters {
        string(
            name: 'lxc_count',
            defaultValue: '1',
            description: 'Número de LXC a crear'
        )

        string(
            name: 'lxc_ips',
            defaultValue: '',
            description: 'Lista de IPs separadas por comas. Debe coincidir exactamente con lxc_count'
        )

        string(
            name: 'lxc_name_prefix',
            defaultValue: 'worker',
            description: 'Prefijo del nombre de los LXC'
        )

        activeChoice choiceType: 'PT_CHECKBOX', description: 'Tags seleccionados', filterLength: 1, filterable: false, name: 'lxc_tags', randomName: 'choice-parameter-12757812791494', script: groovyScript(fallbackScript: [classpath: [], oldScript: '', sandbox: true, script: ''], script: [classpath: [], oldScript: '', sandbox: true, script: '''return [
            \'web\',
            \'prod\',
            \'monitoring\',
            \'k8s\',
            \'database\',
            \'internal\'
        ]'''])

        choice choices: ['small', 'medium', 'large'], name: 'template_size'
        activeChoiceHtml choiceType: 'ET_UNORDERED_LIST', name: 'Características LXC', omitValueField: false, randomName: 'choice-parameter-12622150755150', referencedParameters: 'template_size', script: groovyScript(fallbackScript: [classpath: [], oldScript: '', sandbox: true, script: 'return[\'Fallo\']'], script: [classpath: [], oldScript: '', sandbox: true, script: '''if (template_size == \'small\') {
            return [\'1 CPU, 512MB RAM, 5GB de disco\']
        }
        if (template_size == \'medium\') {
            return [\'2 CPU, 2GB RAM, 10GB de disco\']
        }
        if (template_size == \'large\') {
            return [\'4 CPU, 4GB RAM, 20GB de disco\']
        }'''])
    }

    environment {
        PROXMOX_API_URL = 'https://192.168.1.200:8006/api2/json'
        PROXMOX_NODE = 'proxmox01'
        PROXMOX_TOKEN_ID = credentials('proxmox_token_id')
        PROXMOX_TOKEN_SECRET = credentials('proxmox_token_secret')
    }

    stages {

        stage('Clone repo') {
            steps {
                git credentialsId: 'gitlab-token',
                    url: 'https://gitlab.example.org/sys-tools/terraform-proxmox'
            }
        }

        stage('Validate IPs & Generate names') {
            steps {
                sh '''
                    #!/bin/sh
                    set -eu

                    # Validar variables de entorno
                    if [ -z "${lxc_ips:-}" ]; then
                        echo "lxc_ips no puede estar vacío"
                        exit 1
                    fi

                    # Contar IPs (sustituyendo comas por espacios para iterar)
                    IP_COUNT=0
                    IPS_SPACE=$(echo "$lxc_ips" | tr ',' ' ')
                    for ip in $IPS_SPACE; do
                        IP_COUNT=$((IP_COUNT + 1))
                    done

                    if [ "$IP_COUNT" -ne "$lxc_count" ]; then
                        echo "El número de IPs ($IP_COUNT) no coincide con lxc_count ($lxc_count)"
                        exit 1
                    fi

                    echo "Comprobando IPs con nmap..."
                    for ip in $IPS_SPACE; do
                        if nmap -sn "$ip" | grep -q "Host is up"; then
                            echo "La IP $ip está en uso"
                            exit 1
                        fi
                    done

                    echo "Todas las IPs están libres"

                    echo "Generando nombres de LXC..."
                    LXC_NAMES=""
                    i=1
                    while [ "$i" -le "$lxc_count" ]; do
                        # Generar padding manual para el número (01, 02...)
                        num=$(printf "%02d" "$i")
                        name="${lxc_name_prefix}${num}"

                        # Concatenar con coma
                        if [ -z "$LXC_NAMES" ]; then
                            LXC_NAMES="$name"
                        else
                            LXC_NAMES="$LXC_NAMES,$name"
                        fi

                        i=$((i + 1))
                    done

                    # Escribir la variable
                    echo "LXC_NAMES=$LXC_NAMES" > lxc_vars.env

                '''
            }
        }

        stage('Init terraform') {
            steps {
                sh '''
                    cd terraform/lxc
                    terraform init -reconfigure
                '''
            }
        }

        stage('Build terraform') {
            steps {
                sh '''
                    set -e
                    . ./lxc_vars.env

                    cd terraform/lxc
                    terraform apply -auto-approve \
                      -var proxmox_api_url="$PROXMOX_API_URL" \
                      -var proxmox_node="$PROXMOX_NODE" \
                      -var proxmox_token_id="$PROXMOX_TOKEN_ID" \
                      -var proxmox_token_secret="$PROXMOX_TOKEN_SECRET" \
                      -var lxc_count="$lxc_count" \
                      -var lxc_ips="$lxc_ips" \
                      -var lxc_names="$LXC_NAMES" \
                      -var lxc_tags="$lxc_tags" \
                      -var lxc_size="$template_size" \
                      -var lxc_password="12345"
                '''
            }
        }

        stage('Trigger apply-ansible') {
            steps {
                script {
                    def tagsString = (lxc_tags instanceof List) ? lxc_tags.join(',') : (lxc_tags ?: '')
            
                    build job: 'apply-ansible', parameters: [
                    string(name: 'lxc_ips', value: lxc_ips),
                    string(name: 'lxc_tags', value: tagsString)
                    ]
                }
            }
        }
    }

    post {
        always {
            cleanWs()    
        }
    }
}
