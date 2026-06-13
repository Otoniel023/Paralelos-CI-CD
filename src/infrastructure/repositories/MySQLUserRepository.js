const IUserRepository = require('../../domain/user/IUserRepository');
const User = require('../../domain/user/User');
const pool = require('../../config/database');

class MySQLUserRepository extends IUserRepository {
  async findAll() {
    const result = await pool.query('SELECT * FROM usuarios WHERE activo = true');
    return result.rows.map(row => new User(row));
  }

  async findById(id) {
    const result = await pool.query('SELECT * FROM usuarios WHERE id = $1 AND activo = true', [id]);
    return result.rows[0] ? new User(result.rows[0]) : null;
  }

  async findByEmail(email) {
    const result = await pool.query('SELECT * FROM usuarios WHERE email = $1', [email]);
    return result.rows[0] ? new User(result.rows[0]) : null;
  }

  async create(userData) {
    const { nombre, apellido, email, password, rol } = userData;
    const result = await pool.query(
      'INSERT INTO usuarios (nombre, apellido, email, password, rol) VALUES ($1, $2, $3, $4, $5) RETURNING id',
      [nombre, apellido, email, password, rol || 'cliente']
    );
    return this.findById(result.rows[0].id);
  }

  async update(id, userData) {
    const fields = [];
    const values = [];

    if (userData.nombre)   { fields.push('nombre = $' + (values.length + 1));   values.push(userData.nombre); }
    if (userData.apellido) { fields.push('apellido = $' + (values.length + 1)); values.push(userData.apellido); }
    if (userData.email)    { fields.push('email = $' + (values.length + 1));    values.push(userData.email); }
    if (userData.password) { fields.push('password = $' + (values.length + 1)); values.push(userData.password); }
    if (userData.rol)      { fields.push('rol = $' + (values.length + 1));      values.push(userData.rol); }

    if (fields.length === 0) return this.findById(id);

    values.push(id);
    await pool.query(`UPDATE usuarios SET ${fields.join(', ')} WHERE id = $${values.length}`, values);
    return this.findById(id);
  }

  async delete(id) {
    await pool.query('UPDATE usuarios SET activo = false WHERE id = $1', [id]);
    return true;
  }
}

module.exports = MySQLUserRepository;
