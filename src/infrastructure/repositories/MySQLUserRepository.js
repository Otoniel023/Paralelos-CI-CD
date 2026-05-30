const IUserRepository = require('../../domain/user/IUserRepository');
const User = require('../../domain/user/User');
const pool = require('../../config/database');

class MySQLUserRepository extends IUserRepository {
  async findAll() {
    const [rows] = await pool.query('SELECT * FROM usuarios WHERE activo = 1');
    return rows.map(row => new User(row));
  }

  async findById(id) {
    const [rows] = await pool.query('SELECT * FROM usuarios WHERE id = ? AND activo = 1', [id]);
    return rows[0] ? new User(rows[0]) : null;
  }

  async findByEmail(email) {
    const [rows] = await pool.query('SELECT * FROM usuarios WHERE email = ?', [email]);
    return rows[0] ? new User(rows[0]) : null;
  }

  async create(userData) {
    const { nombre, apellido, email, password, rol } = userData;
    const [result] = await pool.query(
      'INSERT INTO usuarios (nombre, apellido, email, password, rol) VALUES (?, ?, ?, ?, ?)',
      [nombre, apellido, email, password, rol || 'cliente']
    );
    return this.findById(result.insertId);
  }

  async update(id, userData) {
    const fields = [];
    const values = [];

    if (userData.nombre)   { fields.push('nombre = ?');   values.push(userData.nombre); }
    if (userData.apellido) { fields.push('apellido = ?'); values.push(userData.apellido); }
    if (userData.email)    { fields.push('email = ?');    values.push(userData.email); }
    if (userData.password) { fields.push('password = ?'); values.push(userData.password); }
    if (userData.rol)      { fields.push('rol = ?');      values.push(userData.rol); }

    if (fields.length === 0) return this.findById(id);

    values.push(id);
    await pool.query(`UPDATE usuarios SET ${fields.join(', ')} WHERE id = ?`, values);
    return this.findById(id);
  }

  async delete(id) {
    await pool.query('UPDATE usuarios SET activo = 0 WHERE id = ?', [id]);
    return true;
  }
}

module.exports = MySQLUserRepository;
