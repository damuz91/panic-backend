# Backend boton de pánico
Backend de la Aplicación de botón de Pánico, creada por David Muñoz para el canal EstoyProgramando[https://www.youtube.com/c/estoyprogramando]

# Acerca de
Este proyecto es creado en Ruby on Rails 7 con Ruby 3. Es parte de una serie de aplicaciones que creé a manera de demostración para las listas de reproducción de cómo crear aplicaciones que moneticen.

https://www.youtube.com/playlist?list=PLKdf6-2FoMDRhoHmKPxpU2iIWMAVNiOq-

Para ver el repositorio del frontend: https://github.com/damuz91/panic-frontend

# Aplicación
Esta aplicación cuenta con pocos componentes. Especialmente en el controlador de `messages` en donde estan 2 endpoints (Podría ser uno solo, pero es para fines educativos). A su vez las acciones de este controlador llaman a un servicio que llama a otros servicios.

Los servicios llaman a APIs externas para enviar SMS, Email y llamadas telefónicas.

Yo pago a esas APIs, por lo que oculto las api keys en mis variables de entorno, pero ustedes pueden usar el servicio que quieran modificando cada uno de los servicios, y agregando su propio archivo .env

Este archivo .env debe verse asi:
```
# Aqui las variables de entorno
SMS_API_KEY=XXX
EMAIL_API_KEY=XXX
API_KEY_HEADER=XXX
SECRET_KEY_BASE=XXX
```

No deje un scaffold del archivo .env para evitar que alguno suba en sus repositorios sus claves secretas accidentalmente.

Adicionalmente hay una acción en el messages controller en donde se comprueba la existencia de un header, esto lo coloqué intencionalmente para que externos no consuman mi API. Ustedes deben asegurarse que este valor sea el mismo y secreto en la aplicación de Frontend. Hay mecanismos más avanzados para proteger los backend, pero no los implementé para no alargar el proyecto.

Mi versión de producción incluye un mecanismo de rechazo de solicitudes adicional, pero ustedes pueden extenderlo o dejarlo asi.

Para la DB de producción uso SQLite, ya que no espero tener alta concurrencia y asi me evito instalar servicios y agregar dependencias. Una versión mas robusta de esta app puede usar una base de datos tipo SQL o NoSQL.

En local iniciar con el comando `rails s -b 0.0.0.0` esto permitirá conexión desde los emuladores de la app en Flutter, siempre que estén en la misma red.

# Despliegue

Pueden ver en mi canal el video donde explico como hacer deploy de una app de ruby on rails, también tengo artículos en Medium. Con esta infraestructura uso la gema mina para poder hacer despliegue mediante el uso de un bash script que ejecuta la gema. Solo se debe modificar el archivo deploy.rb

A la hora de hacer despliegue, se debe crear, migrar y seedear la base de datos.
Cuando se seede la base de datos sadrá un mensaje indicando el admin y el password por defecto, se debe anotar ya que no se puede recuperar, aunque se puede cambiar desde la consola.
Luego se debe copiar los archivos de production.sqlite3* en la carpeta shared/storage para que subsecuentes deployments hagan symlink y no se pierda la base de datos en cada deploy.