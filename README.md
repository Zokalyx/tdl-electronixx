# Tdl

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## 🛠️ Cómo hacer un cambio en la base de datos (DB)

Cuando necesites agregar, modificar o eliminar columnas o tablas en la base de datos, seguí estos pasos:

### 1️⃣ Crear una migración

Usá el comando:

```bash
mix ecto.gen.migration nombre_de_la_migracion
```

Esto va a generar un archivo de migración vacío en el directorio:

```
priv/repo/migrations/
```

El nombre del archivo será algo como:

```
20250531183045_nombre_de_la_migracion.exs
```

La parte inicial (`20250531183045`) es una marca de tiempo para asegurar que las migraciones se ejecuten en orden cronológico.

📝 **Tips para nombrar tu migración**:
- Usá verbos que describan claramente el cambio (por ejemplo: `add_username_to_users`, `remove_email_from_users`, `create_posts_table`).
- Siempre en inglés para mantener consistencia si el resto del proyecto está en inglés.

#### 📌 Ejemplo:

```bash
mix ecto.gen.migration add_username_to_users
```

Esto genera un archivo de migración que podés editar para modificar la estructura de la tabla:

```elixir
defmodule Tdl.Repo.Migrations.AddUsernameToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :username, :string
    end
  end
end
```

---

### 2️⃣ Ejecutar la migración

Una vez creada y editada la migración, aplicala con:

```bash
mix ecto.migrate
```

Este comando:

- Conecta con la base de datos configurada.
- Ejecuta todas las migraciones pendientes (no ejecutadas aún).
- Aplica los cambios (crear tablas, agregar/eliminar columnas, índices, etc.).
- Guarda un registro de qué migraciones ya se ejecutaron (en la tabla `schema_migrations`).

💡 Si algo sale mal y querés deshacer la última migración, podés usar:

```bash
mix ecto.rollback
```

---

### 3️⃣ Actualizar el esquema del modelo (`schema`)

Después de modificar la estructura de la tabla en la migración, actualizá el archivo del modelo en:

```
lib/tdl/nombre_del_modelo.ex
```

#### 📌 Ejemplo:

Si modificaste la tabla `users` y agregaste la columna `username`, asegurate de incluirla en el esquema:

```elixir
schema "users" do
  field :username, :string
  # otros campos...
end
```

Y si agregaste validaciones o constraints, no olvides actualizar también la función `changeset/2`.

---

✅ ¡Y listo! Con esos tres pasos ya habrás realizado un cambio completo y funcional en tu base de datos.

---

## 🔐 Cómo configurar los accesos a la base de datos

Para que la aplicación pueda conectarse correctamente a la base de datos, necesitás completar la configuración en:

```
envs/.env
```

Buscá (o agregá) esta sección:

```env
# Database configuration
DB_USERNAME=nombre_de_usuario
DB_PASSWORD="contraseña_secreta"
DB_NAME=tdl_repo
DB_HOST=ip_o_nombre_del_servidor
DB_PORT=puerto
```

### 📝 Ejemplo real:

```env
# Database configuration
DB_USERNAME=haha
DB_PASSWORD="pa$$w0rd"
DB_NAME=tdl_repo
DB_HOST=19.05.96.113
DB_PORT=5432
```

🔒 **Importante**:

- No subas tus credenciales reales a Git (usá `.gitignore` para ocultar archivos con datos sensibles si es necesario).
- En entornos productivos, lo ideal es usar variables de entorno para estos valores.

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
