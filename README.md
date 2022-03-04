# DOCKER PHP 8.1 FPM + MYSQL 5.7 + NGINX

Receta base de __docker-compose__ para levantar algún proyecto con __php v8.1__

Dentro de la configuración del __Dockerfile__, instala __composer__.

## ¿Cómo usar esta receta con un proyecto php - Sin Frameworks?

1. Clonar esta receta de docker: [https://github.com/DianaPonceR/docker-php-8-1-mysql-nginx.git](https://github.com/DianaPonceR/docker-php-8-1-mysql-nginx.git)
2. Renombrar el archivo `.env-example` a solo `.env`
3. Editar la línea 6 del archivo `nginx/conf.d/default.conf` y eliminar: `<name-directory>/public`

   ```bash
   root /var/www/<name-directory>/public;
   
   # debe quedar así:
   root /var/www;
   ```
   
4. Dentro del directorio `/src` crear el archivo `index.php` con el siguiente contenido:

       ```php
       <?php
       // index.php

       try {
            echo 'Current PHP version: ' . phpversion();
            echo '<br />';
    
            $host = 'db';
            $dbname = 'database';
            $user = 'user';
            $pass = 'pass';
            $dsn = "mysql:host=$host;dbname=$dbname;charset=utf8";
            $conn = new PDO($dsn, $user, $pass);
    
            echo 'Database connected successfully';
            echo '<br />';
       } catch (\Throwable $t) {
            echo 'Error: ' . $t->getMessage();
            echo '<br />';
       }
       ```
      
5. Correr el comando desde la raiz de este repo:

   ```bash
   docker-compose up
   ```
6. En caso de necesitar reconstruir la imagen, correr los siguientes comandos:

    ```bash
   docker-compose down
   docker-compose up --build
   
   # reconstruir imagen en el background
   docker-compose up --build -d
   ```
7. Correr algún comando de `composer` desde fuera del contenedor. Por ejemplo:

   ```bash
   docker exec php-unit-herencia composer require phpunit/phpunit
   ```


## ¿Cómo usar esta receta con un proyecto existente de laravel v9.x?

1. Clonar esta receta de docker: [https://github.com/DianaPonceR/docker-php-8-1-mysql-nginx.git](https://github.com/DianaPonceR/docker-php-8-1-mysql-nginx.git)
2. Dentro del directorio `/src` deberás clonar tu proyecto laravel. De tal manera que quede ubicado de la siguiente forma: `/src/laravel-app/`
3. Editar la línea 6 del archivo `nginx/conf.d/default.conf` y reemplazar `<laravel-app>` por el nombre del directorio en donde vive el proyecto laravel:

   ```bash
   root /var/www/<laravel-app>/public;
   ```

4. Editar la línea 27 del archivo `php.Dockerfile` y reemplazar `<laravel-app>` por el nombre del directorio donde vive el proyecto laravel:
   
   ```bash
   WORKDIR /var/www/<laravel-app>
   ```
   
5. Editar la línea 8 del archivo `docker-compose.yml` y reemplazar `<laravel-app>` por el nombre del directorio donde vive el proyecto laravel:

   ```bash
   working_dir: /var/www/<laravel-app>
   ```
   
6. Desde la terminal y en la raíz de la receta docker, correr el siguiente comando para instalar las dependencias del proyecto laravel:
   
   ```bash
   docker exec <container-name> composer install
   ```
   
   Otra forma es entrar al contendor del servicio `app` y ejecutar el comando. Para esto se tiene que usar el nombre del servicio `app`:

   ```bash
   docker exec -it <container-name> bash
   composer install
   ```

7. Desde la terminal y en la raíz de la receta docker, correr el comando que levanta los contenedores (por primera vez):

   ```bash
   docker-compose up
   ```
   
8. En caso de necesitar reconstruir la imagen, correr los siguientes comandos:

    ```bash
   docker-compose down
   docker-compose up --build
   
   # reconstruir imagen en el background
   docker-compose up --build -d
   ```
9. Correr algún comando de `composer` o `artisan` desde fuera del contenedor. Por ejemplo:

   ```bash
   # composer
   docker exec <container-name> composer require phpunit/phpunit
   
   # artisan
   docker exec <container-name> artisan make:model -cmf
   ```
   
---

## ¿CÓMO CREAR UN PROYECTO LARAVEL v9.x CON ESTA RECETA?

1. Levantar este proyecto como se indica en el proceso anterior.
2. Entrar al contenedor del servicio `app`usando el siguiente comando:

   ```bash
   docker exec -it <container-name> bash
   ```
3. Una vez dentro, instalar `laravel` con el siguiente comando
   
   ```bash
   composer global require laravel/installer
   ```

4. Ejecutar los siguientes dos comandos:

   ```bash
   echo 'export PATH="$HOME/.composer/vendor/bin:$PATH"' >> ~/.bashrc
   source ~/.bashrc
   ```
   
5. Verificar que ya se tiene el comando `laravel` disponible:

   ```bash
   laravel --version
   # Laravel Installer 4.2.10
   ```

6. Crear el proyecto laravel con el siguiente comando:

   ```bash
   laravel new app-name
   ```