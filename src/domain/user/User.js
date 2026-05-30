class User {
  constructor({ id, nombre, apellido, email, password, rol, activo, created_at, updated_at }) {
    this.id = id;
    this.nombre = nombre;
    this.apellido = apellido;
    this.email = email;
    this.password = password;
    this.rol = rol;
    this.activo = activo;
    this.created_at = created_at;
    this.updated_at = updated_at;
  }

  toPublic() {
    const { password, ...publicData } = this;
    return publicData;
  }
}

module.exports = User;
